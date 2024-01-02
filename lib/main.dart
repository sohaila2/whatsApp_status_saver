import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/provider/bottom_nav_provider.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';
import 'package:whatsapp_status_saver/provider/image_path.dart';
import 'package:whatsapp_status_saver/provider/theme_provider.dart';
import 'package:whatsapp_status_saver/screens/splash_screen.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>
    BottomNavProvider()),
        ChangeNotifierProvider(create: (_) =>
            GetStatusProvider()),
        ChangeNotifierProvider(create: (_) =>
            ImagePathsProvider()),
        ChangeNotifierProvider(create: (_) =>
            ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getTheme(),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
    },
    ),

    );
  }
}


