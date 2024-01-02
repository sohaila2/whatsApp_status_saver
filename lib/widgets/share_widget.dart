import 'package:flutter/material.dart';

import '../services/url_service.dart';

class ShareAlertDialog extends StatelessWidget {
  const ShareAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Share status',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  launchSocialMediaAppIfInstalled('');

                },
                child: Image.asset("assets/images/Dynamic Links.png",
                  height: 68,
                  width: 72,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: (){
                  launchSocialMediaAppIfInstalled('https://drive.google.com/');

                },
                child:
                Image.asset("assets/images/Google Drive.png",
                  height: 68,
                  width: 72,),
              ),
              SizedBox(
                width: 10,

              ),
              GestureDetector(
                onTap: (){
                  launchSocialMediaAppIfInstalled('mailto:?subject=Subject&body=Body');
                },
                child:
                Image.asset("assets/images/Gmail Logo.png",
                  height: 68,
                  width: 72,),),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  launchSocialMediaAppIfInstalled('whatsapp://send?text=Your%20message');
                },
                child:Image.asset("assets/images/WhatsApp.png",
                  height: 68,
                  width: 72,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: (){
                  launchSocialMediaAppIfInstalled('https://www.facebook.com/');

                },
                child:
                Image.asset("assets/images/Facebook.png",
                  height: 68,
                  width: 72,),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: (){
                  launchSocialMediaAppIfInstalled('https://www.instagram.com/');

                },
                child:
                Image.asset("assets/images/Instagram.png",
                  height: 68,
                  width: 72,),),
            ],
          )
        ],
      ),
    );
  }
}
