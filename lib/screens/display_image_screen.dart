import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_status_saver/constants/constants.dart';

import '../provider/get_status_provider.dart';
import '../provider/image_path.dart';
import '../provider/theme_provider.dart';
import 'saved_screen.dart';
import '../services/url_service.dart';

class DisplayImageScreen extends StatefulWidget {
  final String? imagePath;
  const DisplayImageScreen({super.key, this.imagePath});

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  List<Widget> buttonsList = [
   Icon(Icons.download),
    Icon(Icons.delete),
    Icon(Icons.share),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.getTheme() == ThemeData.dark()
          ? Theme.of(context).scaffoldBackgroundColor
          : Color(0xffDFDFDF),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          title: Text(
            "Status Saver",
            style: TextStyle(
                fontSize: 24
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {

                if (value == 'light') {
                  themeProvider.setLightTheme();
                } else if (value == 'dark') {
                  themeProvider.setDarkTheme();
                }
              },
              itemBuilder: (BuildContext context) {
                return ['light', 'dark'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice == 'light' ? 'Light Theme' : 'Dark Theme'),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeProvider.getTheme() == ThemeData.dark()
                        ? Theme.of(context).scaffoldBackgroundColor
                        :
                    Colors.white,

                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Color(0xff003B26
                        ),
                        width: 3.0,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back_ios),),
                          Text("Back"),
                        ],
                      ),
                     SizedBox(
                       height: 20,
                     ),
                      Container(
                        height: 340,
                        width: 320,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(widget.imagePath!)),
                            fit: BoxFit.fill
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: navColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
      
            switch (index) {
              case 0:
                ImagePathsProvider imagePathsProvider =
                Provider.of<ImagePathsProvider>(context, listen: false);

                log("download image");
                ImageGallerySaver.saveFile(widget.imagePath!).then((value) async {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("image saved")));
                  imagePathsProvider.addImagePath(widget.imagePath!);
                  imagePathsProvider.saveImagePathsToSharedPreferences();
                });
                break;
              case 1:
                log("delete");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Image"),
                      content: Text("Are you sure you want to delete this image?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            File(widget.imagePath!).deleteSync();
                            Provider.of<GetStatusProvider>(context, listen: false)
                                .removeImage(widget.imagePath!);
                            Navigator.of(context).pop();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text("Image deleted"),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
                break;
      
              case 2:
                log("share");
                FlutterNativeApi.shareImage(widget.imagePath!);
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Download',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: 'Delete',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: 'Share',
            ),
          ],
        ),    ),
    );
  }
}


