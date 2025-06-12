import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildBannerSection extends StatelessWidget {
  const BuildBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
         padding: EdgeInsets.symmetric(vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/logos/logo3.jpg",
                  fit: BoxFit.cover,
                  height: 110.h,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 110.h,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade600,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 10.r),
                  child: Text(
                    "MicroSugu offre une vitrine numérique à ceux qui vendent au quotidien sans boutique physique.",
                    style: GoogleFonts.lato(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
