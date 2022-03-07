import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/chat/chat_screen.dart';
import 'package:origami/screens/favorites/favorites_screen.dart';
import 'package:origami/screens/feed/feed_screen.dart';
import 'package:origami/screens/home/home_helper.dart';
import 'package:origami/screens/settings/settings_screen.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController homePageController = PageController();
  int pageIndex = 0;
  late SharedPreferences sharedPreferences;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String id = '';

  @override
  void initState() {
    super.initState();
    initGetSavedData();
  }

  void initGetSavedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonData =
        jsonDecode(sharedPreferences.getString('userdata')!);
    User user = User.fromJson(jsonData);

    id = user.useruid;
  }

  //update status
  void setStatus(String status) async {
    await _firestore.collection('users').doc(id).update({
      "status": status,
    });
  }

  //change status value
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xBlack,
      body: PageView(
        controller: homePageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          FeedScreen(),
          ChatScreen(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
        onPageChanged: (page) {
          setState(
            () {
              pageIndex = page;
            },
          );
        },
      ),
      bottomNavigationBar: Provider.of<HomeHelper>(context, listen: false)
          .bottomNavBar(context, pageIndex, homePageController),
      // floatingActionButton:  Provider.of<HomeHelper>(context, listen: false).floatingActionButton(context),
    );
  }
}
