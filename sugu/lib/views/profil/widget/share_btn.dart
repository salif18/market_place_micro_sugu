import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/profil/widget/share.dart';

class BuildShareBouton extends StatelessWidget {
  const BuildShareBouton({super.key});

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
          leading: Icon(Icons.share_outlined, size: 20.sp,color: Colors.black),
          title: Text(
            "Partager",
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
          onTap: () => ShareAppUtils.shareApp(context),
        ),
      ),
    );
  }
}
