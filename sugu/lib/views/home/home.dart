import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/views/home/widgets/app_bar.dart';
import 'package:sugu/views/home/widgets/build_banner_section.dart';
import 'package:sugu/views/home/widgets/build_categori_list.dart';
import 'package:sugu/views/home/widgets/build_product_annonce.dart';
import 'package:sugu/views/home/widgets/build_product_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  late List<CategorieModel> categories;
  bool  numberViewCategory = false ;

  @override
  void initState() {
    super.initState();
    verifierEtDesactiverBoostsExpirs();
    categories =
        CategorieModel.getCategory()..sort((a, b) => a.name.compareTo(b.name));
  }

//mis ajours des boost des produit boost fini delais
  Future<void> verifierEtDesactiverBoostsExpirs() async {
  final now = DateTime.now().toIso8601String(); // ISO 8601 string compatible avec Firestore

  final snapshot = await FirebaseFirestore.instance
      .collection('articles')
      .where('boost', isEqualTo: true)
      .where('boostUntil', isLessThan: now)
      .get();

  for (var doc in snapshot.docs) {
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(doc.id)
        .update({'boost': false});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              BuildAppBar(),
              BuildBannerSection(),
              _buildAllCategory(context),
              BuildCategoriList(sortedCategories: categories, numberViewCategory: numberViewCategory,),
              _buildTitleSection(context, "Annonces récentes"),
              BuildProductAnnonce(),
              _buildTitleSection(context, "À vendre"),
              BuildProductList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategory(BuildContext context,) {
    return SliverPadding(
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
                setState(() {
                  numberViewCategory =! numberViewCategory;
                });
              },
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    numberViewCategory ? "Voir moins " : "Voir tout ",
                    style: GoogleFonts.roboto(
                      color: Colors.orange.shade700,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                   numberViewCategory ? Icons.arrow_circle_up: Icons.arrow_circle_down ,
                    color: Colors.orange.shade700,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, String title) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
