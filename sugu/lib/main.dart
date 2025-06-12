import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sugu/components/notification.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sugu/components/splash.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Permet de declencher la notification en arriere plan meme si app est fermé
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Message reçu en arrière-plan complet : ${message.notification?.body}");
}

void main() async {
  // Définir la couleur et le style de la status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // 👈 ta couleur de fond souhaitée
      statusBarIconBrightness:
          Brightness.dark, // ou Brightness.dark si fond clair
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.subscribeToTopic('notify_all_users');

  // lire la notification en arriere plan
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FavoriteProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Dans votre widget principal
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      NotificationService().initialize(context);
    });
  }

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
