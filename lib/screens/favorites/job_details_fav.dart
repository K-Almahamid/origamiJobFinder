import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/home/home_screen.dart';
import 'package:origami/screens/post/post_helper.dart';
import 'package:origami/screens/search/search_screen.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class JobDetailsFav extends StatefulWidget {
  final String about;

  JobDetailsFav({Key? key, required this.about}) : super(key: key);

  @override
  State<JobDetailsFav> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetailsFav> {

  String? email, id, name, image;

  @override
  void initState() {
    super.initState();
    User user = User.fromJson(
        jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    id = user.useruid;
    email = user.useremail;
    name = user.username;
    image = user.userimage;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.about)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Lottie.asset('assets/animations/loading.json'));
        } else {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.about)
                  .collection('apply')
                  .where('useremail', isEqualTo: email)
                  .snapshots(),
              builder: (context, snapshotD) {
                if (snapshotD.data == null) {
                  return const Text('');
                } else {
                  return Scaffold(
                      backgroundColor: xSilver,
                      appBar: Provider.of<PostHelper>(context, listen: false)
                          .jobDetailsAppBar(context, snapshot),
                      body: Provider.of<PostHelper>(context, listen: false)
                          .jobDetailsBody(context, snapshot),
                      bottomNavigationBar: (snapshot.data as dynamic)['useruid'] != id!
                          ? Provider.of<PostHelper>(context, listen: false)
                          .jobDetailsFooterForUser(
                          context, email!, widget.about, name!, image!,id!,snapshot,)
                          : Provider.of<PostHelper>(context, listen: false)
                          .jobDetailsFooterForCompany(
                          context, widget.about, email!, snapshot));
                }
              });
        }
      },
    );
  }
}
