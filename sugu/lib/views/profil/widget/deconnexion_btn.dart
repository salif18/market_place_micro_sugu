import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/routes.dart';

class BuildLogoutBouton extends StatelessWidget {
  const BuildLogoutBouton({super.key});

  Future<void> signOutAndRedirect(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Déconnecte
      await FirebaseAuth.instance.signOut();

      // Vérifie que le contexte est toujours valide avant la navigation
      if (context.mounted) {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyRoots()),
          (route) => false,
        );
      }
      // Supprimer le fcmToken si possible
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': FieldValue.delete()});
        print('fcmToken supprimé avec succès.');
      }
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
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
          leading: Icon(Mdi.logout, size: 20.sp, color: Colors.black),
          title: Text(
            "Se déconnecter",
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
          onTap: () => _showLogoutDialog(context),
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
                          onPressed: () {
                            Navigator.pop(context, true); // Ferme le dialog
                            signOutAndRedirect(
                              context,
                            ); // Supprime fcmToken + déconnexion
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
