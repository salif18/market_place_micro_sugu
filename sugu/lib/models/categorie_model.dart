import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CategorieModel {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  CategorieModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static List<CategorieModel> getCategory() {
    return [
      CategorieModel(
        id: 1,
        name: "Automobiles et camions",
        icon: Mdi.car,
        color: Colors.blue.shade700,
      ),
      CategorieModel(
        id: 2,
        name: "Motos",
        icon: Mdi.motorbike,
        color: Colors.red.shade400,
      ),
      CategorieModel(
        id: 3,
        name: "Sports mécaniques",
        icon: Mdi.carSports,
        color: Colors.orange.shade600,
      ),
      CategorieModel(
        id: 4,
        name: "Camping-cars",
        icon: Mdi.rvTruck,
        color: Colors.brown.shade500,
      ),
      CategorieModel(
        id: 5,
        name: "Bateaux",
        icon: Mdi.sailBoat,
        color: Colors.indigo.shade400,
      ),
      CategorieModel(
        id: 6,
        name: "Commercial et industriel",
        icon: Mdi.truckDelivery,
        color: Colors.grey.shade700,
      ),
      CategorieModel(
        id: 7,
        name: "Remorques",
        icon: Mdi.truckTrailer,
        color: Colors.blueGrey.shade600,
      ),
      CategorieModel(
        id: 8,
        name: "Autres",
        icon: Mdi.flagOutline,
        color: Colors.grey.shade500,
      ),
      CategorieModel(
        id: 9,
        name: "Outils",
        icon: Mdi.tools,
        color: Colors.amber.shade800,
      ),
      CategorieModel(
        id: 10,
        name: "Meubles",
        icon: Mdi.tableFurniture,
        color: Colors.brown.shade400,
      ),
      CategorieModel(
        id: 11,
        name: "Jardin",
        icon: Mdi.gradientHorizontal,
        color: Colors.green.shade600,
      ),
      CategorieModel(
        id: 12,
        name: "Electroménager",
        icon: Mdi.toasterOven,
        color: Colors.blue.shade400,
      ),
      CategorieModel(
        id: 13,
        name: "Pour la maison",
        icon: Mdi.homeVariantOutline,
        color: Colors.teal.shade400,
      ),
      CategorieModel(
        id: 14,
        name: "Livres",
        icon: Mdi.bookOpenVariant,
        color: Colors.purple.shade400,
      ),
      CategorieModel(
        id: 15,
        name: "Jeux vidéos",
        icon: Mdi.controllerClassicOutline,
        color: Colors.deepPurple.shade400,
      ),
      CategorieModel(
        id: 16,
        name: "Bijoux accessoires",
        icon: Mdi.diamondStone,
        color: Colors.pink.shade300,
      ),
      CategorieModel(
        id: 17,
        name: "Sacs",
        icon: Mdi.bagPersonalOutline,
        color: Colors.red.shade300,
      ),
      CategorieModel(
        id: 18,
        name: "Vêtements",
        icon: Mdi.tshirtCrewOutline,
        color: Colors.cyan.shade400,
      ),
      CategorieModel(
        id: 19,
        name: "Chaussures",
        icon: Mdi.shoeFormal,
        color: Colors.indigo.shade300,
      ),
      CategorieModel(
        id: 20,
        name: "Jouets",
        icon: Mdi.toyBrickOutline,
        color: Colors.orange.shade400,
      ),
      CategorieModel(
        id: 21,
        name: "Produits pour animaux",
        icon: Mdi.pawOutline,
        color: Colors.amber.shade600,
      ),
      CategorieModel(
        id: 22,
        name: "Santé et beauté",
        icon: Mdi.lotionPlusOutline,
        color: Colors.pink.shade200,
      ),
      CategorieModel(
        id: 23,
        name: "Téléphones et tablettes",
        icon: Mdi.cellphone,
        color: Colors.blue.shade500,
      ),
      CategorieModel(
        id: 24,
        name: "Electronique et ordinateurs",
        icon: Mdi.desktopTower,
        color: Colors.deepPurple.shade300,
      ),
      CategorieModel(
        id: 25,
        name: "Artisanat d'art",
        icon: Mdi.paletteOutline,
        color: Colors.deepOrange.shade400,
      ),
      CategorieModel(
        id: 26,
        name: "Pièces automobiles",
        icon: Mdi.carWrench,
        color: Colors.blueGrey.shade500,
      ),
      CategorieModel(
        id: 27,
        name: "Ventes immobilières",
        icon: Mdi.homeCityOutline,
        color: Colors.blue.shade800,
      ),
      CategorieModel(
        id: 28,
        name: "Locations immobilières",
        icon: Mdi.homeRoof,
        color: Colors.teal.shade600,
      ),
    ];
  }
}
