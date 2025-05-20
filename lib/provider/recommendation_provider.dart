import 'package:flutter/material.dart';

class RecommendationProvider with ChangeNotifier {
  final List<List<String>> _history = [];

  List<List<String>> get history => _history;

  void addRecommendation(List<String> recommendations) {
    _history.add(recommendations);
    notifyListeners();
  }
}