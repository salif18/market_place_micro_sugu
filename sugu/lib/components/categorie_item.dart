import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_view.dart';

class CategoryItem extends StatefulWidget {
  final CategorieModel item;
  const CategoryItem({super.key, required this.item});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int selectedCategoryIndex = 0; 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          setState(() {
          selectedCategoryIndex = widget.item.id;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesView(categoryName: widget.item.name,),
          ),
        );
      },
      child: Column(
        children: [
          // Conteneur de l’icône avec bordure circulaire
          Container(
            width: 45.w,
            height: 45.h, // carré pour une icône ronde
           alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.item.color,
              border: Border.all(color: Colors.grey.shade300, width: 1.r),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.item.icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: SizedBox(
              height: 20.h, // hauteur fixe pour éviter les débordements
              child: Text(
                widget.item.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
