import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/post/post_helper.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String? id, countryLocation,governorateLocation,areaLocation,name,email,image,bio;
  @override
  void initState() {
    super.initState();
    User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    id = user.useruid;
    name = user.username;
    email = user.useremail;
    image = user.userimage;
    bio = user.userbio;
    countryLocation = user.usercountrylocation;
    governorateLocation = user.usergovernoratelocation;
    areaLocation = user.userarealocation;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: xWhite,
      appBar: Provider.of<PostHelper>(context, listen: false).postAppBar(context,id!,countryLocation!,governorateLocation!,areaLocation!,name!,email!,image!,bio!),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(Provider.of<Authentication>(context, listen: false)
                  .getUserUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(child: Lottie.asset('assets/animations/loading.json'));
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  children: [
                    Provider.of<PostHelper>(context, listen: true)
                        .postBody(context),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
