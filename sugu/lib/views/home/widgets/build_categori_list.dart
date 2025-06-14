import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugu/components/categorie_item.dart';

class BuildCategoriList extends StatelessWidget {
  final sortedCategories;
  final bool numberViewCategory;
  const BuildCategoriList({super.key, required this.sortedCategories , required this.numberViewCategory});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final item = sortedCategories[index]; // Donnée de la catégorie
          return CategoryItem(item: item);
        }, childCount: numberViewCategory ? 28 : 4),
      ),
    );
  }
}
