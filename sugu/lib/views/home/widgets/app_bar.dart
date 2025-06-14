import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugu/views/search/search.dart';

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
      actions: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: IconButton(
                onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchView()),
            );
          },
              icon: Icon(Icons.search, size: 24.sp, color: Colors.orange)),
          ),
        SizedBox(width: 16.w)
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: Colors.white),
        titlePadding: EdgeInsets.zero,
        // centerTitle: true,
        title: Image.asset(
          "assets/logos/logo.png",
          width: 140.w,
          height: 60.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
