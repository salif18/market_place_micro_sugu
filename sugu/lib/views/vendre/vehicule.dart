import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugu/services/publier_avec_boost.dart';

class AddVehicules extends StatefulWidget {
  const AddVehicules({super.key});

  @override
  State<AddVehicules> createState() => _AddVehiculesState();
}

class _AddVehiculesState extends State<AddVehicules> {
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // Contrôleurs pour les champs de formulaire
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _anneeController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _carburantController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  // Variables pour les sélections
  String? _selectedCategory;
  String? _selectedEtat;

  List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Automobiles et camions", "icon": Mdi.car},
    {"id": 2, "name": "Motos", "icon": Mdi.motorbike},
    {"id": 3, "name": "Sports mécaniques", "icon": Mdi.carSports},
    {"id": 4, "name": "Camping-cars", "icon": Mdi.rvTruck},
    {"id": 5, "name": "Bateaux", "icon": Mdi.sailBoat},
    {"id": 6, "name": "Commercial et industriel", "icon": Mdi.truckDelivery},
    {"id": 7, "name": "Remorques", "icon": Mdi.truckTrailer},
    {"id": 8, "name": "Autres", "icon": Mdi.flagOutline},
  ];

  Future<void> sendNotificationToTopic({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final dio = Dio();

    final response = await dio.post(
      'https://service-notification-micro-sugu.vercel.app/api/notify-annonce',
      data: {'title': title, 'body': body, if (data != null) 'data': data},
    );

    if (response.statusCode == 200) {
      print('✅ Notification envoyée avec succès');
    } else {
      print('❌ Erreur (${response.statusCode}): ${response.data}');
    }
  }

  // configuration de selection image depuis gallerie
  final ImagePicker _picker = ImagePicker();
  List<XFile> gallerieImages = [];

  // ✅ 1. Sélectionner plusieurs images
  Future<void> _selectMultiImageGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        if (gallerieImages.length + pickedFiles.length <= 10) {
          setState(() {
            gallerieImages.addAll(pickedFiles);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Limite de 10 images atteinte")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    }
  }

  // ✅ 2. Upload des images sur Cloudinary
  Future<List<String>> uploadImagesToCloudinary(List<XFile> images) async {
    List<String> uploadedUrls = [];

    const cloudName = 'dm4qhqazr'; // ← remplace par ton cloud name
    const uploadPreset = 'flutter_sugu_signed'; // ← remplace par ton preset

    final dio = Dio();

    for (var image in images) {
      final file = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );

      final formData = FormData.fromMap({
        'file': file,
        'upload_preset': uploadPreset,
      });

      try {
        final response = await dio.post(
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
          data: formData,
        );

        if (response.statusCode == 200) {
          uploadedUrls.add(response.data['secure_url']);
        } else {
          print('Erreur Cloudinary (${response.statusCode}): ${response.data}');
        }
      } catch (e) {
        print('Erreur lors de l\'upload : $e');
      }
    }

    return uploadedUrls;
  }

  // ✅ 3. Soumettre le formulaire
  void _submitForm(BuildContext context) async {
    if (_globalKey.currentState!.validate() ||
        _selectedCategory != null ||
        _selectedEtat != null) {
      try {
        // Upload vers Cloudinary
        List<String> imageUrls = await uploadImagesToCloudinary(gallerieImages);

        // Création du document Firestore
        final _data = {
          'titre': _titreController.text,
          'prix': _prixController.text,
          'description': _descriptionController.text,
          'localisation': _localisationController.text,
          'groupe': "véhicules, voitures",
          'categorie': _selectedCategory,
          'etat': _selectedEtat,
          'images': imageUrls,
          'modele': _modelController.text,
          'annee': _anneeController.text,
          'kilometrage': _kmController.text,
          'typeCarburant': _carburantController.text,
          'transmission': _transmissionController.text,
          'numero': _numeroController.text,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': FirebaseAuth.instance.currentUser?.uid,
          "views": 0,
        };

        showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        // envoyer avec boost
        UserBoost userBoost = UserBoost();
        await userBoost.publierArticleAvecBoost(_data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrangeAccent,
            content: Text(
              "Article publié avec succès",
              style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        );

        await sendNotificationToTopic(
          title: "Nouvelle annonce disponible !",
          body: "Découvrez la dernière annonce ajoutée rien que pour vous.",
        );

        // Réinitialiser ou rediriger
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddVehicules()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la publication : $e")),
        );
        print("Erreur lors de la publication : $e");
      }
    }
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _titreController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _localisationController.dispose();
    _kmController.dispose();
    _modelController.dispose();
    _anneeController.dispose();
    _carburantController.dispose();
    _transmissionController.dispose();
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
                background: Container(color: Colors.white),
                title: Text(
                  "Ajouter un véhicule",
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
                  key: _globalKey,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un titre';
                            }
                            return null;
                          },
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
                          keyboardType: TextInputType.text,
                          controller: _modelController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une modèle';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Modèle",
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
                          keyboardType: TextInputType.text,
                          controller: _anneeController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une année';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Année",
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un prix';
                            }
                            return null;
                          },
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
                                  _selectedCategory ?? "Catégorie",
                                  style: GoogleFonts.roboto(fontSize: 16.sp),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 24.sp,
                                ),
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
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 24.sp,
                                ),
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
                          controller: _kmController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer le kilométroge';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Kilometrage",
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
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _carburantController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un carburant';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Carburant",
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
                          keyboardType: TextInputType.text,
                          controller: _transmissionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une transmission';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Transmission",
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
                          keyboardType: TextInputType.text,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une description';
                            }
                            return null;
                          },
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
                          keyboardType: TextInputType.text,
                          controller: _localisationController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une localisation';
                            }
                            return null;
                          },
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
                              borderRadius: BorderRadius.circular(10),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numéro';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Numéro vendeur",
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
                          vertical: 40.r,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            minimumSize: Size(400.w, 40.h),
                          ),
                          child: Text(
                            "Publier",
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
            height: 500.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          categories.map((Map<String, dynamic> item) {
                            return TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = item["name"];
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
}
