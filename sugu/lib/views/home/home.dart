import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_list.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_view.dart';
import 'package:sugu/views/detail/detail.dart';

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
      "name": "sacs",
      "icon": Mdi.bagPersonalOutline,
      "color": Colors.red.shade300,
    },
    {
      "id": 18,
      "name": "Vetements",
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
      ..sort((a, b) => a['name'].compareTo(b['name']));
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
                              color: Colors.deepOrangeAccent,
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
                    final item =
                        sortedCategories[index]; // Donnée de la catégorie

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CategoriesView(categoryName: item["name"]),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // Conteneur de l’icône avec bordure circulaire
                          Container(
                            width: 50.w,
                            height: 50.w, // carré pour une icône ronde
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: item["color"],
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.r,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item["icon"],
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            height:
                                20.h, // hauteur fixe pour éviter les débordements
                            child: Text(
                              item["name"],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: 8),
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
                      child: SizedBox(
                        height: 200.h, // hauteur fixe du bloc horizontal
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          padding: EdgeInsets.symmetric(horizontal: 12.r),
                          itemBuilder: (context, index) {
                            final item = articles[index];

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SingleView(item: item),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.only(right: 12.r),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.r),
                                ),
                                elevation: 0,
                                child: Container(
                                  width: 160.w,
                                  padding: EdgeInsets.only(bottom: 8.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image avec ratio carré
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors
                                                      .grey[200]!, // couleur de la bordure
                                              width:
                                                  1.r, // épaisseur de la bordure
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            child: Image.network(
                                              item.images.isNotEmpty
                                                  ? item.images[0]
                                                  : '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      // Titre
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.r,
                                        ),
                                        child: Text(
                                          item.titre,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.roboto(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      // Prix
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.r,
                                        ),
                                        child: Text(
                                          "${item.prix} FCFA",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio:
                                  0.71, // Ajuste pour obtenir une belle carte
                            ),
                        delegate: SliverChildBuilderDelegate((
                          BuildContext context,
                          int index,
                        ) {
                          ProductModel item = articles[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleView(item: item),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image produit
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
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        child: Image.network(
                                          item.images.isNotEmpty
                                              ? item.images[0]
                                              : '',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Espace
                                  SizedBox(height: 8.h),
                                  // Titre
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.r,
                                    ),
                                    child: Text(
                                      item.titre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  // Prix
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.r,
                                    ),
                                    child: Text(
                                      "${item.prix} FCFA",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
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
      ),
    );
  }
}
