import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class SingleView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final ProductModel item;
  const SingleView({super.key, required this.item});

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> {
  // CAS 2:
  void _contactSellerOnWhatsApp({
    required BuildContext context,
    required String productTitle,
    required String productPrice,
    required String sellerPhone,
    String? productImage,
  }) async {
    try {
      // Message de base
      String message =
          "Bonjour, je suis intéressé par votre produit:\n"
          "*$productTitle*\n"
          "Prix: $productPrice FCFA\n\n"
          "Merci de me contacter pour plus d'informations.";

      // Si on a une image, on essaie de la télécharger et partager
      if (productImage != null && productImage.isNotEmpty) {
        try {
          // Télécharger l'image temporairement
          final response = await http.get(Uri.parse(productImage));
          final documentDirectory = await getTemporaryDirectory();
          final file = File('${documentDirectory.path}/product_image.jpg');
          await file.writeAsBytes(response.bodyBytes);

          // Partager avec le fichier image
          final whatsappUrl =
              "whatsapp://send?phone=$sellerPhone&text=${Uri.encodeComponent(message)}";
          final whatsappBusinessUrl =
              "whatsapp://send?phone=$sellerPhone&text=${Uri.encodeComponent(message)}&file=${file.path}";

          if (await canLaunchUrl(Uri.parse(whatsappBusinessUrl))) {
            await launchUrl(Uri.parse(whatsappBusinessUrl));
          } else if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
            await launchUrl(Uri.parse(whatsappUrl));
          } else {
            throw Exception('WhatsApp non installé');
          }

          return; // On sort après avoir traité avec l'image
        } catch (e) {
          debugPrint("Erreur partage image: $e");
          // Si échec, on continue avec le partage texte seul
        }
      }

      // Fallback: partage texte seul sans image
      final encodedMessage = Uri.encodeComponent(message);
      final whatsappUrl = "https://wa.me/$sellerPhone?text=$encodedMessage";
      final whatsappBusinessUrl =
          "whatsapp://send?phone=$sellerPhone&text=$encodedMessage";

      if (await canLaunchUrl(Uri.parse(whatsappBusinessUrl))) {
        await launchUrl(Uri.parse(whatsappBusinessUrl));
      } else if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WhatsApp n'est pas installé")),
        );
        await launchUrl(
          Uri.parse(
            "https://play.google.com/store/apps/details?id=com.whatsapp",
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    }
  }
  // CAS 1:
  // void _contactSellerOnWhatsApp({
  //   required BuildContext context,
  //   required String productTitle,
  //   required String productPrice,
  //   required String sellerPhone,
  //   String? productImage,
  // }) async {

  //   // Message pré-rempli
  //   String message =
  //       "Bonjour, je suis intéressé par votre produit:\n"
  //       "*$productTitle*\n"
  //       "Prix: $productPrice FCFA\n\n";

  //   if (productImage != null) {
  //     message += "Lien de l'image: $productImage\n\n";
  //   }

  //   message += "Merci de me contacter pour plus d'informations.";

  //   // Encodage du message pour URL
  //   final encodedMessage = Uri.encodeComponent(message);

  //   // URL WhatsApp
  //   final whatsappUrl = "https://wa.me/$sellerPhone?text=$encodedMessage";
  //   final whatsappBusinessUrl =
  //       "whatsapp://send?phone=$sellerPhone&text=$encodedMessage";

  //   // Vérification si WhatsApp est installé
  //   try {
  //     // Essayer WhatsApp Business d'abord
  //     // ignore: deprecated_member_use
  //     if (await canLaunch(whatsappBusinessUrl)) {
  //       // ignore: deprecated_member_use
  //       await launch(whatsappBusinessUrl);
  //       // ignore: deprecated_member_use
  //     } else if (await canLaunch(whatsappUrl)) {
  //       // ignore: deprecated_member_use
  //       await launch(whatsappUrl);
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(
  //         // ignore: use_build_context_synchronously
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("WhatsApp n'est pas installé")));

  //       // Ouvrir le Play Store pour installation
  //       final playStoreUrl =
  //           "https://play.google.com/store/apps/details?id=com.whatsapp.w4b";
  //       // ignore: deprecated_member_use
  //       if (await canLaunch(playStoreUrl)) {
  //         // ignore: deprecated_member_use
  //         await launch(playStoreUrl);
  //       }
  //     }
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(
  //       // ignore: use_build_context_synchronously
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
  //   }
  // }

  List<ProductModel> fakeVehiculeData = ProductModel.getProducts();

  @override
  void initState() {
    super.initState();
    _incrementView(widget.item.id ?? "");
  }

  Future<void> _incrementView(String id) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection("articles").doc(id).update({
        "views": FieldValue.increment(1), // ✅ Incrémentation de 1
      });
    } catch (e) {
      print('Erreur: $e');
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
              backgroundColor: Colors.white, // Couleur opaque
              elevation: 0, // Supprime l'ombre si nécessaire
              toolbarHeight: 40.h,
              pinned: true,
              floating: true,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
              ),
              actions: [
                Consumer<FavoriteProvider>(
                  builder: (context, favoriteProvider, child) {
                    List<ProductModel> favorites =
                        favoriteProvider.getFavorites;
                    return SizedBox(
                      child: IconButton(
                        onPressed: () {
                          favoriteProvider.addMyFavorites(widget.item);
                        },
                        icon:
                            favorites.firstWhereOrNull(
                                      (item) => item.id == widget.item.id,
                                    ) ==
                                    null
                                ? Icon(
                                  Icons.star_border_outlined,
                                  size: 24.sp,
                                  color: Colors.black54,
                                )
                                : Icon(
                                  Icons.star,
                                  size: 24.sp,
                                  color: Colors.amber,
                                ),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(color: Colors.white),
                title: Text(
                  widget.item.titre.split(" ").first,
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child:
              // Galerie d'images horizontale
              SizedBox(
                height: 250.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.item.images.length,
                  itemBuilder: (context, index) {
                    String photo = widget.item.images[index];
                    return Image.network(
                      photo,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.titre,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      widget.item.prix + " " + "FCFA",
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.item.views! > 0)
                      Row(
                        children: [
                          Icon(Mdi.eye, size: 18.sp, color: Colors.grey),
                          SizedBox(width: 8.w),
                          Text(
                            widget.item.views.toString() + " " + "vues",
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Mdi.mapMarker, size: 20.sp, color: Colors.blueGrey),
                    Text(
                      widget.item.localisation,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.item.modele != null &&
                              widget.item.modele!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Modèle",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.item.modele!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          if (widget.item.annee != null &&
                              widget.item.modele!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Année",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.item.annee!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Etat",
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.item.etat,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    SizedBox(width:20.sp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.item.typeCarburant != null &&
                              widget.item.typeCarburant!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Carburant",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.item.typeCarburant!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          if (widget.item.transmission != null &&
                              widget.item.transmission!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transmission",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.item.transmission!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          if (widget.item.kilometrage != null &&
                              widget.item.kilometrage!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kilométrage",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.item.kilometrage! + " " + "km",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.item.description,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Autres versions",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('articles')
                      .where('categorie', isEqualTo: widget.item.categorie)
                      .where('titre', isEqualTo: widget.item.titre)
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
                                builder: (context) => SingleView(item: item),
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
                                SizedBox(height: 5.h),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[400],
        onPressed: () {
          _contactSellerOnWhatsApp(
            context: context,
            productTitle: widget.item.titre,
            productPrice: widget.item.prix,
            sellerPhone: widget.item.numero,
            productImage:
                widget.item.images.isNotEmpty ? widget.item.images[0] : null,
          );
        },
        child: Icon(Mdi.whatsapp, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
