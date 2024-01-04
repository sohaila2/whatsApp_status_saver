import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_status_saver/constants/constants.dart';
import 'package:flutter/foundation.dart';

class GetStatusProvider extends ChangeNotifier {
  List<FileSystemEntity> _getImages = [];
  List<FileSystemEntity> _getVideos = [];
  bool _isWhatsAppAvailable = false;

  List<FileSystemEntity> get getImages => _getImages;
  List<FileSystemEntity> get getVideos => _getVideos;
  bool get isWhatsAppAvailable => _isWhatsAppAvailable;

  void getStatus(String ext) async {
    var status = await Permission.manageExternalStorage.request();

    if (status.isDenied) {
      Permission.storage.request();
      log("Permission denied");
      return;
    }

    if (status.isGranted) {
      final directory = Directory(WHATSAPP_PATH);

      if (directory.existsSync()) {
        final items = directory.listSync();

        if (ext == ".mp4") {
          _getVideos = items.where((element) => element.path.endsWith(".mp4")).toList();
          notifyListeners();
        } else {
          _getImages = items.where((element) => element.path.endsWith(".jpg")).toList();
          notifyListeners();
        }

        _isWhatsAppAvailable = true;
        notifyListeners();
        log(items.toString());
      } else {
        log("No WhatsApp found");
        _isWhatsAppAvailable = false;
        notifyListeners();
      }
    }
  }

  void removeImage(String imagePath) {
    _getImages.removeWhere((image) => image.path == imagePath);
    notifyListeners();
  }

}
