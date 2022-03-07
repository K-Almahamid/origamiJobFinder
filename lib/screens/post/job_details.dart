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

class JobDetails extends StatefulWidget {
  final String about;

  JobDetails({Key? key, required this.about}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool show = false;
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
                  return snapshotD.data!.docs.isEmpty
                      ? apply(snapshot)
                      : applied();
                }
              });
        }
      },
    );
  }

  apply(snapshot) => Scaffold(
      backgroundColor: xSilver,
      appBar: Provider.of<PostHelper>(context, listen: false)
          .jobDetailsAppBar(context, snapshot),
      body: Provider.of<PostHelper>(context, listen: false)
          .jobDetailsBody(context, snapshot),
      bottomNavigationBar: (snapshot.data as dynamic)['useruid'] != id!
          ? Provider.of<PostHelper>(context, listen: false)
              .jobDetailsFooterForUser(
                  context, email!, widget.about, name!, image!,id!,snapshot)
          : Provider.of<PostHelper>(context, listen: false)
              .jobDetailsFooterForCompany(
                  context, widget.about, email!, snapshot));

  applied() => Scaffold(
        backgroundColor: xWhite,
        body: Padding(
          padding: const EdgeInsets.only(top: 130.0, left: 10.0, right: 10.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 125,
                  child: Lottie.network(
                      'https://assets7.lottiefiles.com/packages/lf20_9nrge7ao.json'),
                ),
                Text('Job Successful Applied',
                    style:
                        kPageTitleStyle.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    'Job Successful Applied We will inform you about the next information, please sit tight.',
                    textAlign: TextAlign.center,
                    style: kTitleStyle.copyWith(height: 1.5)),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 200.0, bottom: 10.0, left: 15.0, right: 15.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: xOrange,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: MaterialButton(
                        elevation: 2.0,
                        child: Text('SEARCH OTHER JOBS',
                            style: kSubtitleStyle.copyWith(color: xWhite)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: SearchScreen(),
                              type: PageTransitionType.bottomToTop,
                            ),
                          );
                        },
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: xWhite,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: MaterialButton(
                        elevation: 2.0,
                        child: Text('GO TO HOME',
                            style: kSubtitleStyle.copyWith(color: xOrange)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: HomeScreen(),
                              type: PageTransitionType.bottomToTop,
                            ),
                          );
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
}
