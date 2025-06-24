import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/abonnement/boost.dart';

class BuildBoostBouton extends StatelessWidget {
  const BuildBoostBouton({super.key});

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
          leading: Icon(Mdi.rocketLaunchOutline, size: 20.sp,color: Colors.black),
          title: Text(
            "Booster mes produits",
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BoostPage( amount: 250 , type:"", articleId: "",)),
              ),
        ),
      ),
    );
  }
}
