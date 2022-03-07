import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/profile/profile_screen.dart';
import 'package:origami/screens/settings/about_screen.dart';
import 'package:origami/screens/settings/settings_helper.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        shadowColor: xOrange,
        leading: const SizedBox(width: 0.0, height: 0.0),
        leadingWidth: 0,
        title: Text('Settings', style: kPageTitleStyle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account', style: kPageTitleStyle),
              const SizedBox(height: 15.0),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                color: xWhite,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height:50,
                        child: GestureDetector(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child:  Icon(IconBroken.Profile, size: 28.0),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Profile',
                                      //'user.username!',
                                      style: kTitleStyle,
                                      overflow: TextOverflow.ellipsis),
                                  // const SizedBox(height: 4.0),
                                  // Text(
                                  //   'user.useremail!',
                                  //   style:
                                  //       kSubtitleStyle.copyWith(color: xGray),
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(IconBroken.Arrow___Right_Circle),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: ProfileScreen(),
                                type: PageTransitionType.leftToRight,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              Text('Settings', style: kPageTitleStyle),
              const SizedBox(height: 15.0),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                color: xWhite,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height:50,
                        child: GestureDetector(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: Icon(EvaIcons.colorPaletteOutline, size: 28.0),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Theme', style: kTitleStyle),
                                ],
                              ),
                              const Spacer(),
                              const Icon(IconBroken.Arrow___Right_Circle),
                            ],
                          ),
                          onTap: () {
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height:10.0),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                color: xWhite,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height:50,
                        child: GestureDetector(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: Icon(IconBroken.Info_Circle, size: 28.0),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('About', style: kTitleStyle),                                ],
                              ),
                              const Spacer(),
                              const Icon(IconBroken.Arrow___Right_Circle),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child:const About(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                    icon: const Icon(IconBroken.Logout,
                        size: 25.0, color: xOrange),
                    label: Text(
                      'Sign out',
                      style: kTitleStyle.copyWith(color: xOrange),
                    ),
                    onPressed: () {
                      CacheHelper.putDataInSharedPreference(
                              value: false, key: 'Logged')
                          .whenComplete(
                        () {
                          Provider.of<SettingsHelper>(context, listen: false)
                              .logOutDialog(context);
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
