import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';

import '../provider/image_path.dart';
import '../provider/theme_provider.dart';
import '../widgets/video_player_widget.dart';



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

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.getTheme() == ThemeData.dark()
            ? Theme.of(context).scaffoldBackgroundColor
            :
        const Color(0xffDFDFDF),
        body: Column(
          children: [
            SizedBox(
                width: 300,
                height: 120,
                child: Row(
                  children: [
                    const Text("Status Saver"),
                    const Spacer(),
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
                )
            ),
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
      
                            // Check if the file exists before displaying
                            if (File(filePath).existsSync()) {
                              return isImage
                                  ? Image.file(
                                File(filePath),
                                fit: BoxFit.cover,
                              )
                                  : VideoPlayerWidget(
                                videoPath: filePath,
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
      ),
    );
  }
}


