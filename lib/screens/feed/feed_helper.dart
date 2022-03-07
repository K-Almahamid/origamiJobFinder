import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/alt_profile/alt_profile_screen.dart';
import 'package:origami/screens/post/job_details.dart';
import 'package:origami/screens/post/new_post_screen.dart';
import 'package:origami/screens/profile/profile_screen.dart';
import 'package:origami/screens/search/search_screen.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelper with ChangeNotifier {
  // Map<String, dynamic>? userMap;
  // void getData(id) async {
  //
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where("useruid", isEqualTo: id)
  //       .get()
  //       .then((value) {
  //       userMap = value.docs[0].data();
  //     print(userMap);
  //   });
  // }

  feedAppbar(BuildContext context, String role, String image) {
    return SliverAppBar(
      floating: true,
      // pinned: true,
      backgroundColor: xWhite,
      elevation: 0.0,
      leadingWidth: 0.0,
      leading: const SizedBox(),
      title: const Text(
        'Origami',
        style: TextStyle(
          color: xOrange,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ephesis-Regular',
        ),
      ),
      actions: <Widget>[
        role == 'company'
            ? IconButton(
                icon: const Icon(
                  IconBroken.Paper_Plus,
                  color: xBlack,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: NewPostScreen(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
              )
            : Container(),
        const SizedBox(width: 5.0),
        GestureDetector(
          child: CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 20,
          ),
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: ProfileScreen(),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
        ),
        const SizedBox(width: 15.0),
      ],
    );
  }

  Widget feedHeader(BuildContext context, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25.0),
        Text(
          "Hi $name,\nFind your Dream Job",
          style: kPageTitleStyle,
        ),
        const SizedBox(height: 25.0),
        Container(
          width: double.infinity,
          height: 50.0,
          margin: const EdgeInsets.only(right: 18.0),
          child: GestureDetector(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Search,
                            size: 25.0,
                            color: xBlack,
                          ),
                          const SizedBox(width: 5.0),
                          Text('Search for job title',
                              style: kSubtitleStyle.copyWith(
                                color: Colors.black38,
                              ))
                        ],
                      )),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: SearchScreen(),
                  type: PageTransitionType.bottomToTop,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 35.0),
      ],
    );
  }

  Widget feedRecentJobs(BuildContext context, uid, email) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time', descending: true)
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
                  return loadRecentJobs(context, snapshot, uid, email);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget loadRecentJobs(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, String uid, String email) {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data()! as Map<String, dynamic>;
          Provider.of<PostOptions>(context, listen: false)
              .showTimeAgo(data['time'] ?? '');
          // getData(data['useruid']);
          return Stack(
            children: [
              SizedBox(
                height: 90,
                child: GestureDetector(
                  child: Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.only(right: 18.0, top: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        leading: GestureDetector(
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: NetworkImage(data['userimage'] ??
                                    'https://firebasestorage.googleapis.com/v0/b/origami-1999ks.appspot.com/o/p.jpg?alt=media&token=4fceda5d-7b3d-46b0-9907-fadd7bb40d8e'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (data['useruid'] != uid) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: AltProfileScreen(
                                    userUid: data['useruid'],
                                  ),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ProfileScreen(),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            }
                          },
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${data['username']}", style: kTitleStyle),
                            Text(
                              Provider.of<PostOptions>(context, listen: false)
                                  .getTimePosted
                                  .toString(),
                              style: kSubtitleStyle.copyWith(color: xGray),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "${data['jobtitle']}",
                            style: kSubtitleStyle.copyWith(color: xGray),
                          ),
                        ),
                        trailing: GestureDetector(
                          child: const Icon(
                            Icons.more_vert,
                            color: xBlack,
                          ),
                          onTap: () {
                            postOptions(context, email, data['about']);
                          },
                        ),
                      ),
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
                        top: 9,
                        child: SizedBox(
                          height: 40,
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

  Widget feedNearbyJobs(
      BuildContext context, String country, String uid, String email) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('usercountrylocation',
                        isGreaterThanOrEqualTo: country)
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
                    return loadNearbyJobs(context, snapshot, uid, email);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  loadNearbyJobs(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
      uid, String email) {
    return ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data()! as Map<String, dynamic>;
          Provider.of<PostOptions>(context, listen: false)
              .showTimeAgo(data['time']);
          return Stack(
            children: [
              GestureDetector(
                child: SizedBox(
                  height: 160,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    color: Colors.white,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
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
                                  onTap: () {
                                    if (data['useruid'] != uid) {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: AltProfileScreen(
                                            userUid: data['useruid'],
                                          ),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: ProfileScreen(),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: SizedBox(
                                          width: 100,
                                          child: Text(
                                            data['username'],
                                            style: kSubtitleStyle,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        height: 20,
                                        child: Text(
                                          "${data['usercountrylocation']},${data['usergovernoratelocation']}",
                                          style: kSubtitleStyle.copyWith(
                                              color: xGray),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 5.0),
                                data['useruid'] == uid
                                    ? GestureDetector(
                                        child: const Icon(
                                          Icons.more_vert,
                                          color: xBlack,
                                        ),
                                        onTap: () {
                                          postOptions(
                                              context, email, data['about']);
                                        },
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: SizedBox(
                                width: 250,
                                child: Text(
                                  "${data['jobtitle']}",
                                  style: kTitleStyle,
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       data['username'],
                            //       style: kSubtitleStyle,
                            //     ),
                            //     Text(
                            //       "  •  ",
                            //       style: kSubtitleStyle,
                            //     ),
                            //     SizedBox(
                            //       width: 150,
                            //       height:17,
                            //       child: Text(
                            //         "${data['usercountrylocation']},${data['usergovernoratelocation']}",
                            //         style: kSubtitleStyle.copyWith(color: xGray),
                            //         overflow: TextOverflow.fade,
                            //         softWrap: true,
                            //         maxLines: 1,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  data['remote'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['remote'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  data['anywhere'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['anywhere'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  data['fulltime'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['fulltime'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  data['parttime'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['parttime'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  // data['contract'] != ''
                                  //     ? Container(
                                  //         alignment: Alignment.center,
                                  //         margin: const EdgeInsets.only(
                                  //             right: 10.0),
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 12.0, vertical: 5.0),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(12.0),
                                  //           color: Colors.white,
                                  //           border: Border.all(
                                  //             color: xBlack,
                                  //             width: 0.5,
                                  //           ),
                                  //         ),
                                  //         child: Text(
                                  //           data['contract'],
                                  //           style: kSubtitleStyle.copyWith(
                                  //             fontSize: 12.0,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : const SizedBox(width: 0.0, height: 0.0),
                                  // data['freelance'] != ''
                                  //     ? Container(
                                  //         alignment: Alignment.center,
                                  //         margin: const EdgeInsets.only(
                                  //             right: 10.0),
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 12.0, vertical: 5.0),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(12.0),
                                  //           color: Colors.white,
                                  //           border: Border.all(
                                  //             color: xBlack,
                                  //             width: 0.5,
                                  //           ),
                                  //         ),
                                  //         child: Text(
                                  //           data['freelance'],
                                  //           style: kSubtitleStyle.copyWith(
                                  //             fontSize: 12.0,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : const SizedBox(width: 0.0, height: 0.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        child: SizedBox(
                          height: 40,
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

  Widget feedJobs(BuildContext context, String uid, String variable, String tag,
      String email) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where(variable, isGreaterThanOrEqualTo: tag)
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
                    return loadJobs(context, snapshot, uid, email);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  loadJobs(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, uid,
      String email) {
    return ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data()! as Map<String, dynamic>;
          Provider.of<PostOptions>(context, listen: false)
              .showTimeAgo(data['time']);
          return Stack(
            children: [
              SizedBox(
                height: 165,
                child: GestureDetector(
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    color: Colors.white,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
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
                                  onTap: () {
                                    if (data['useruid'] != uid) {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: AltProfileScreen(
                                            userUid: data['useruid'],
                                          ),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: ProfileScreen(),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: SizedBox(
                                          width: 100,
                                          child: Text(
                                            data['username'],
                                            style: kSubtitleStyle,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        height: 20,
                                        child: Text(
                                          "${data['usercountrylocation']},${data['usergovernoratelocation']}",
                                          style: kSubtitleStyle.copyWith(
                                              color: xGray),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 5.0),
                                data['useruid'] == uid
                                    ? GestureDetector(
                                        child: const Icon(
                                          Icons.more_vert,
                                          color: xBlack,
                                        ),
                                        onTap: () {
                                          postOptions(
                                              context, email, data['about']);
                                        },
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: SizedBox(
                                width: 250,
                                child: Text(
                                  "${data['jobtitle']}",
                                  style: kTitleStyle,
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       data['username'],
                            //       style: kSubtitleStyle,
                            //     ),
                            //     Text(
                            //       "  •  ",
                            //       style: kSubtitleStyle,
                            //     ),
                            //     SizedBox(
                            //       width: 150,
                            //       height:17,
                            //       child: Text(
                            //         "${data['usercountrylocation']},${data['usergovernoratelocation']}",
                            //         style: kSubtitleStyle.copyWith(color: xGray),
                            //         overflow: TextOverflow.fade,
                            //         softWrap: true,
                            //         maxLines: 1,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  data['remote'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['remote'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  data['anywhere'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['anywhere'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  data['fulltime'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['fulltime'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  data['parttime'] != ''
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: xBlack,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            data['parttime'],
                                            style: kSubtitleStyle.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  // data['freelance'] != ''
                                  //     ? Container(
                                  //         alignment: Alignment.center,
                                  //         margin: const EdgeInsets.only(
                                  //             right: 10.0),
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 12.0, vertical: 5.0),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(12.0),
                                  //           color: Colors.white,
                                  //           border: Border.all(
                                  //             color: xBlack,
                                  //             width: 0.5,
                                  //           ),
                                  //         ),
                                  //         child: Text(
                                  //           data['freelance'],
                                  //           style: kSubtitleStyle.copyWith(
                                  //             fontSize: 12.0,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : const SizedBox(width: 0.0, height: 0.0),
                                  // data['contract'] != ''
                                  //     ? Container(
                                  //         alignment: Alignment.center,
                                  //         margin: const EdgeInsets.only(
                                  //             right: 10.0),
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 12.0, vertical: 5.0),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(12.0),
                                  //           color: Colors.white,
                                  //           border: Border.all(
                                  //             color: xBlack,
                                  //             width: 0.5,
                                  //           ),
                                  //         ),
                                  //         child: Text(
                                  //           data['contract'],
                                  //           style: kSubtitleStyle.copyWith(
                                  //             fontSize: 12.0,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : const SizedBox(width: 0.0, height: 0.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              child: SizedBox(
                                height: 40,
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
}
