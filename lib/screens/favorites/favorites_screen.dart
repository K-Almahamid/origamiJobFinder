import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/alt_profile/alt_profile_screen.dart';
import 'package:origami/screens/favorites/job_details_fav.dart';
import 'package:origami/screens/post/job_details.dart';
import 'package:origami/screens/profile/profile_screen.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String? name, image, role, id, email;

  @override
  void initState() {
    super.initState();
    User user = User.fromJson(
        jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    name = user.username;
    id = user.useruid;
    image = user.userimage;
    role = user.role;
    email = user.useremail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        shadowColor: xOrange,
        title: Text('Favorites', style: kPageTitleStyle),
        leading: const SizedBox(width: 0.0, height: 0.0),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users-favorite-jobs')
                      .doc(email)
                      .collection('jobs')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Lottie.asset('assets/animations/loading.json'),
                      );
                    } else {
                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            Map<String, dynamic> data = documentSnapshot.data()!
                                as Map<String, dynamic>;
                            Provider.of<PostOptions>(context, listen: false)
                                .showTimeAgo(data['time'] ?? '');
                            // getData(data['useruid']);
                            return Stack(
                              children: [
                                SizedBox(
                                  height: 90,
                                  child: GestureDetector(
                                    child: Card(
                                      elevation: 5.0,
                                      margin: const EdgeInsets.only(
                                          left: 18.0, right: 18.0, top: 5.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: ListTile(
                                          leading: GestureDetector(
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(data[
                                                          'userimage'] ??
                                                      'https://firebasestorage.googleapis.com/v0/b/origami-1999ks.appspot.com/o/p.jpg?alt=media&token=4fceda5d-7b3d-46b0-9907-fadd7bb40d8e'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              if (data['useruid'] == id) {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: AltProfileScreen(
                                                      userUid: data['useruid'],
                                                    ),
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: ProfileScreen(),
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${data['username']}",
                                                  style: kTitleStyle),
                                              Text(
                                                Provider.of<PostOptions>(context,
                                                        listen: false)
                                                    .getTimePosted
                                                    .toString(),
                                                style: kSubtitleStyle.copyWith(
                                                    color: xGray),
                                              ),
                                            ],
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              "${data['jobtitle']}",
                                              style: kSubtitleStyle.copyWith(
                                                  color: xGray),
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            child: const Icon(
                                              Icons.more_vert,
                                              color: xBlack,
                                            ),
                                            onTap: () {
                                              postOptionsFav(
                                                  context, email!, data['about']);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: JobDetailsFav(
                                            about: data['about'],
                                          ),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(data['about'])
                                        .collection('apply')
                                        .where('useremail', isEqualTo: email)
                                        .snapshots(),
                                    builder: (context, snapshotD) {
                                      if (snapshotD.data == null) {
                                        return const Text('');
                                      } else {
                                        return snapshotD.data!.docs.isEmpty
                                            ? const SizedBox()
                                            : Positioned(
                                                left: 10,
                                                top: 5,
                                                child: SizedBox(
                                                  height: 45,
                                                  child: Lottie.network(
                                                      'https://assets7.lottiefiles.com/packages/lf20_9nrge7ao.json'),
                                                ),
                                              );
                                      }
                                    })
                              ],
                            );
                          }).toList());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
