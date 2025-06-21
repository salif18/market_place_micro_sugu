import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareAppUtils {
  static Future<void> shareApp(BuildContext context) async {
    const appUrl =
        "https://play.google.com/store/apps/details?id=votre.package.name";
    const message =
        "Découvrez cette super application ! Téléchargez-la ici: $appUrl";

    try {
      // Pour partager uniquement du texte, utilisez Share.share .
      // ignore: deprecated_member_use
      await Share.share(
        message,
        subject: 'Découvrez cette application',
        sharePositionOrigin: Rect.fromLTWH(
          0, 0,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2
        ),
      );
    } catch (e) {
      debugPrint("Erreur lors du partage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de partager pour le moment")),
      );
    }
  }
}
