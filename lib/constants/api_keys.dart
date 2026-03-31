/// Centralized location for external API keys.
/// In production, consider using secure storage or environment variables.
class ApiKeys {
  static const String youtubeDataApi = 'AIzaSyBK6d0Qidol0AGg0OpHewy_8lRsrD3mHGQ';
  static const String googleDriveApi = youtubeDataApi; // enable Drive API for this key
  
  // For uploading, we usually need a Service Account or OAuth Client ID.
  // For now, I'll assume the user might provide these or I'll use placeholders.
  // CRITICAL: We need a service account JSON to upload files without user interaction.
}
