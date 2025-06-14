import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/utils/format_prix.dart';
import 'package:sugu/views/detail/detail.dart';

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  ProductModel item;
  ProductCard({super.key, required this.item});

  FormatPrice _formatPrice = FormatPrice();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SingleView(item: item)),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image produit
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200]!, // couleur de la bordure
                    width: 1.r, // épaisseur de la bordure
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child:
                      item.images.isNotEmpty
                          ? Hero(
                            tag: item,
                            child: Image.network(
                              item.images[0],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/default.png",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                          )
                          : Image.asset(
                            "assets/images/default.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                ),
              ),
            ),
            // Espace
            SizedBox(height: 4.h),
            // Titre
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.r),
                child: Text(
                  item.titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            // Prix
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.r),
                child: Text(
                  _formatPrice.formatNombre(item.prix),
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
