import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_view.dart';

class CategorieListView extends StatefulWidget {
  const CategorieListView({super.key});

  @override
  State<CategorieListView> createState() => _CategorieViewState();
}

class _CategorieViewState extends State<CategorieListView> {
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
      "name": 'Vêtements',
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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white, // Couleur opaque
              elevation: 0, // Supprime l'ombre si nécessaire
              toolbarHeight: 50.h,
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
                  "Catégories",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item =
                      sortedCategories[index]; // Utilisez la liste triée ici
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Action on product tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CategoriesView(categoryName: item["name"]),
                            ),
                          );
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
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Icon(
                            item["icon"],
                            size: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: categories.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
