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
import 'package:sugu/utils/format_prix.dart';
import 'package:sugu/views/abonnement/boost.dart';

// ignore: must_be_immutable
class NoBoosting extends StatelessWidget {
  NoBoosting({super.key});

  FormatPrice _formatPrice = FormatPrice();
  Future<void> deleteProductAndImages(
    context, {
    required String documentId,
    required List<String> imageUrls,
  }) async {
    try {
      // 🔐 Identifiants Cloudinary
      const String cloudName = 'dm4qhqazr';
      const String apiKey = '993914729256541';
      const String apiSecret = '8EPFv5vn2j3nGugygij30Y67Zt8';

      final dio = Dio();

      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

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

      Navigator.pop(context, true);
    } catch (e) {
      print('❗Erreur lors de la suppression : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // doit être un sliver, ex: SliverList ou SliverToBoxAdapter
        StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('articles')
                  .where(
                    'userId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .where('boost', isEqualTo: false)
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
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    ProductModel item = articles[index];

                    return GestureDetector(
                      onTap: () {
                        _showDeleteDialog(context, item);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.r),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        clipBehavior:
                            Clip.antiAlias, // permet à l’image d’être arrondie
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Image arrondie automatiquement par clipBehavior
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors
                                            .grey[200]!, // couleur de la bordure
                                    width: 1.r, // épaisseur de la bordure
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child:
                                      item.images.isNotEmpty
                                          ? Stack(
                                            children: [
                                              Image.network(
                                                item.images.isNotEmpty
                                                    ? item.images[0]
                                                    : '',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Image.asset(
                                                    "assets/images/default.png",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  );
                                                },
                                              ),
                                              Positioned(
                                                top: 4.r,
                                                right: 4.r,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => BoostPage(
                                                              amount: 100,
                                                              type: "single",
                                                              articleId:
                                                                  item.id
                                                                      .toString(),
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  icon: Container(
                                                    padding: EdgeInsets.all(
                                                      4.r,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50.r,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          // ignore: deprecated_member_use
                                                          color: Colors.black
                                                              // ignore: deprecated_member_use
                                                              .withOpacity(
                                                                0.15,
                                                              ), // Couleur de l'ombre
                                                          offset: Offset(
                                                            0,
                                                            4,
                                                          ), // Décalage vertical de l'ombre
                                                          blurRadius:
                                                              6, // Flou de l'ombre
                                                          spreadRadius:
                                                              1, // Expansion de l'ombre
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(
                                                      Mdi.rocketLaunch,
                                                      size: 20.sp,
                                                      color: Colors.deepOrange,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Image.asset(
                                            "assets/images/default.png",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.r),
                                child: Text(
                                  item.titre,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.r),
                                child: Text(
                                  _formatPrice.formatNombre(item.prix),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.r),
                                child: Row(
                                  children: [
                                    Icon(
                                      Mdi.eye,
                                      size: 14.sp,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "${item.views} vues",
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
                              context,
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
