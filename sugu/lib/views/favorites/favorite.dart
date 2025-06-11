import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugu/components/favorite_item.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:sugu/views/home/home.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
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
              flexibleSpace: FlexibleSpaceBar(
                background: Container(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "Mes favoris",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(8.0.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
                  child: Text(
                    "Ma liste de souhaits",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                List<ProductModel> myFavorites = favoriteProvider.getFavorites;
                return myFavorites.isNotEmpty
                    ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        ProductModel item = myFavorites[index];
                        return FavoriteCard(item: item);
                      }, childCount: myFavorites.length),
                    )
                    : SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(15.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Text(
                                "Aucuns favoris",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15.r),
                              child: Icon(
                                Icons.favorite_border_sharp,
                                size: 60.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Text(
                                "Ajouter des articles dans vos favoris",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF1D1A30),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.r),
                              child: Text(
                                "Regrouper ici les articles qui vous interressent et envoyer-les a l'entreprise",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(25.r),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeView(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  minimumSize: Size(400.w, 40.h),
                                ),
                                child: Text(
                                  "Fais un tour au marché",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
