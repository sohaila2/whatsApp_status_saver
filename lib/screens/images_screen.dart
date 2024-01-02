import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/screens/display_image_screen.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';

import '../provider/theme_provider.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
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
                      child: Consumer<GetStatusProvider>(builder: (context, file, child) {
                        if (_isFetched == false) {
                          file.getStatus(".jpg");
                          Future.delayed(Duration(microseconds: 1), () {
                            _isFetched = true;
                          });
                        }
                        return file.isWhatsAppAvailable == false
                            ? Center(
                          child: Text("WhatsApp not available"),
                        )
                            : file.getImages.isEmpty
                            ? Center(
                          child: Text("No images avaialble"),
                        )
                            : Container(
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
                              children: List.generate(file.getImages.length, (index) {
                                final data = file.getImages[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => DisplayImageScreen(
                                              imagePath: data.path,
                                            )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        image: DecorationImage(
                                            image: FileImage(File(data.path)),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              })),
                        );
                      })
                  )
                ],
              ),
          );
        }
      ),
    );
  }
}
