import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/components/product_item.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/cat%C3%A9gories/widgets/catego_item.dart';

class CategoriesView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final categoryName;
  const CategoriesView({super.key, required this.categoryName});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late List<CategorieModel> categories;

  @override
  void initState() {
    super.initState();
    categories =
        CategorieModel.getCategory()..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white, // Couleur opaque
              elevation: 0, // Supprime l'ombre si nécessaire
              toolbarHeight: 40.h,
              pinned: true,
              floating: true,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(color: Colors.white),
                title: Text(
                  widget.categoryName,
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            _builTitle(context, "La liste catégories"),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return CategoItem(item: item);
                  },
                ),
              ),
            ),
            _builTitle(context, "Les annonces de la catégorie"),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('articles')
                      .where('categorie', isEqualTo: widget.categoryName)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: const Center(
                      child: Text("Une erreur s'est produite"),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverFillRemaining(
                    child: const Center(
                      child: Text("Aucun donnés disponibles"),
                    ),
                  );
                } else {
                  List<ProductModel> articles =
                      snapshot.data!.docs.map((doc) {
                        return ProductModel.fromJson(doc.data(), doc.id);
                      }).toList();
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 10.r,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            childAspectRatio:
                                0.8, // Ajuste pour obtenir une belle carte
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _builTitle(BuildContext context, String title) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
