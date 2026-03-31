// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/constants/admin_colors.dart';
import 'package:admin_panel/services/google_drive_service.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class ContentManagementScreen extends StatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  State<ContentManagementScreen> createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  List<drive.File> _videos = [];
  List<drive.File> _folders = [];
  String? _currentFolderId;
  final List<String?> _navHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);
    try {
      final driveService = context.read<GoogleDriveService>();

      // Try fetching content
      final videosList = await driveService.fetchVideos(
        folderId: _currentFolderId,
      );
      final foldersList = await driveService.fetchFolders(
        parentId: _currentFolderId,
      );

      _updateState(foldersList, videosList);
    } catch (e) {
      debugPrint('Error loading content: $e');

      // Fallback: If we're at root and fetch fails (e.g. 404 on placeholder), show shortcuts
      if (_currentFolderId == null) {
        _updateState([], []);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateState(List<drive.File> folders, List<drive.File> videos) {
    // If root is empty or fetch failed, show default programs as shortcuts
    if (_currentFolderId == null && folders.isEmpty && videos.isEmpty) {
      _folders = [
        drive.File()
          ..id = '1qPWnAacTkjHCkrs6VQ_S4vf9FnWToNe_'
          ..name = 'Beginner Program',
        drive.File()
          ..id = '1o9O6RU89zGSFYxrLcgMYJvYYlIRu6oYb'
          ..name = 'Intermediate Program',
        drive.File()
          ..id = '15_QYepWMyvXT4wiwZsjPs04O2gqM5fm3'
          ..name = 'Advanced Program',
        drive.File()
          ..id = '1ngn1VYkA5aRjltDv6d57iJfK_CbwHlbN'
          ..name = 'Yoga Program',
        drive.File()
          ..id = '1hy2BTzFi8pj5wX7mhCxLrJdJqBHNHC5C'
          ..name = 'Pilates Program',
        drive.File()
          ..id = '1ClKJA0P9Qtr5MbWZHwvvVXTKHrpQq6pz'
          ..name = 'Healthy Recipes',
        drive.File()
          ..id = '1USIC342bOiZfyDEVmRyXlpCdtFh7YZ57'
          ..name = 'Mindfulness Library',
      ];
    } else {
      _folders = folders;
    }

    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }

  void _navigateToFolder(String? folderId) {
    if (_currentFolderId != folderId) {
      _navHistory.add(_currentFolderId);
      setState(() {
        _currentFolderId = folderId;
      });
      _loadContent();
    }
  }

  void _goBack() {
    if (_navHistory.isNotEmpty) {
      setState(() {
        _currentFolderId = _navHistory.removeLast();
      });
      _loadContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            if (context.watch<GoogleDriveService>().isAuthInitialized == false)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AdminColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AdminColors.errorRed.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AdminColors.errorRed,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Read-only mode. Authentication is required to upload videos or create programs.',
                        style: TextStyle(
                          color: AdminColors.errorRed,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            Expanded(child: _buildVideoLibrary()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (_navHistory.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _goBack,
                  ),
                const Text(
                  'Content Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Text(
              'Manage your programs, folders, and videos',
              style: TextStyle(color: AdminColors.textLow),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _showCreateFolderDialog,
              icon: const Icon(
                Icons.create_new_folder_rounded,
                color: Colors.white,
              ),
              label: const Text(
                'New Program',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.surfaceLight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _showUploadDialog,
              icon: const Icon(Icons.upload_rounded, color: Colors.white),
              label: const Text(
                'Upload Video',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primaryTeal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoLibrary() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AdminColors.primaryTeal),
      );
    }

    if (_videos.isEmpty && _folders.isEmpty) {
      return const Center(
        child: Text(
          'This folder is empty.',
          style: TextStyle(color: AdminColors.textLow),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_folders.isNotEmpty) ...[
            const Text(
              'Programs & Folders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _folders.length,
              itemBuilder: (context, index) {
                final folder = _folders[index];
                return InkWell(
                  onTap: () => _navigateToFolder(folder.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AdminColors.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AdminColors.surfaceLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.folder_rounded,
                          color: AdminColors.primaryTeal,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            folder.name ?? 'Untitled Folder',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
          if (_videos.isNotEmpty) ...[
            const Text(
              'Videos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _videos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final video = _videos[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AdminColors.surfaceLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: 80,
                          height: 45,
                          color: AdminColors.surfaceLight,
                          child: video.thumbnailLink != null
                              ? Image.network(
                                  video.thumbnailLink!,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 45,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(
                                      Icons.movie_creation_outlined,
                                      color: Colors.white54,
                                      size: 24,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.video_file_outlined,
                                    color: Colors.white54,
                                    size: 24,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.name ?? 'Untitled Video',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'ID: ${video.id}',
                              style: const TextStyle(
                                color: AdminColors.textLow,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showDescriptionDialog(
                          video.id!,
                          video.name ?? 'Untitled Video',
                        ),
                        icon: const Icon(
                          Icons.description_rounded,
                          color: AdminColors.primaryTeal,
                          size: 18,
                        ),
                        label: const Text(
                          'Description',
                          style: TextStyle(
                            color: AdminColors.primaryTeal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AdminColors.errorRed,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showUploadDialog() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return;

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    if (!mounted) return;

    _showLoadingDialog('Uploading Video', 'Uploading $fileName...');

    try {
      await context.read<GoogleDriveService>().uploadVideo(
        file,
        fileName,
        folderId: _currentFolderId,
      );
      if (mounted) Navigator.pop(context); // Close loading dialog
      _loadContent(); // Refresh list
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    }
  }

  Future<void> _showCreateFolderDialog() async {
    final TextEditingController controller = TextEditingController();
    final String? folderName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AdminColors.surfaceDark,
        title: const Text(
          'Create New Program',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Program Name',
            hintStyle: TextStyle(color: AdminColors.textLow),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AdminColors.textLow),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AdminColors.primaryTeal),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (folderName == null || folderName.isEmpty) return;

    _showLoadingDialog('Creating Folder', 'Creating $folderName...');

    try {
      await context.read<GoogleDriveService>().createFolder(
        folderName,
        parentId: _currentFolderId,
      );
      if (mounted) Navigator.pop(context);
      _loadContent();
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create folder: $e')));
      }
    }
  }

  void _showLoadingDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AdminColors.surfaceDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AdminColors.primaryTeal),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(color: AdminColors.textMedium),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDescriptionDialog(String videoId, String videoName) async {
    final TextEditingController controller = TextEditingController();
    bool isSaving = false;

    // Fetch existing description
    try {
      final doc = await FirebaseFirestore.instance
          .collection('video_metadata')
          .doc(videoId)
          .get();
      if (doc.exists) {
        controller.text = doc.data()?['description'] ?? '';
      }
    } catch (e) {
      debugPrint('Error fetching description: $e');
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AdminColors.surfaceDark,
          title: Text(
            'Video Description - $videoName',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter video description here...',
                  hintStyle: const TextStyle(color: AdminColors.textLow),
                  filled: true,
                  fillColor: AdminColors.surfaceLight.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (isSaving)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: LinearProgressIndicator(
                    color: AdminColors.primaryTeal,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AdminColors.textLow),
              ),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      setDialogState(() => isSaving = true);
                      try {
                        await FirebaseFirestore.instance
                            .collection('video_metadata')
                            .doc(videoId)
                            .set({
                              'description': controller.text,
                              'lastUpdated': FieldValue.serverTimestamp(),
                            }, SetOptions(merge: true));
                        if (mounted) Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Description saved successfully'),
                          ),
                        );
                      } catch (e) {
                        setDialogState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save: $e')),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primaryTeal,
              ),
              child: const Text(
                'Save Description',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
