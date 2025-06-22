import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/routes.dart';

class BuildDeleteBouton extends StatelessWidget {
  const BuildDeleteBouton({super.key});

  Future<void> deleteUserAndData(BuildContext context, String userId) async {
    try {
      // 1. Cloudinary infos
      const String cloudName = 'dm4qhqazr';
      const String apiKey = '993914729256541';
      const String apiSecret = '8EPFv5vn2j3nGugygij30Y67Zt8';

      final dio = Dio();

      // 2. Récupérer tous les articles de cet utilisateur
      final articlesSnapshot =
          await FirebaseFirestore.instance
              .collection('articles')
              .where('userId', isEqualTo: userId)
              .get();

      for (var doc in articlesSnapshot.docs) {
        final data = doc.data();

        // 3. Supprimer les images de Cloudinary
        final List<dynamic> imageUrls = data['images'] ?? [];

        for (String imageUrl in imageUrls) {
          final uri = Uri.parse(imageUrl);
          final parts = uri.pathSegments;
          final filename = parts.last;
          final folder = parts[parts.length - 2];
          final publicId = '$folder/${filename.split('.').first}';

          final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          final signatureBase =
              'public_id=$publicId&timestamp=$timestamp$apiSecret';
          final signature = sha1.convert(utf8.encode(signatureBase)).toString();

          final formData = FormData.fromMap({
            'public_id': publicId,
            'api_key': apiKey,
            'timestamp': timestamp.toString(),
            'signature': signature,
          });

          final response = await dio.post(
            'https://api.cloudinary.com/v1_1/$cloudName/image/destroy',
            data: formData,
          );

          if (response.statusCode == 200 && response.data['result'] == 'ok') {
            print('✅ Image supprimée : $publicId');
          } else {
            print('❌ Échec suppression image : $publicId');
          }
        }

        // 4. Supprimer l'article dans Firestore
        await doc.reference.delete();
      }

      // 🔥 Supprimer le document utilisateur de la collection Firestore "users"
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print('📄 Document utilisateur supprimé dans Firestore');

      // 5. Supprimer l'utilisateur Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
        print('🗑️ Compte utilisateur supprimé');
      }

      print('✅ Suppression complète effectuée');
      if (context.mounted) {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyRoots()),
          (route) => false,
        );
      }
    } catch (e) {
      print('❌ Erreur pendant la suppression : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey[200]!),
          ),
        ),
        child: ListTile(
          leading: Icon(Mdi.deleteOutline, size: 20.sp,color: Colors.orange.shade700),
          title: Text(
            "Supprimer votre compte",
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
          onTap: () => _showDeleteAccountDialog(context),
        ),
      ),
    );
  }

  _showDeleteAccountDialog(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.warning_rounded,
                      size: 48.sp,
                      color: Colors.orange[700],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Suppression de compte",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Êtes-vous sûr de vouloir supprimer définitivement votre compte ? "
                    "Cette action est irréversible et toutes vos données seront perdues.",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Annuler",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                          ),
                          onPressed: () {
                            deleteUserAndData(context,user!.uid.toString());
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Supprimer",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
