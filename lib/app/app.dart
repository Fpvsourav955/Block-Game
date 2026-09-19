import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'routes.dart';

class BlockSurgeApp extends StatelessWidget {
  const BlockSurgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Surge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
