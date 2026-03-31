import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import '../constants/api_keys.dart';

class GoogleDriveService {
  // TODO: Update this folder ID to your real Root Folder ID that contains Programs
  static const String _folderId = '1234567890abcdefghijklmnopqrstuvwxyz'; 

  final http.Client _httpClient = http.Client();
  drive.DriveApi? _driveApi;

  static const _baseUrl = 'www.googleapis.com';

  bool get isAuthInitialized => _driveApi != null;

  Future<void> initialize(AuthClient client) async {
    _driveApi = drive.DriveApi(client);
  }

  Future<List<drive.File>> fetchVideos({String? folderId}) async {
    final parentId = folderId ?? _folderId;
    
    // Skip if it's the placeholder ID and no auth
    if (parentId == '1234567890abcdefghijklmnopqrstuvwxyz' && _driveApi == null) {
      return [];
    }

    // If we have auth, use it for better performance/limits
    if (_driveApi != null) {
      final list = await _driveApi!.files.list(
        q: "'$parentId' in parents and trashed = false and mimeType contains 'video/'",
        spaces: 'drive',
        $fields: 'files(id, name, mimeType, thumbnailLink, webContentLink, createdTime, description)',
        orderBy: 'name',
      );
      return list.files ?? [];
    }

    // Fallback to API Key for read-only if no auth
    final uri = Uri.https(_baseUrl, '/drive/v3/files', {
      'key': ApiKeys.googleDriveApi,
      'q': "'$parentId' in parents and trashed=false and mimeType contains 'video/'",
      'fields': 'files(id, name, mimeType, thumbnailLink, webContentLink, createdTime, description)',
      'orderBy': 'name',
    });

    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch videos: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final files = (data['files'] as List<dynamic>? ?? []).map((f) => drive.File.fromJson(f as Map<String, dynamic>)).toList();
    return files;
  }

  Future<List<drive.File>> fetchFolders({String? parentId}) async {
    final pid = parentId ?? _folderId;

    // Skip if it's the placeholder ID and no auth
    if (pid == '1234567890abcdefghijklmnopqrstuvwxyz' && _driveApi == null) {
      return [];
    }

    if (_driveApi != null) {
      final list = await _driveApi!.files.list(
        q: "'$pid' in parents and trashed = false and mimeType = 'application/vnd.google-apps.folder'",
        spaces: 'drive',
        $fields: 'files(id, name, createdTime)',
        orderBy: 'name',
      );
      return list.files ?? [];
    }

    final uri = Uri.https(_baseUrl, '/drive/v3/files', {
      'key': ApiKeys.googleDriveApi,
      'q': "'$pid' in parents and trashed=false and mimeType = 'application/vnd.google-apps.folder'",
      'fields': 'files(id, name, createdTime)',
      'orderBy': 'name',
    });

    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch folders: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final files = (data['files'] as List<dynamic>? ?? []).map((f) => drive.File.fromJson(f as Map<String, dynamic>)).toList();
    return files;
  }

  Future<drive.File> createFolder(String name, {String? parentId}) async {
    if (_driveApi == null) throw Exception('Drive API not initialized. Authentication required for creating folders.');

    final folder = drive.File()
      ..name = name
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = [parentId ?? _folderId];

    return await _driveApi!.files.create(folder);
  }

  Future<drive.File> uploadVideo(File file, String name, {String? folderId, String? description}) async {
    if (_driveApi == null) throw Exception('Drive API not initialized. Authentication required for uploading videos.');

    final driveFile = drive.File()
      ..name = name
      ..parents = [folderId ?? _folderId]
      ..description = description;

    final media = drive.Media(file.openRead(), file.lengthSync());
    return await _driveApi!.files.create(driveFile, uploadMedia: media);
  }

  Future<drive.File> uploadCaption(File file, String videoId, String name) async {
    if (_driveApi == null) throw Exception('Drive API not initialized. Authentication required for uploading captions.');

    final driveFile = drive.File()
      ..name = '$name.vtt'
      ..parents = [_folderId];

    final media = drive.Media(file.openRead(), file.lengthSync());
    final captionFile = await _driveApi!.files.create(driveFile, uploadMedia: media);

    final video = await _driveApi!.files.get(videoId) as drive.File;
    final currentDesc = video.description ?? '';
    final newDesc = '$currentDesc\nCAPTION_ID:${captionFile.id}'.trim();
    
    await _driveApi!.files.update(drive.File()..description = newDesc, videoId);
    
    return captionFile;
  }

  Future<String?> getCaptionId(String videoId) async {
    final uri = Uri.https(_baseUrl, '/drive/v3/files/$videoId', {
      'key': ApiKeys.googleDriveApi,
      'fields': 'description',
    });

    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final desc = data['description'] as String? ?? '';
    final match = RegExp(r'CAPTION_ID:([a-zA-Z0-9_-]+)').firstMatch(desc);
    return match?.group(1);
  }

  void dispose() {
    _httpClient.close();
  }
}
