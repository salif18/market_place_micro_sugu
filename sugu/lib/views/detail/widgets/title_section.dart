import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/utils/format_prix.dart';

// ignore: must_be_immutable
class TitleSection extends StatelessWidget {
  final ProductModel item;
  TitleSection({super.key, required this.item});
  FormatPrice _formatPrice = FormatPrice();
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              item.titre,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              _formatPrice.formatNombre(item.prix) + " " + "FCFA",
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (item.views! > 0)
              Row(
                children: [
                  Icon(Mdi.eye, size: 18.sp, color: Colors.grey),
                  SizedBox(width: 8.w),
                  Text(
                    item.views.toString() + " " + "vues",
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Mdi.mapMarker, size: 20.sp, color: Colors.blueGrey),
                Text(
                  item.localisation,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
