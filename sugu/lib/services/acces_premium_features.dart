import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  Future<bool> canAccessPremiumFeatures() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = doc.data();
    if (data == null) return false;

    final bool isPremium = data['isPremium'] ?? false;
    final DateTime now = DateTime.now();

    final DateTime? subscriptionUntil =
        data['subscriptionUntil'] != null
            ? DateTime.tryParse(data['subscriptionUntil'])
            : null;

    if (isPremium &&
        subscriptionUntil != null &&
        now.isBefore(subscriptionUntil)) {
      return true; // Essai encore actif OU abonnement payant actif
    }

    return false; // Accès refusé (essai expiré ou jamais activé)
  }
}
