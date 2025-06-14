import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:sugu/utils/format_prix.dart';
import 'package:sugu/views/detail/detail.dart';

class FavoriteCard extends StatefulWidget {
  final ProductModel item;
  const FavoriteCard({super.key, required this.item});

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  FormatPrice _formatPrice = FormatPrice();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleView(item: widget.item),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ), // bordure en bas
          ),
        ),
        child: ListTile(
          leading:
              widget.item.images.isNotEmpty
                  ? AspectRatio(
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
                        child: Image.network(
                          widget.item.images[0],
                          // width: 50.w,
                          // height: 50.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/default.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                  : null,
          title: Text(
            widget.item.titre,
            style: GoogleFonts.roboto(fontSize: 12.sp),
          ),
          subtitle: Text(
            _formatPrice.formatNombre(widget.item.prix),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              color: Colors.orange.shade700
            ),
          ),
          trailing: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              List<ProductModel> favorites = favoriteProvider.getFavorites;
              return SizedBox(
                child: IconButton(
                  onPressed: () {
                    favoriteProvider.addMyFavorites(widget.item);
                  },
                  icon:
                      favorites.firstWhereOrNull(
                                (item) => item.id == item.id,
                              ) ==
                              null
                          ? Icon(
                            Icons.bookmark_border_outlined,
                            size: 20.sp,
                            color: Colors.black54,
                          )
                          : Icon(
                            Icons.bookmark,
                            size: 20.sp,
                            color: Colors.black,
                          ),
                ),
              );
            },
          ),
          onTap: () {
            // Naviguer vers la page de détails
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleView(item: widget.item),
              ),
            );
          },
        ),
      ),
    );
  }
}
