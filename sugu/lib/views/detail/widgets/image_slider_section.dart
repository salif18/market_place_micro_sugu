import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugu/models/product_model.dart';

class ImageSlider extends StatelessWidget {
  final ProductModel item;
  const ImageSlider({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 250.h, maxHeight: 250.h),
      child: PageView.builder(
        itemCount: item.images.length,
        controller: PageController(
          viewportFraction: 1.0, // plein écran
        ),
        itemBuilder: (context, index) {
          String photo = item.images[index];
          return photo.isNotEmpty
              ? Hero(
                tag: item,
                child: Image.network(
                  photo,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
              );
        },
      ),
    );
  }
}
