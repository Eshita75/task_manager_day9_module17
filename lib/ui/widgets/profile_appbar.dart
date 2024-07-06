import 'package:flutter/material.dart';
import 'package:task_manager_day9_module17/ui/controller/auth_controller.dart';
import 'package:task_manager_day9_module17/ui/screens/update_profile_screen.dart';

import '../screens/authentication/sign_in_screen.dart';
import '../utility/app_colors.dart';

AppBar ProfileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,

    leading: GestureDetector(
      onTap: () {
        if(fromUpdateProfile){
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UpdateProfileScreen();
            },
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          // child: NetworkCachedImage(
          //   //url: 'https://whipped.in/cdn/shop/files/pink-butterfly-cake_1800x1800.png?v=1686848832',fit: BoxFit.cover,
          // ),
        ),
      ),
    ),



    title: GestureDetector(
      onTap: () {
        if(fromUpdateProfile){
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UpdateProfileScreen();
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            //AuthController.userData?.fullName ?? '',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),

    actions: [
      IconButton(onPressed: () async {
        await AuthController.clearAllData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
      }, icon: const Icon(Icons.logout))
    ],
  );
}