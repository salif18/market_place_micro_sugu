import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_view.dart';

class CategoItem extends StatefulWidget {
  final CategorieModel item;
  const CategoItem({super.key, required this.item});

  @override
  State<CategoItem> createState() => _CategoItemState();
}

class _CategoItemState extends State<CategoItem> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.5,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategoryIndex = widget.item.id;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CategoriesView(categoryName: widget.item.name),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color:
                _selectedCategoryIndex == widget.item.id
                    // ignore: deprecated_member_use
                    ? widget.item.color.withOpacity(0.2)
                    : Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: widget.item.color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    widget.item.icon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  widget.item.name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
