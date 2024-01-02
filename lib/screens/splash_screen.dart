import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }


  void navigate(){
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_) =>
      const NavScreen()), (route) => false);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buildContainerDecoration(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top:300,bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    "assets/images/Group 1.png",
                    height: 150,
                  ),
                Spacer(),
                const Text(
                  "\t\tWhatsApp\nStatus Saver",
                  style: TextStyle(
                    color:Colors.white,
                    fontSize:18,
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  BoxDecoration buildContainerDecoration() {
    return const BoxDecoration(
      gradient: RadialGradient(
        colors: [

          Color(0xff002D1c),
          Color(0xff101010),
        ],
       //  begin: Alignment.topCenter,
       //  end: Alignment.bottomCenter,
       // stops: [0.4, 0.7,1],
        radius: 0.6,
        tileMode: TileMode.clamp,
      ),
    );
  }
}
