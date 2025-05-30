import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

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
                background: Container(color: Colors.white,),
                centerTitle: true,
                title: Text(
                  "À propos de ",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 90.r, left: 16.r, right: 16.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/logos/logo.png",
                    fit: BoxFit.cover,
                    width: 200.w,
                    height: 80.h,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Est une application mobile conçue pour les petits commerçants, vendeurs de quartier, artisans et entrepreneurs du Mali. Dans un monde où tout devient numérique, beaucoup de vendeurs locaux n’ont ni boutique en ligne, ni vitrine digitale. Micro Sugu leur offre un espace simple, gratuit et accessible pour présenter leurs produits, toucher plus de clients et développer leur activité. Inspirée du concept Micro Sugu, la plateforme allie modernité et ancrage culturel, en valorisant les acteurs du commerce de proximité tout en leur donnant les outils du digital. Avec Micro Sugu, le marché de chez nous devient connecté.",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
