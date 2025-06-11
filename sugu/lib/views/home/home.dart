import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/components/categorie_item.dart';
import 'package:sugu/components/product_item.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_list.dart';
import 'package:sugu/views/home/widgets/banner_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List <CategorieModel> categories = CategorieModel.getCategory();
 
  @override
  Widget build(BuildContext context) {
    // Triez les catégories par nom avant de les utiliser
    final sortedCategories = [...categories]
      ..sort((a, b) => b.name.compareTo(a.name));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                backgroundColor: Colors.transparent, // Couleur opaque
                elevation: 0, // Supprime l'ombre si nécessaire
                toolbarHeight: 45.h,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: Colors.white),
                  // centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  title: Image.asset(
                    "assets/logos/logo.png",
                    width: 120.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //Slogan
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r),
                sliver: SliverToBoxAdapter(
                  child: BannerSection()
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Catégories",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategorieListView(),
                            ),
                          );
                        },
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Voir tout ",
                              style: GoogleFonts.roboto(
                                color: Colors.deepOrange,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.deepOrange,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final item = sortedCategories[index]; // Donnée de la catégorie
                    return CategoryItem(item: item);
                  }, childCount: 12),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Annonces récentes",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              StreamBuilder(
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
                    return SliverToBoxAdapter(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 188.h,
                          maxHeight: 188.h,
                        ),

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
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "À vendre",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              StreamBuilder(
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
      ),
    );
  }
}
