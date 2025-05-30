import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sugu/components/splash.dart';
import 'package:sugu/provider/auth_provider.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  // Définir la couleur et le style de la status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // 👈 ta couleur de fond souhaitée
      statusBarIconBrightness:
          Brightness.dark, // ou Brightness.dark si fond clair
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Micro Sugu',
          debugShowCheckedModeBanner: false,
          home: SafeArea(
            // 👈 SafeArea ici pour éviter les chevauchements avec la status bar
            child: child!,
          ),
        );
      },
      child: MySplashScreen(),
    );
  }
}
