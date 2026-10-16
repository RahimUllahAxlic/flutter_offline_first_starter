import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/notes/presentation/pages/notes_workspace_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: OfflineFirstStarterApp(),
    ),
  );
}

class OfflineFirstStarterApp extends StatelessWidget {
  const OfflineFirstStarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Offline-First Starter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const NotesWorkspacePage(),
    );
  }
}
