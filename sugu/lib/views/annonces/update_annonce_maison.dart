import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugu/models/product_model.dart';

class UpdateAnnonceMaison extends StatefulWidget {
  final ProductModel item ;
  const UpdateAnnonceMaison({super.key, required this.item });

  @override
  State<UpdateAnnonceMaison> createState() => _UpdateAnnonceMaisonState();
}

class _UpdateAnnonceMaisonState extends State<UpdateAnnonceMaison> {
  // Contrôleurs pour les champs de formulaire
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  // Variables pour les sélections
  Map<String, dynamic>? _selectedCategory;
  String? _selectedEtat;

  List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "name": "Ventes immobilières",
      "icon": Mdi.homeCityOutline, // Icône pour biens à vendre
    },
    {
      "id": 2,
      "name": "Locations immobilières",
      "icon": Mdi.homeRoof, // Icône pour locations
    },
  ];

  // configuration de selection image depuis gallerie
  final ImagePicker _picker = ImagePicker();
  List<XFile> gallerieImages = [];

  // selectionner plusieur images depuis gallerie du telephone
  Future<void> _selectMultiImageGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        if (gallerieImages.length + pickedFiles.length <= 10) {
          setState(() {
            gallerieImages.addAll(pickedFiles);
          });
        } else {
          ScaffoldMessenger.of(
            // ignore: use_build_context_synchronously
            context,
          ).showSnackBar(
            SnackBar(content: Text("Limite de 10 images atteinte}")),
          );
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    }
  }

  void _submitForm() {
    // Vérification des champs obligatoires
    if (_titreController.text.isEmpty ||
        _prixController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedEtat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs obligatoires"),
        ),
      );
      return;
    }

    // Création de l'objet avec les données du formulaire
    final vehiculeData = {
      'titre': _titreController.text,
      'prix': _prixController.text,
      'description': _descriptionController.text,
      'localisation': _localisationController.text,
       'groupe':"maisons",
      'categorie': _selectedCategory,
      'etat': _selectedEtat,
      'images': gallerieImages.map((file) => file.path).toList(),
      "modele": null,
      "annee": null,
      "kilometrage": null,
      "typeCarburant": null,
      "transmission": null,
      "numero": _numeroController.text,
    };

    // Ici vous pouvez traiter les données (envoi à une API, sauvegarde locale, etc.)
    print(vehiculeData);

    // Affichage d'un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Véhicule publié avec succès")),
    );

    // Optionnel: Redirection ou reset du formulaire
    // Navigator.pop(context);
  }

  // Future<void> deleteProductAndImages({
  //   required String documentId,
  //   required List<String> imageUrls, // Liste d'URLs Cloudinary
  // }) async {
  //   try {
  //     // 🔐 Tes identifiants Cloudinary
  //     const String cloudName = 'dm4qhqazr';
  //     const String apiKey = '993914729256541';
  //     const String apiSecret = '8EPFv5vn2j3nGugygij30Y67Zt8';

  //     for (String imageUrl in imageUrls) {
  //       // 1. Extraire le public ID
  //       final uri = Uri.parse(imageUrl);
  //       final parts = uri.pathSegments;
  //       final filename = parts.last; // ex: "image1.jpg"
  //       final folder = parts[parts.length - 2]; // ex: "articles_images"
  //       final publicId =
  //           '$folder/${filename.split('.').first}'; // ex: "articles_images/image1"

  //       // 2. Supprimer l'image via Cloudinary
  //       final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //       final signatureBase =
  //           'public_id=$publicId&timestamp=$timestamp$apiSecret';

  //       // Calculer la signature SHA1
  //       final signature = sha1.convert(utf8.encode(signatureBase)).toString();

  //       final response = await http.post(
  //         Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy'),
  //         body: {
  //           'public_id': publicId,
  //           'api_key': apiKey,
  //           'timestamp': timestamp.toString(),
  //           'signature': signature,
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         print('Image supprimée de Cloudinary : $publicId');
  //       } else {
  //         print('Erreur Cloudinary : ${response.body}');
  //       }
  //     }

  //     // 3. Supprimer le document de Firestore
  //     await FirebaseFirestore.instance
  //         .collection('articles')
  //         .doc(documentId)
  //         .delete();
  //     print('Produit supprimé avec succès');
  //   } catch (e) {
  //     print('Erreur suppression : $e');
  //   }
  // }

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
      final signatureBase = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
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
    await FirebaseFirestore.instance.collection('articles').doc(documentId).delete();
    print('🗑️ Produit supprimé avec succès');
  } catch (e) {
    print('❗Erreur lors de la suppression : $e');
  }
}


  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _titreController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _localisationController.dispose();
    _numeroController.dispose();
    super.dispose();
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
              backgroundColor: Colors.white,
              toolbarHeight: 40.h,
              elevation: 0,
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
                  "Modifier la maison",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.0.r,
                                    horizontal: 16.r,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.photo_library_outlined,
                                      size: 28.sp,
                                    ),
                                    onPressed: () {
                                      _selectMultiImageGallery();
                                    },
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "Ajouter des photos au maximum 10",
                                  style: GoogleFonts.roboto(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (gallerieImages.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.0.r,
                            horizontal: 16.r,
                          ),
                          child: SizedBox(
                            height: 100.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: gallerieImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0.r,
                                    horizontal: 8.r,
                                  ),
                                  child: Image.file(
                                    File(gallerieImages[index].path),
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _titreController,
                          validator: null,
                          decoration: InputDecoration(
                            hintText: "Titre",
                            hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                            filled: true,
                            fillColor: Colors.grey[100],
                            // isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _prixController,
                          validator: null,
                          decoration: InputDecoration(
                            hintText: "Prix",
                            hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                            filled: true,
                            fillColor: Colors.grey[100],
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _buildAlertCategorieDialog(context);
                          },
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.r),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.grey[100]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedCategory?['name'] ?? "Catégorie",
                                  style: GoogleFonts.roboto(fontSize: 16.sp),
                                ),
                                Icon(Icons.arrow_drop_down_outlined, size: 24.sp),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _buildAlertEtatDialog(context);
                          },
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.r),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.grey[100]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedEtat ?? "Etat",
                                  style: GoogleFonts.roboto(fontSize: 16.sp),
                                ),
                                Icon(Icons.arrow_drop_down_outlined, size: 24.sp),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _descriptionController,
                          validator: null,
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                            filled: true,
                            fillColor: Colors.grey[100],
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _localisationController,
                          validator: null,
                          decoration: InputDecoration(
                            hintText: "localisation",
                            hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                            filled: true,
                            fillColor: Colors.grey[100],
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _numeroController,
                          validator: null,
                          decoration: InputDecoration(
                            hintText: "Numéro vendeur",
                            hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                            filled: true,
                            fillColor: Colors.grey[100],
                            // isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 40.r,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            minimumSize: Size(400.w, 40.h),
                          ),
                          child: Text(
                            "Modifier",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.only(
                        bottom:40.r,
                        left: 16.r,
                        right: 16.r
                          
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _showDeleteDialog(context,widget.item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: Size(400.w, 40.h),
                          ),
                          child: Text(
                            "suprimer",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _buildAlertCategorieDialog(BuildContext context) {
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
            height: 200.h,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 20.r,
                  ),
                  child: Text(
                    "Séléctionner une catégorie",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          categories.map((item) {
                            return TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = item;
                                });
                                Navigator.pop(context);
                              },
                              label: Text(
                                item["name"],
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
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
                                child: Icon(
                                  item["icon"],
                                  size: 20.sp,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildAlertEtatDialog(BuildContext context) {
    final etats = [
      {"name": "Neuf", "icon": Mdi.tagCheck},
      {"name": "Occasion - comme neuf", "icon": Mdi.tagMultiple},
      {"name": "Occasion - assez bon état", "icon": Mdi.tagMinus},
    ];
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
                    vertical: 20.r,
                  ),
                  child: Text(
                    "Etat de l'article",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        etats.map((etat) {
                          return TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedEtat = etat["name"].toString();
                              });
                              Navigator.pop(context);
                            },
                            label: Text(
                              etat["name"].toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
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
                              child: Icon(
                                etat["icon"] as IconData,
                                size: 20.sp,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                          onPressed: () => deleteProductAndImages(documentId: item.id, imageUrls: item.images),
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