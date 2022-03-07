import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/alt_profile/alt_profile_screen.dart';
import 'package:origami/screens/profile/profile_screen.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AppliesScreen extends StatefulWidget {
  final String about;
  AppliesScreen({Key? key, required this.about}) : super(key: key);

  @override
  State<AppliesScreen> createState() => _AppliesScreenState();
}

class _AppliesScreenState extends State<AppliesScreen> {

  String? id;

  @override
  void initState() {
    super.initState();
    User user = User.fromJson(
        jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    id = user.useruid;

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
        title: Text('Who Applied', style: kPageTitleStyle),
        leading: GestureDetector(
          child: const Icon(IconBroken.Arrow___Left_Circle,
              color: xBlack, size: 30),
          onTap: () {
            Navigator.pop(context);
          },
        ),
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
                      .collection('posts')
                      .doc(widget.about)
                      .collection('apply')
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
                                  height: 85,
                                  child: GestureDetector(
                                    child: Card(
                                      elevation: 5.0,
                                      margin: const EdgeInsets.only(
                                          left: 18.0, right: 18.0, top: 15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        leading: GestureDetector(
                                          child: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12.0),
                                              image: DecorationImage(
                                                image: NetworkImage(data['userimage']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            if (data['useruid'] != id) {
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
                                        subtitle: Text(
                                          "${data['useremail']}",
                                          style: kSubtitleStyle.copyWith(
                                              color: xGray),
                                        ),
                                        trailing:const Icon(IconBroken.Arrow___Right_Circle),
                                        ),
                                      ),
                                    onTap: () {

                                    },
                                  ),
                                ),

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
