// import 'package:flutter/material.dart';
// import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
// import 'package:url_launcher/url_launcher.dart';

// OPTION 1
// class ShareAppUtils {
//   static Future<void> shareApp(BuildContext context) async {
//     final platform = await showDialog<SocialPlatform>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Partager l'application"),
//         content: const Text("Choisissez une plateforme pour partager l'application"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, SocialPlatform.whatsapp),
//             child:  Row(
//               children: [
//                 Icon(Mdi.whatsapp, color: Colors.green),
//                 SizedBox(width: 8),
//                 Text("WhatsApp"),
//               ],
//             ),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, SocialPlatform.facebook),
//             child: const Row(
//               children: [
//                 Icon(Mdi.facebook, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text("Facebook"),
//               ],
//             ),
//           ),
//            // SMS
//           TextButton(
//             onPressed: () => Navigator.pop(context, SocialPlatform.sms),
//             child: const Row(
//               children: [
//                 Icon(Icons.sms, color: Colors.orange),
//                 SizedBox(width: 8),
//                 Text("SMS"),
//               ],
//             ),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Annuler"),
//           ),
//         ],
//       ),
//     );

//     if (platform != null) {
//       await _shareOnPlatform(platform);
//     }
//   }

//   static Future<void> _shareOnPlatform(SocialPlatform platform) async {
//     const appUrl = "https://play.google.com/store/apps/details?id=votre.package.name";
//     const message = "Découvrez cette super application ! Téléchargez-la ici: $appUrl";

//     String url;
//     switch (platform) {
//       case SocialPlatform.whatsapp:
//         url = "whatsapp://send?text=${Uri.encodeComponent(message)}";
//         break;
//       case SocialPlatform.facebook:
//         url = "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(appUrl)}";
//         break;
//       case SocialPlatform.sms:
//         url = "sms:?body=${Uri.encodeComponent(message)}";
//         break;
//     }

//     try {
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       } else {
//         // Fallback: ouvrir dans le navigateur si l'application n'est pas installée
//         await launchUrl(Uri.parse(appUrl));
//           // Fallback pour SMS si l'application de messagerie n'est pas disponible
//         if (platform == SocialPlatform.sms) {
//           await launchUrl(Uri.parse("sms:?body=${Uri.encodeComponent(message)}"));
//         } else {
//           // Fallback général: ouvrir dans le navigateur
//           await launchUrl(Uri.parse(appUrl));
//         }
//       }
//     } catch (e) {
//       debugPrint("Erreur lors du partage: $e");
//     }
//   }
// }
// enum SocialPlatform { whatsapp, facebook, sms }

// OPTION2
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
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

      // Si vous voulez partager une image avec le texte
      // Pour partager un fichier (image), utilisez Share.shareXFiles :
      // Charger l'image depuis les assets
      // final byteData = await rootBundle.load('assets/logos/logo.png');
      
      // Créer un fichier temporaire
      // final tempDir = await getTemporaryDirectory();
      // final tempFile = File('${tempDir.path}/logo.png');
      // await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      
      // ignore: deprecated_member_use
      // await Share.shareXFiles(
      //   [XFile(tempFile.path)],
      //   text: message,
      //   subject: 'Découvrez cette application',
      //   sharePositionOrigin: Rect.fromLTWH(
      //     0,
      //     0,
      //     MediaQuery.of(context).size.width,
      //     MediaQuery.of(context).size.height / 2,
      //   ),
      // );
    } catch (e) {
      debugPrint("Erreur lors du partage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de partager pour le moment")),
      );
    }
  }
}
