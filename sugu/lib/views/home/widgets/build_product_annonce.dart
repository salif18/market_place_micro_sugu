import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugu/components/product_item.dart';
import 'package:sugu/models/product_model.dart';

class BuildProductAnnonce extends StatelessWidget {
  const BuildProductAnnonce({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('articles')
              .orderBy('createdAt', descending: true)
              .limit(10)
              .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: const Center(child: Text("Une erreur s'est produite")),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SliverFillRemaining(
            child: const Center(child: Text("Aucun donnés disponibles")),
          );
        } else {
          List<ProductModel> articles =
              snapshot.data!.docs.map((doc) {
                return ProductModel.fromJson(doc.data(), doc.id);
              }).toList();
          return SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 188.h, maxHeight: 188.h),

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                itemBuilder: (context, index) {
                  final item = articles[index];

                  return AspectRatio(
                    aspectRatio: 0.8,
                    child: ProductCard(item: item),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
