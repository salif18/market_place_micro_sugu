import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:sugu/views/auth/connexion.dart';
import 'package:sugu/views/vendre/article.dart';
import 'package:sugu/views/vendre/maison.dart';
import 'package:sugu/views/vendre/vehicule.dart';

class AnnonceView extends StatefulWidget {
  const AnnonceView({super.key});

  @override
  State<AnnonceView> createState() => _AnnonceViewState();
}

class _AnnonceViewState extends State<AnnonceView> {
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
                  "Créer une annonce",
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
              padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 16.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Vendez vos produits en toute simplicité sur le plus grand marché en ligne au Mali gratuitement et en toute sécurité.",
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Publier votre produit aujourd'hui et toucher des millions d'acheteurs potentiels.",
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // L'utilisateur est connecté
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 16.r,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        child: IconButton(
                          onPressed: () {
                            _buildAlertDialog(context);
                          },

                          style: IconButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            minimumSize: Size(40.w, 40.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),

                          icon: Icon(
                            Icons.add_business_outlined,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // L'utilisateur n'est pas connecté
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 16.r,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConnexionView(recentScreen: "vendre"),
                              ),
                            );
                          },

                          style: IconButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            minimumSize: Size(40.w, 40.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),

                          child: Text(
                            'Se connecter',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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

  _buildAlertDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // ajuste selon le clavier
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
            width: double.infinity,
            height: 250.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 10.r,
                  ),
                  child: Text(
                    "Votre objets à vendre",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddArticles(),
                      ),
                    );
                  },
                  label: Text(
                    "Un article",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(Mdi.shopping, size: 24.sp, color: Colors.black),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddVehicules(),
                      ),
                    );
                  },
                  label: Text(
                    "Véhicule",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(Mdi.car, size: 24.sp, color: Colors.black),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMaisons(),
                      ),
                    );
                  },
                  label: Text(
                    "Maison à vendre ou à louer",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(Mdi.home, size: 24.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
