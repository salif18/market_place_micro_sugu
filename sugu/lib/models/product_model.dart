class ProductModel {
  final String? id;
  final String? userId;
  final String titre;
  final String prix;
  final String description;
  final String localisation;
  final String groupe;
  final String categorie;
  final String etat;
  final List<String> images;
  final String? modele;
  final String? annee;
  final String? kilometrage;
  final String? typeCarburant;
  final String? transmission;
  final String numero;
  final int? views;


  ProductModel({
    required this.id,
    required this.userId,
    required this.titre,
    required this.prix,
    required this.description,
    required this.localisation,
    required this.groupe,
    required this.categorie,
    required this.etat,
    required this.images,
    this.modele,
    this.annee,
    this.kilometrage,
    this.typeCarburant,
    this.transmission,
    required this.numero,
    required this.views,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json,String id) {
    return ProductModel(
      id: id,
      userId: json["userId"],
      titre: json['titre'] ?? '',
      prix: json['prix'] ?? '',
      description: json['description'] ?? '',
      localisation: json['localisation'] ?? '',
      groupe: json["groupe"] ?? "",
      categorie: json['categorie'] ?? '',
      etat: json['etat'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      modele: json['modele'],
      annee: json['annee'],
      kilometrage: json['kilometrage'],
      typeCarburant: json['typeCarburant'],
      transmission: json['transmission'],
      numero: json['numero'] ?? '',
      views: json["views" ] ?? 0,
      // viewsUserId:  List<String>.from(json['viewsUserId'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "userId":userId,
      'titre': titre,
      'prix': prix,
      'description': description,
      'localisation': localisation,
      'groupe':groupe,
      'categorie': categorie,
      'etat': etat,
      'images': images,
      'modele': modele,
      'annee': annee,
      'kilometrage': kilometrage,
      'typeCarburant': typeCarburant,
      'transmission': transmission,
      'numero': numero,
      'views':views,
      // 'viewsUserId':viewsUserId
    };
  }

// generer des fakes data
  static List<ProductModel> getProducts() {
    return [];
  }
}
