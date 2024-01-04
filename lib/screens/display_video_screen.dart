import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/constants/constants.dart';

import '../provider/get_status_provider.dart';
import '../provider/image_path.dart';
import '../provider/theme_provider.dart';

class DisplayVideoScreen extends StatefulWidget {
  const DisplayVideoScreen({super.key, required this.videopath});
  final String? videopath;
  @override
  State<DisplayVideoScreen> createState() => _DisplayVideoScreenState();
}

class _DisplayVideoScreenState extends State<DisplayVideoScreen> {

  ChewieController? _chewieController;
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();

    _chewieController = ChewieController(
        videoPlayerController:
            VideoPlayerController.file(
                File(widget.videopath!),
            ),
      autoInitialize: true,
      errorBuilder: ((context,errorMessage){
        return Center(
          child: Text(errorMessage),
        );
      })
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController!.pause();
    _chewieController!.dispose();

  }


  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.getTheme() == ThemeData.dark()
            ? Theme.of(context).scaffoldBackgroundColor
            :
        Color(0xffDFDFDF),
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
                    border: Border.all(
                      color: navColor,
                      width: 2.0,
                    ),
                  ),
                  child:
                  SingleChildScrollView(
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
                              image: FileImage(File(widget.videopath!)),
                                fit: BoxFit.fill
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            child: Chewie(
                              controller: _chewieController!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
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
                ImageGallerySaver.saveFile(widget.videopath!).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("video saved")),
                  );
                  imagePathsProvider.addVideoPath(widget.videopath!);
                  imagePathsProvider.saveVideoPathsToSharedPreferences();
                });
                break;

              case 1:
                log("delete");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Video"),
                      content: Text("Are you sure you want to delete this video?"),
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
                            File(widget.videopath!).deleteSync();
                            Provider.of<GetStatusProvider>(context, listen: false)
                                .removeImage(widget.videopath!);
                            Navigator.of(context).pop();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text("Video deleted"),
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
                FlutterNativeApi.shareImage(widget.videopath!);

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
        ),
      ),
    );
  }
}
