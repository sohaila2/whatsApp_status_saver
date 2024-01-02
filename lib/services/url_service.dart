import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/image_path.dart';


Future<void> launchSocialMediaAppIfInstalled(String url) async {
  try {
    bool launched = await launch(url, forceSafariVC: false);

    if (!launched) {
      launch(url);
    }
  } catch (e) {
    launch(url);
  }
}
