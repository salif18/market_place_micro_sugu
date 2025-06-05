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
import 'package:sugu/views/about/about.dart';
import 'package:sugu/views/annonces/annonce.dart';
import 'package:sugu/views/auth/connexion.dart';
import 'package:sugu/views/auth/update_pass.dart';
import 'package:sugu/views/help/help.dart';
import 'package:sugu/views/profil/widget/share.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyRoots()),(route)=> false);
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
    }
  }

  Future<void> deleteUserAndData(String userId) async {
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
    } catch (e) {
      print('❌ Erreur pendant la suppression : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white, // Couleur opaque
              elevation: 0, // Supprime l'ombre si nécessaire
              toolbarHeight: 40.h,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "Profil",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 16.r,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 16.r,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child:
                        user != null
                            ? StreamBuilder(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Text(
                                    'Profil utilisateur introuvable.',
                                  );
                                }

                                final userData =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    userData["photo"] != null &&
                                            userData["photo"]
                                                .toString()
                                                .isNotEmpty
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            100.r,
                                          ),
                                          child: Image.network(
                                            userData["photo"],
                                            width: 60.w,
                                            height: 60.h,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : Icon(
                                          Icons.person_outline_rounded,
                                          size: 50.sp,
                                        ),
                                    userData["name"] != null &&
                                            userData["name"]
                                                .toString()
                                                .isNotEmpty
                                        ? Text(
                                          userData["name"],
                                          style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                        : Text(
                                          "Mon Micro Sugu",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),

                                    Text(
                                      userData["email"],
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline_rounded, size: 50.sp),
                                Text(
                                  "Mon Micro Sugu",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                Text(
                                  "example@gmail.com",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.r),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(10.r),
                //       border: Border(
                //         bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                //       ),
                //     ),
                //     child: ListTile(
                //       leading: Icon(
                //         Icons.mode_edit_outline_outlined,
                //         size: 20.sp,
                //       ),
                //       title: Text(
                //         "Modifier profil",
                //         style: GoogleFonts.roboto(
                //           fontSize: 16.sp,
                //           fontWeight: FontWeight.w400,
                //           color: Colors.black,
                //         ),
                //       ),
                //       trailing: Icon(
                //         Icons.arrow_forward_ios_rounded,
                //         size: 18.sp,
                //       ),
                //       onTap:
                //           () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => const ConnexionView(),
                //             ),
                //           ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.tagOutline, size: 20.sp),
                      title: Text(
                        "Mes produits au marché",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () {
                        final user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          // L'utilisateur est connecté
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VosAnnonceView(),
                            ),
                          );
                        } else {
                          // L'utilisateur n'est pas connecté
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConnexionView(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.help, size: 20.sp),
                      title: Text(
                        "Aide",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AideView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.informationOutline, size: 20.sp),
                      title: Text(
                        "A propos de Micro Sugu",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.share_outlined, size: 20.sp),
                      title: Text(
                        "Partager",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => ShareAppUtils.shareApp(context),
                    ),
                  ),
                ),
                if(user != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.securityNetwork, size: 20.sp),
                      title: Text(
                        "Sécurités",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdatePassView(),
                            ),
                          ),
                    ),
                  ),
                ),
                if(user != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.deleteOutline, size: 20.sp),
                      title: Text(
                        "Supprimer votre compte",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => _showDeleteAccountDialog(context),
                    ),
                  ),
                ),
                 if(user == null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.login, size: 20.sp),
                      title: Text(
                        "Se connecter",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnexionView())),
                    ),
                  ),
                ),
                if(user != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.logout, size: 20.sp),
                      title: Text(
                        "Se déconnecter",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ),
                ),
                SizedBox(height: 125.h,),
                Padding(
                  padding: EdgeInsets.symmetric( horizontal:16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.r),
                    height: 50.h,
                    color: Colors.grey[50],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Copyright ",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(Mdi.copyright, size: 12.sp,color: Colors.blueGrey,),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "2025",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Image.asset(
                                  "assets/logos/logo.png",
                                  width: 80.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _showDeleteAccountDialog(BuildContext context) async {
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
                            deleteUserAndData(user!.uid.toString());
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

  _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 48.sp,
                    color: Colors.deepOrange[700],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Déconnexion",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Voulez-vous vraiment vous déconnecter ?",
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
                            padding: EdgeInsets.symmetric(vertical: 14.r),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Non",
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
                            backgroundColor: Colors.deepOrange[700],
                            padding: EdgeInsets.symmetric(vertical: 14.r),
                          ),
                          onPressed: (){
                            signOut(context);
                            Navigator.pop(context,true);
                          },
                          child: Text(
                            "Oui",
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
