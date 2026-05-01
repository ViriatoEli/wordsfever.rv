import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF08080F),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const WordsFeverApp());
}

class WordsFeverApp extends StatelessWidget {
  const WordsFeverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Words Fever',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark.copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(AppTheme.dark.textTheme).apply(
          bodyColor: const Color(0xFFFFFFFF),
          displayColor: const Color(0xFFFFFFFF),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
