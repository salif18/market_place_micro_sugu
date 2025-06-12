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
import 'package:sugu/views/detail/widgets/caracteristic_section.dart';
import 'package:sugu/views/detail/widgets/description_section.dart';
import 'package:sugu/views/detail/widgets/image_slider_section.dart';
import 'package:sugu/views/detail/widgets/similar_product.dart';
import 'package:sugu/views/detail/widgets/title_section.dart';
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

          message += "Lien de l'image: $productImage\n\n";
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
                                  Icons.bookmark_border_rounded,
                                  size: 20.sp,
                                  color: Colors.black54,
                                )
                                : Icon(
                                  Icons.bookmark,
                                  size: 20.sp,
                                  color: Colors.black,
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

            ImageSlider(item: widget.item),
            TitleSection(item: widget.item),
            CaracteristiQueSection(item: widget.item),
            DescriptionSection(item: widget.item),
            _buildTitleSection(context, "Autres versions"),
            BuildSimilarProduct(item: widget.item),
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

  Widget _buildTitleSection(BuildContext context, String title) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
