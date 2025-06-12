import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildCopyrigth extends StatelessWidget {
  const BuildCopyrigth({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
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
                    child: Icon(
                      Mdi.copyright,
                      size: 12.sp,
                      color: Colors.blueGrey,
                    ),
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
    );
  }
}
