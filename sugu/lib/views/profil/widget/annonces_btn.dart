import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/annonces/annonce.dart';
import 'package:sugu/views/auth/connexion.dart';

class BuildAnnonceBouton extends StatelessWidget {
  const BuildAnnonceBouton({super.key});

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
          leading: Icon(Mdi.tagOutline, size: 20.sp,color: Colors.black),
          title: Text(
            "Mes annonces",
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
          onTap: () {
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              // L'utilisateur est connecté
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VosAnnonceView()),
              );
            } else {
              // L'utilisateur n'est pas connecté
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConnexionView()),
              );
            }
          },
        ),
      ),
    );
  }
}
