import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/components/categorie_item.dart';
import 'package:sugu/components/product_item.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "name": "Automobiles et camions",
      "icon": Mdi.car,
      "color": Colors.blue.shade700,
    },
    {
      "id": 2,
      "name": "Motos",
      "icon": Mdi.motorbike,
      "color": Colors.red.shade400,
    },
    {
      "id": 3,
      "name": "Sports mécaniques",
      "icon": Mdi.carSports,
      "color": Colors.orange.shade600,
    },
    {
      "id": 4,
      "name": "Camping-cars",
      "icon": Mdi.rvTruck,
      "color": Colors.brown.shade500,
    },
    {
      "id": 5,
      "name": "Bateaux",
      "icon": Mdi.sailBoat,
      "color": Colors.indigo.shade400,
    },
    {
      "id": 6,
      "name": "Commercial et industriel",
      "icon": Mdi.truckDelivery,
      "color": Colors.grey.shade700,
    },
    {
      "id": 7,
      "name": "Remorques",
      "icon": Mdi.truckTrailer,
      "color": Colors.blueGrey.shade600,
    },
    {
      "id": 8,
      "name": "Autres",
      "icon": Mdi.flagOutline,
      "color": Colors.grey.shade500,
    },
    {
      "id": 9,
      "name": "Outils",
      "icon": Mdi.tools,
      "color": Colors.amber.shade800,
    },
    {
      "id": 10,
      "name": "Meubles",
      "icon": Mdi.tableFurniture,
      "color": Colors.brown.shade400,
    },
    {
      "id": 11,
      "name": "Jardin",
      "icon": Mdi.gradientHorizontal,
      "color": Colors.green.shade600,
    },
    {
      "id": 12,
      "name": "Electroménager",
      "icon": Mdi.toasterOven,
      "color": Colors.blue.shade400,
    },
    {
      "id": 13,
      "name": "Pour la maison",
      "icon": Mdi.homeVariantOutline,
      "color": Colors.teal.shade400,
    },
    {
      "id": 14,
      "name": "Livres",
      "icon": Mdi.bookOpenVariant,
      "color": Colors.purple.shade400,
    },
    {
      "id": 15,
      "name": "Jeux vidéos",
      "icon": Mdi.controllerClassicOutline,
      "color": Colors.deepPurple.shade400,
    },
    {
      "id": 16,
      "name": "Bijoux accessoires",
      "icon": Mdi.diamondStone,
      "color": Colors.pink.shade300,
    },
    {
      "id": 17,
      "name": "Sacs",
      "icon": Mdi.bagPersonalOutline,
      "color": Colors.red.shade300,
    },
    {
      "id": 18,
      "name": "Vêtements",
      "icon": Mdi.tshirtCrewOutline,
      "color": Colors.cyan.shade400,
    },
    {
      "id": 19,
      "name": "Chaussures",
      "icon": Mdi.shoeFormal,
      "color": Colors.indigo.shade300,
    },
    {
      "id": 20,
      "name": "Jouets",
      "icon": Mdi.toyBrickOutline,
      "color": Colors.orange.shade400,
    },
    {
      "id": 21,
      "name": "Produits pour animaux",
      "icon": Mdi.pawOutline,
      "color": Colors.amber.shade600,
    },
    {
      "id": 22,
      "name": "Santé et beauté",
      "icon": Mdi.lotionPlusOutline,
      "color": Colors.pink.shade200,
    },
    {
      "id": 23,
      "name": "Téléphones et tablettes",
      "icon": Mdi.cellphone,
      "color": Colors.blue.shade500,
    },
    {
      "id": 24,
      "name": "Electronique et ordinateurs",
      "icon": Mdi.desktopTower,
      "color": Colors.deepPurple.shade300,
    },
    {
      "id": 25,
      "name": "Artisanat d'art",
      "icon": Mdi.paletteOutline,
      "color": Colors.deepOrange.shade400,
    },
    {
      "id": 26,
      "name": "Pièces automobiles",
      "icon": Mdi.carWrench,
      "color": Colors.blueGrey.shade500,
    },
    {
      "id": 27,
      "name": "Ventes immobilières",
      "icon": Mdi.homeCityOutline,
      "color": Colors.blue.shade800,
    },
    {
      "id": 28,
      "name": "Locations immobilières",
      "icon": Mdi.homeRoof,
      "color": Colors.teal.shade600,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Triez les catégories par nom avant de les utiliser
    final sortedCategories = [...categories]
      ..sort((a, b) => b['name'].compareTo(a['name']));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                backgroundColor: Colors.transparent, // Couleur opaque
                elevation: 0, // Supprime l'ombre si nécessaire
                toolbarHeight: 45.h,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: Colors.white),
                  // centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  title: Image.asset(
                    "assets/logos/logo.png",
                    width: 120.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //Slogan
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Image.asset(
                            "assets/logos/logo3.jpg",
                            fit: BoxFit.cover,
                            height: 110.h,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 110.h,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade600,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.r,
                              vertical: 10.r,
                            ),
                            child: Text(
                              "MicroSugu offre une vitrine numérique à ceux qui vendent au quotidien sans boutique physique.",
                              style: GoogleFonts.lato(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Catégories",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategorieListView(),
                            ),
                          );
                        },
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Voir tout ",
                              style: GoogleFonts.roboto(
                                color: Colors.deepOrange,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.deepOrange,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final item = sortedCategories[index]; // Donnée de la catégorie
                    return CategoryItem(item: item);
                  }, childCount: 12),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Annonces récentes",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('articles')
                        .orderBy('createdAt', descending: true)
                        .limit(10)
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
                    return SliverToBoxAdapter(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 188.h,
                          maxHeight: 188.h,
                        ),

                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          padding: EdgeInsets.symmetric(horizontal: 12.r),
                          itemBuilder: (context, index) {
                            final item = articles[index];

                            return AspectRatio(
                              aspectRatio: 0.8,
                              child: ProductCard(item: item),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "À vendre",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('articles')
                        .orderBy('createdAt', descending: true)
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
                        horizontal: 10.r,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              childAspectRatio:
                                  0.8, // Ajuste pour obtenir une belle carte
                            ),
                        delegate: SliverChildBuilderDelegate((
                          BuildContext context,
                          int index,
                        ) {
                          ProductModel item = articles[index];
                          return ProductCard(item: item);
                        }, childCount: articles.length),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
