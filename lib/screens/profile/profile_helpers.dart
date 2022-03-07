import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/post/job_details.dart';
import 'package:origami/screens/profile/profile_edit.dart';

import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHelper with ChangeNotifier {
  // Map<String, dynamic>? userMap;
  // void getData(id) async {
  //
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where("useruid", isEqualTo: id)
  //       .get()
  //       .then((value) {
  //     userMap = value.docs[0].data();
  //     print(userMap);
  //   });
  // }
  PreferredSizeWidget profileAppBar(BuildContext context) =>
      AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        leadingWidth: 50,
        shadowColor: xOrange,
        leading: GestureDetector(
          child: const Icon(
            IconBroken.Arrow___Left_Circle,
            color: xBlack,
            size: 30,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile', style: kPageTitleStyle),
        actions: [
          GestureDetector(
            child: const Icon(
              IconBroken.Edit_Square,
              color: xBlack,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: ProfileEdit(),
                  type: PageTransitionType.bottomToTop,
                ),
              );
            },
          ),
          const SizedBox(width: 10.0),
        ],
      );

  Widget headerProfile(BuildContext context, String country, String image,
      String name, String userGovernorate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(image),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Profile,
                              color: xOrange,
                              size: 17.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SizedBox(
                                width: 200,
                                child: Text(name,
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTitleStyle.copyWith(color: xBlack)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              IconBroken.Location,
                              color: xOrange,
                              size: 17.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                width: 200.0,
                                child: Text(
                                    country +
                                        ', ' +
                                        userGovernorate,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTitleStyle.copyWith(color: xGray)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot, String id) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 15.0,
        left: 15.0,
        top: 15.0,
        bottom: 10.0,
      ),
      child: DefaultTextStyle(
        style:
        const TextStyle(color: xGray, fontSize: 15.0, letterSpacing: 2.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Posts',
                    style: kTitleStyle.copyWith(color: xGray),
                  ),
                  const SizedBox(height: 5.0),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('useruid', isGreaterThanOrEqualTo: id)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                            Lottie.asset('assets/animations/loading.json'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            snapshot.data!.docs.length.toString(),
                            style: kTitleStyle.copyWith(color: xBlack),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: xBlack,
              width: 0.2,
              height: 22,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Following',
                    style: kTitleStyle.copyWith(color: xGray),
                  ),
                  const SizedBox(height: 5.0),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(id)
                        .collection('following')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                            Lottie.asset('assets/animations/loading.json'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            snapshot.data!.docs.length.toString(),
                            style: kTitleStyle.copyWith(color: xBlack),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: xBlack,
              width: 0.2,
              height: 22,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Followers',
                    style: kTitleStyle.copyWith(color: xGray),
                  ),
                  const SizedBox(height: 5.0),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(id)
                        .collection('followers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                            Lottie.asset('assets/animations/loading.json'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            snapshot.data!.docs.length.toString(),
                            style: kTitleStyle.copyWith(color: xBlack),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot, String phone,
      String bio, String id, String role,String cv) {
    print('hey');
    print(role);
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              TabBar(
                physics: const BouncingScrollPhysics(),
                unselectedLabelColor: xBlack,
                indicatorColor: xOrange,
                indicatorWeight: 2,
                labelStyle: kTitleStyle,
                labelColor: xBlack,
                tabs: const [
                  Tab(text: "Posts"),
                  Tab(text: "About"),
                  Tab(text: "Contact"),
                ],
              )
            ],
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.45,
            child: TabBarView(
              children: [
                loadAllUserPosts(context, snapshot, id),
                profileAbout(context, bio),
                contact(context, phone, role,cv),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget contact(BuildContext context, String phone, String role,String cv) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Row(children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              color: xWhite,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 315,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(IconBroken.Call),
                          ),
                          Text(
                            phone,
                            style: kTitleStyle,
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                    Container(
                      color: xBlack,
                      width: 300,
                      height: 0.2,
                    ),
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              EvaIcons.linkedin,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'https://www.linkedin.com/in/khaled-walid-almahamid-b59a82200',
                              style: kTitleStyle,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                    Container(
                      color: xBlack,
                      width: 300,
                      height: 0.2,
                    ),
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              EvaIcons.github,
                              color: xOrange,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'https://www.linkedin.com/in/khaled-walid-almahamid-b59a82200',
                              style: kTitleStyle,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
        role == 'company' ? const SizedBox(width: 0.0, height: 40.0) :
        Expanded(
          flex: 1,
          child: Row(
              children: [
                GestureDetector(
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    color: xWhite,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 315,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Icon(EvaIcons.fileText),
                                ),
                                Text(
                                  'Click here to browse CV',
                                  style: kTitleStyle,
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    openBrowserURL(url:cv,inApp: true);
                  },
                )
              ]),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Future openBrowserURL({required String url, bool inApp = false,}) async {
    if (await canLaunch(url)) {
      await launch(url,
        forceWebView: inApp,
        enableJavaScript: true,
      );
    }
  }

  Widget profileAbout(BuildContext context, String bio) {
    return ListView(
      children: <Widget>[
        Text(
          "About Company",
          style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15.0),
        Text(
          bio,
          style: kSubtitleStyle.copyWith(
            fontWeight: FontWeight.w300,
            height: 1.5,
            color: const Color(0xFF5B5B5B),
          ),
        ),
      ],
    );
  }

  Widget loadAllUserPosts(BuildContext context, AsyncSnapshot snapshot,
      String id) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.25,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('useruid', isGreaterThanOrEqualTo: id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Lottie.asset('assets/animations/loading.json'));
                  } else {
                    return loadPosts(context, snapshot);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadPosts(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return Expanded(
      child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children:
          snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
            Provider.of<PostOptions>(context, listen: false)
                .showTimeAgo(data['time']);
            // getData(data['useruid']);
            return GestureDetector(
              child: Card(
                elevation: 3.0,
                margin: const EdgeInsets.only(right: 18.0, top: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: NetworkImage(data['userimage']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${data['username']}", style: kTitleStyle),
                      Text(
                        Provider
                            .of<PostOptions>(context, listen: false)
                            .getTimePosted
                            .toString(),
                        style:
                        kSubtitleStyle.copyWith(color: xGray, fontSize: 13),
                      ),
                    ],
                  ),
                  subtitle: Text(data['jobtitle'],
                      style: kSubtitleStyle.copyWith(color: xGray)),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: JobDetails(
                      about: data['about'],
                    ),
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
            );
          }).toList()),
    );
  }
}
