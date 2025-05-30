import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  // Déclaration des variables
  late String _token;
  late String _userId;
  late String _userName;
  late String _userNumber;
  late String _userEmail;

  // Accesseurs pour récupérer les valeurs
  String get token => _token;
  String get userId => _userId;
  String get userName => _userName;
  String get userNumber => _userNumber;
  String get userEmail => _userEmail;

  // Initialisation des variables
  AuthProvider() {
    _token = "";
    _userId = "";
    _userName = "";
    _userNumber = "";
    _userEmail ="";

    // Chargement des données au démarrage
    _loadUserData();
  }

  // Charger les données depuis le stockage local
  Future<void> _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    _token = localStorage.getString("token") ?? "";
    _userId = localStorage.getString("userId") ?? "";
    _userName = localStorage.getString("userName") ?? "";
    _userNumber = localStorage.getString("userNumber") ?? "";
    _userEmail = localStorage.getString("userEmail") ?? "";
    // Notifier les listeners après avoir chargé les données
    notifyListeners();
  }

  // Sauvegarder les données dans le stockage local
  Future<void> saveToLocalStorage(String key, String value) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(key, value);
  }

  // Supprimer les données du stockage local
  Future<void> removeFromLocalStorage(String key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove(key);
  }

  // Fonction de login : sauvegarde les données utilisateur
  void loginButton(String userToken, String userUserId, String userName , String userNumber, String userEmail) {
    _token = userToken;
    _userId = userUserId;
    _userName =userName;
    _userNumber = userNumber;
    _userEmail = userEmail;
    saveToLocalStorage("token", _token);
    saveToLocalStorage("userId", _userId);
    saveToLocalStorage("userName", _userName);
    saveToLocalStorage("userNumber", _userNumber);
    saveToLocalStorage("userEmail", _userEmail);
    notifyListeners();
  }
  // Fonction de déconnexion : efface les données utilisateur
  void logoutButton() {
    _token = "";
    _userId = "";
    _userName = "";
    _userNumber = "";
    _userEmail = "";
    removeFromLocalStorage("token");
    removeFromLocalStorage("userId");
    removeFromLocalStorage("userName");
    removeFromLocalStorage("userNumber");
    removeFromLocalStorage("userEmail");
    notifyListeners();
  }
}