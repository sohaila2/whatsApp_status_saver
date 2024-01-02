import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/constants/constants.dart';
import 'package:whatsapp_status_saver/screens/images_screen.dart';
import 'package:whatsapp_status_saver/screens/videos_screen.dart';
import 'package:whatsapp_status_saver/provider/bottom_nav_provider.dart';
import 'package:whatsapp_status_saver/screens/saved_screen.dart';

import '../provider/image_path.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  List<Widget> pages =  [
    const ImagesScreen(), VideosScreen(),SavedScreen()];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(builder: (context, nav, child) {
      return Scaffold(
        body: pages[nav.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: navColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: Colors.white,
          onTap: (value) {
            nav.changeIndex(value);
          },
          currentIndex: nav.currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.image), label: "Image"),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_call), label: "Video"),
            BottomNavigationBarItem(
                icon: Icon(Icons.save), label: "Saved"),
          ],
        ),
      );
    });
  }
}
