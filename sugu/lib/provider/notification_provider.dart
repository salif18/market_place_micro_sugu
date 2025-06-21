import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController with ChangeNotifier {
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  NotificationController() {
    _loadSetting();
  }

  void _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  void toggleNotification(bool value) async {
    _isEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _isEnabled);
    notifyListeners();
  }
}