import 'package:admin_panel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants/admin_theme.dart';
import 'screens/admin_shell.dart';

import 'package:provider/provider.dart';
import 'services/google_drive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [Provider(create: (_) => GoogleDriveService())],
      child: const AdminApp(),
    ),
  );
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitJessie Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.darkTheme,
      home: const AdminShell(),
    );
  }
}
