import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';

import '../provider/image_path.dart';
import '../provider/theme_provider.dart';
import '../widgets/video_player_widget.dart';
import 'display_image_screen.dart';
import 'display_video_screen.dart';



class SavedScreen extends StatefulWidget {
const SavedScreen({super.key});

@override
_SavedScreenState createState() => _SavedScreenState();
}
class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ImagePathsProvider>(context, listen: false).loadSavedImagePaths();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider,child) {
          return Scaffold(
            backgroundColor: themeProvider.getTheme() == ThemeData.dark()
                ? Theme.of(context).scaffoldBackgroundColor
                :
            const Color(0xffDFDFDF),
            appBar: AppBar(
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
            body: Column(
              children: [
                Expanded(
                  child: Consumer<ImagePathsProvider>(
                    builder: (context, image,child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: themeProvider.getTheme() == ThemeData.dark()
                              ? Theme.of(context).scaffoldBackgroundColor
                              :
                          Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),

                          ),
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Color(0xff003B26
                              ), // Set your desired border color here
                              width: 3.0, // Set your desired border width here
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 20,right: 20, top:10),
                        child: Consumer<GetStatusProvider>(
                          builder: (context, file,child) {
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: image.savedImagePaths.length + image.savedVideoPaths.length,
                              itemBuilder: (context, index) {
                                bool isImage = index < image.savedImagePaths.length;
                                String filePath = isImage
                                    ? image.savedImagePaths[index]
                                    : image.savedVideoPaths[index - image.savedImagePaths.length];

                                if (File(filePath).existsSync()) {
                                  Widget mediaWidget = isImage
                                      ? Image.file(
                                    File(filePath),
                                    fit: BoxFit.cover,
                                  )
                                      : VideoPlayerWidget(
                                    videoPath: filePath,
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      if (isImage) {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) => DisplayImageScreen(
                                              imagePath: filePath,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (_) => DisplayVideoScreen(
                                        //       videopath: filePath,
                                        //     ),
                                        //   ),
                                        // );
                                      }
                                    },
                                    child: mediaWidget,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );

                          }
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}


