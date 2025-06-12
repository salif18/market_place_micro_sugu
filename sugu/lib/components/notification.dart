import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> initialize(BuildContext context) async {
    // 1. DEMANDE DES PERMISSIONS
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. INITIALISATION DES NOTIFICATIONS LOCALES
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _navigateToScreenFromPayload(payload, context);
        }
      },
    );

    // 3. ENREGISTREMENT DU TOKEN DANS FIRESTORE
    if (user != null) {
      try {
        String? token = await messaging.getToken();
        if (token != null) {
          final userId = user!.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
                'fcmToken': token,
                'updatedAt': FieldValue.serverTimestamp(),
              });
          print('fcmToken mis à jour avec succès : $token');
        }
      } catch (e) {
        print("Erreur lors de la récupération du token : $e");
      }
    }

    // 4. ÉCOUTE DES MESSAGES EN PREMIER PLAN
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
              channelDescription: 'Notifications principales',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: message.data['screen'], // Sert pour la navigation
        );
      }
    });

    // 5. MESSAGE OUVERT EN ARRIÈRE-PLAN
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationNavigation(message, context);
    });

    // 6. MESSAGE CLIQUÉ DEPUIS UNE APP FERMÉE
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationNavigation(initialMessage, context);
    }
  }

  // Redirection locale à partir de payload (notification locale)
  void _navigateToScreenFromPayload(String screen, BuildContext context) {
    if (screen == "details") {
      Navigator.pushNamed(context, '/details');
    }
    // Ajouter ici d'autres cas : ex: /chat, /commandes, etc.
  }
}

// Redirection depuis un message FCM
void handleNotificationNavigation(RemoteMessage message, BuildContext context) {
  if (message.data.containsKey('screen')) {
    String screen = message.data['screen'];
    if (screen == "details") {
      Navigator.pushNamed(context, '/details');
    }
  }
}
