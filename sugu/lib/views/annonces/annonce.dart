import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/annonces/update_annonce_article.dart';
import 'package:sugu/views/annonces/update_annonce_maison.dart';
import 'package:sugu/views/annonces/update_annonce_vehicule.dart';

class VosAnnonceView extends StatefulWidget {
  const VosAnnonceView({super.key});

  @override
  State<VosAnnonceView> createState() => _VosAnnonceViewState();
}

class _VosAnnonceViewState extends State<VosAnnonceView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0.2,
              toolbarHeight: 40.h,
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "Vos annonces",
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('articles')
                      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      // .orderBy('createdAt', descending: true)
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
                      horizontal: 16.r,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 4,
                            childAspectRatio: 0.77,
                          ),
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        ProductModel item = articles[index];

                        return GestureDetector(
                          onTap: () {
                            // Action on product tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  switch (item.groupe) {
                                    case "maisons":
                                      return UpdateAnnonceMaison(item: item);
                                    case "articles":
                                      return UpdateAnnonceArticle(item: item);
                                    case "véhicules":
                                      return UpdateAnnonceVehicule(item: item);
                                    default:
                                      // Affiche une page vide ou une erreur gentille
                                      return Scaffold(
                                        appBar: AppBar(title: Text("Erreur")),
                                        body: Center(
                                          child: Text(
                                            "Type d'annonce non reconnu",
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 200.w,
                            height: 200.h,
                            // margin: EdgeInsets.all(8.r),
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Image.network(
                                     item.images.isNotEmpty ? item.images[0] : '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                SizedBox(height: 10.r),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.r,
                                  ),
                                  child: Text(
                                    item.titre,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.r,
                                    ),
                                    child: Text(
                                      item.prix + " " + "FCFA",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.r,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Mdi.eye, size: 14.sp,),
                                         SizedBox(width: 5.w),
                                         Text(item.views.toString() +" " + "vues",
                        style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.grey,fontWeight: FontWeight.w400),)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
}
