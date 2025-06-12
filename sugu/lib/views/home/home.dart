import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_list.dart';
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

  @override
  void initState() {
    super.initState();
    categories =
        CategorieModel.getCategory()..sort((a, b) => b.name.compareTo(a.name));
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
              BuildCategoriList(sortedCategories: categories),
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
