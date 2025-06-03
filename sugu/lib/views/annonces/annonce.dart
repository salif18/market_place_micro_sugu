import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/product_model.dart';

class VosAnnonceView extends StatefulWidget {
  const VosAnnonceView({super.key});

  @override
  State<VosAnnonceView> createState() => _VosAnnonceViewState();
}

class _VosAnnonceViewState extends State<VosAnnonceView> {
  Future<void> deleteProductAndImages({
    required String documentId,
    required List<String> imageUrls,
  }) async {
    try {
      // 🔐 Identifiants Cloudinary
      const String cloudName = 'dm4qhqazr';
      const String apiKey = '993914729256541';
      const String apiSecret = '8EPFv5vn2j3nGugygij30Y67Zt8';

      final dio = Dio();

      for (String imageUrl in imageUrls) {
        // 🔍 1. Extraire le `public_id`
        final uri = Uri.parse(imageUrl);
        final parts = uri.pathSegments;
        final filename = parts.last;
        final folder = parts[parts.length - 2];
        final publicId = '$folder/${filename.split('.').first}';

        // ⏱️ 2. Générer la signature
        final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final signatureBase =
            'public_id=$publicId&timestamp=$timestamp$apiSecret';
        final signature = sha1.convert(utf8.encode(signatureBase)).toString();

        // 📤 3. Appel Dio pour supprimer l’image Cloudinary
        final formData = FormData.fromMap({
          'public_id': publicId,
          'api_key': apiKey,
          'timestamp': timestamp.toString(),
          'signature': signature,
        });

         showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

        final response = await dio.post(
          'https://api.cloudinary.com/v1_1/$cloudName/image/destroy',
          data: formData,
        );

        

        if (response.statusCode == 200 && response.data['result'] == 'ok') {
          print('✅ Image supprimée : $publicId');
        } else {
          print('❌ Échec suppression image : $publicId - ${response.data}');
        }
      }

      // 🗑️ 4. Supprimer le document Firestore
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(documentId)
          .delete();
      print('🗑️ Produit supprimé avec succès');
    } catch (e) {
      print('❗Erreur lors de la suppression : $e');
    }
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
                      .where(
                        'userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                      )
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
                            _showDeleteDialog(context, item);
                            // Action on product tap
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       switch (item.groupe) {
                            //         case "maisons":
                            //           return UpdateAnnonceMaison(item: item);
                            //         case "articles":
                            //           return UpdateAnnonceArticle(item: item);
                            //         case "véhicules, voitures":
                            //           return UpdateAnnonceVehicule(item: item);
                            //         default:
                            //           // Affiche une page vide ou une erreur gentille
                            //           return Scaffold(
                            //             appBar: AppBar(title: Text("Erreur")),
                            //             body: Center(
                            //               child: Text(
                            //                 "Type d'annonce non reconnu",
                            //               ),
                            //             ),
                            //           );
                            //       }
                            //     },
                            //   ),
                            // );
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
                                    item.images.isNotEmpty
                                        ? item.images[0]
                                        : '',
                                    fit: BoxFit.cover,
                                    width: 200.w,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Mdi.eye,
                                          size: 14.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          item.views.toString() + " " + "vues",
                                          style: GoogleFonts.roboto(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
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

  _showDeleteDialog(BuildContext context, item) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.warning_rounded,
                      size: 48.sp,
                      color: Colors.orange[700],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Suppression de produit",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Êtes-vous sûr de vouloir supprimer définitivement votre produit ? "
                    "Cette action est irréversible et toutes vos données seront perdues.",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Annuler",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                          ),
                          onPressed: () {
                            deleteProductAndImages(
                              documentId: item.id,
                              imageUrls: item.images,
                            );
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Supprimer",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
