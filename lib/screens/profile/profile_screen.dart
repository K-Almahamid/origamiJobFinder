import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/profile/profile_helpers.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? name, image, role,cv,id, countryLocation,governorateLocation,phone,bio;
  @override
  void initState() {
    super.initState();
    User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    name = user.username;
    id = user.useruid;
    image = user.userimage;
    role = user.role;
    bio = user.userbio;
    cv = user.usercv;
    phone = user.userphone;
    countryLocation = user.usercountrylocation;
    governorateLocation = user.usergovernoratelocation;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      appBar: Provider.of<ProfileHelper>(context,listen: false).profileAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(child: Lottie.asset('assets/animations/loading.json'));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0,left: 10.0,right: 10.0),
                  child: Column(
                    children: [
                      Provider.of<ProfileHelper>(context, listen: false)
                          .headerProfile(context,countryLocation!,image!,name!,governorateLocation!),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .middleProfile(context, snapshot,id!),
                     const Divider(color: xOrange, thickness: 1.4, endIndent: 10),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .footerProfile(context, snapshot,phone!,bio!,id!,role!,cv!),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
