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
            width: 50.w,
            height: 50.w, // carré pour une icône ronde
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: widget.item.color,
              border: Border.all(color: Colors.grey.shade300, width: 1.r),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.item.icon, color: Colors.white, size: 22.sp),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: SizedBox(
              height: 20.h, // hauteur fixe pour éviter les débordements
              child: Text(
                widget.item.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.montserrat(
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
