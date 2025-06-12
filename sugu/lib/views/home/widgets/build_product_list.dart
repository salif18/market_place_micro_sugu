import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugu/components/product_item.dart';
import 'package:sugu/models/product_model.dart';

class BuildProductList extends StatefulWidget {
  const BuildProductList({super.key});

  @override
  State<BuildProductList> createState() => _BuildProductListState();
}

class _BuildProductListState extends State<BuildProductList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('articles')
              .orderBy('createdAt', descending: true)
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
          return SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 10.r),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 0.8, // Ajuste pour obtenir une belle carte
              ),
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                ProductModel item = articles[index];
                return ProductCard(item: item);
              }, childCount: articles.length),
            ),
          );
        }
      },
    );
  }
}
