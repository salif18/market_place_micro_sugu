import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildAppBar extends StatelessWidget {
  const BuildAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent, // Couleur opaque
      elevation: 0, // Supprime l'ombre si nécessaire
      toolbarHeight: 45.h,
      pinned: true,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: Colors.white),
        titlePadding: EdgeInsets.zero,
        title: Image.asset(
          "assets/logos/logo.png",
          width: 120.w,
          height: 60.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
