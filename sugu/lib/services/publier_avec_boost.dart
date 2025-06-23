import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserBoost {
  Future<void> publierArticleAvecBoost(Map<String, dynamic> articleData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final userData = userDoc.data();

    DateTime? expiry = userData?['boostExpiry'] != null
        ? DateTime.parse(userData!['boostExpiry'])
        : null;

    bool boostActive = userData?['boostActive'] ?? false;
    int boostLimit = userData?['boostLimit'] ?? 0;
    int boostUsed = userData?['boostUsed'] ?? 0;

    bool boostValide = boostActive && (expiry != null) && (DateTime.now().isBefore(expiry));
    bool doitBoost = boostValide && (boostUsed < boostLimit);

    articleData['boost'] = doitBoost;
    if (doitBoost) {
     articleData['boostUntil'] = DateTime.now().add(Duration(days: 3)).toIso8601String(); // ✅ AJOUT
    }   
    await FirebaseFirestore.instance.collection('articles').add(articleData);

    if (doitBoost) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'boostUsed': FieldValue.increment(1),
      });
    }
  }

  // booster un produit
Future<void> boosterProduit(String articleId, {int jours = 3}) async {
  final expiration = DateTime.now().add(Duration(days: jours));

  await FirebaseFirestore.instance.collection('articles').doc(articleId).update({
    'boost': true,
    'boostUntil': expiration.toIso8601String(),
  });

  // Enregistrer une transaction facultative
  await FirebaseFirestore.instance.collection('transactions').add({
    'type': 'boost',
    'articleId': articleId,
    'montant': 100,
    'createdAt': FieldValue.serverTimestamp(),
  });

}


}
