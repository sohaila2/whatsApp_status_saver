import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/screens/display_video_screen.dart';
import 'package:whatsapp_status_saver/utils/get_thumbnail.dart';

import '../provider/get_status_provider.dart';
import '../provider/theme_provider.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  bool _isFetched = false;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider,child) {
          return Scaffold(
              backgroundColor: themeProvider.getTheme() == ThemeData.dark()
                  ? Theme.of(context).scaffoldBackgroundColor
                  :
              Color(0xffDFDFDF),
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
              body:
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                  Expanded(
                    child: Consumer<GetStatusProvider>(
                        builder: (context, file,child) {
                          if(_isFetched == false){
                            file.getStatus(".mp4");
                            Future.delayed(Duration(microseconds: 1), (){
                              _isFetched = true;
                            });
                          }
                          return file.isWhatsAppAvailable == false ? Center(
                            child: Text("WhatsApp not available"),
                          ) : file.getVideos.isEmpty ?
                          Center(
                            child: Text("No Videos avaialble"),
                          ) : Container(
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
                            child: GridView(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                ),
                                children:
                                List.generate(file.getVideos.length,
                                        (index) {
                                      final data = file.getVideos[index];
                                      return FutureBuilder<String>(
                                          future: getThumbnail(data.path),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData ?
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, CupertinoPageRoute(builder: (_)=>
                                                    DisplayVideoScreen(
                                                      videopath: data.path,
                                                    )));
                                              },
                                              child: Stack(
                                                children:
                                                [
                                                  Container(
                                                  decoration: BoxDecoration(color: Colors.amber,
                                                      image: DecorationImage(
                                                          image: FileImage(File(snapshot.data!)),
                                                          fit: BoxFit.fill
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)),
                                                ),
                                                    const Positioned.fill(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          size: 54,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ) :
                                             Center(
                                              child: Container(),
                                            );
                                          }
                                      );
                                    })
                            ),
                          );
                        }
                    ),
                  )
                  ],
                ),
              )
          );
        }
      ),
    );

  }
}
