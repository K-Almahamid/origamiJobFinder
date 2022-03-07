import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/alt_profile/alt_profile_helper.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AltProfileScreen extends StatefulWidget {
  final String userUid;
  AltProfileScreen({Key? key, required this.userUid}) : super(key: key);

  @override
  State<AltProfileScreen> createState() => _AltProfileScreenState();
}

class _AltProfileScreenState extends State<AltProfileScreen> {

  String? name, image, role, id, countryLocation;
  @override
  void initState() {
    super.initState();
    User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    name = user.username;
    id = user.useruid;
    image = user.userimage;
    role = user.role;
    countryLocation = user.usercountrylocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      appBar:
          Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Lottie.asset('assets/animations/loading.json'));
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                         left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .headerProfile(context, snapshot,widget.userUid,name!,id!),
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .middleProfile(context, snapshot,widget.userUid),
                        const Divider(color: xOrange,thickness: 1.4),
                        // Provider.of<AltProfileHelper>(context, listen: false)
                        //     .buttonsProfile(context, snapshot, userUid),
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .footerProfile(context, snapshot,widget.userUid),
                      ],
                    ),
                  ),
                );
                //     Provider.of<AltProfileHelper>(context, listen: false)
                //         .footerProfile(context, snapshot),
                //     const SizedBox(height:100.0),

              }
            }),
      ),
    );
  }
}
