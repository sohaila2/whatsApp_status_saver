import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePathsProvider extends ChangeNotifier {
  List<String> savedImagePaths = [];
  List<String> savedVideoPaths = [];

  Future<void> loadSavedImagePaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedImagePaths = prefs.getStringList('savedImagePaths') ?? [];
    savedVideoPaths = prefs.getStringList('savedVideoPaths') ?? [];
    notifyListeners();
  }

  void addImagePath(String imagePath) {
    savedImagePaths.add(imagePath);
    notifyListeners();
    saveImagePathsToSharedPreferences();
  }

  void addVideoPath(String videoPath) {
    savedVideoPaths.add(videoPath);
    notifyListeners();
    saveVideoPathsToSharedPreferences();
  }

  Future<void> saveImagePathsToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedImagePaths', savedImagePaths);
  }

  Future<void> saveVideoPathsToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedVideoPaths', savedVideoPaths);
  }
}