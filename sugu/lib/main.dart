import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sugu/components/splash.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// pour la notification
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

  // FirebaseMessaging.instance.subscribeToTopic('all_users');

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

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> initialize(BuildContext context) async {
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Initialisation de flutter_local_notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //Obtenir le token du téléphone de l'utilisateur
    if (user != null) {
      messaging.getToken().then((token) {
        print("Le fmcToken:$token");
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId);
        docRef.update({
          'fcmToken': token,
          'updatedAt':
              FieldValue.serverTimestamp(), // Optionnel: mettre à jour la date modif
        });
        print('fcmToken mis à jour avec succès');
      });
    }

    // Lire le message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("notification message:${message.notification!.body}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Lorsqu'on clique sur une notification (appli en arrière-plan)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        "Notification ouverte depuis l’arrière-plan : ${message.notification?.body}",
      );
      // Tu passes `context` depuis ton `StatefulWidget`
      handleNotificationNavigation(message, context);
    });
  }
}

void handleNotificationNavigation(RemoteMessage message, BuildContext context) {
  if (message.data.containsKey('screen')) {
    String screen = message.data['screen'];

    // Exemple : si screen == "details", navigue vers page de détails
    if (screen == "details") {
      Navigator.pushNamed(context, '/details');
    }
  }
}
