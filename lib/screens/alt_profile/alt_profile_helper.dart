import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/screens/chat/chat_room.dart';
import 'package:origami/screens/post/job_details.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltProfileHelper with ChangeNotifier {
  bool followSwitch = false;
  String follow = "Follow";

  //to name chatroom doc id
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Map<String, dynamic>? userMap;

  void getData(name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("username", isEqualTo: name)
        .get()
        .then((value) {
      userMap = value.docs[0].data();
      print(userMap);
      print('hey');
    });
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: xSilver,
      elevation: 3.0,
      shadowColor: xOrange,
      title: Text('Profile', style: kPageTitleStyle),
      leading: GestureDetector(
        child:
            const Icon(IconBroken.Arrow___Left_Circle, color: xBlack, size: 30),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget headerProfile(
      BuildContext context, AsyncSnapshot snapshot, String id, String name,String currentUserId) {
    getData((snapshot.data as dynamic)['username']);
    print('alt profile username = ${(snapshot.data as dynamic)['username']}');
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage:
                    NetworkImage((snapshot.data as dynamic)['userimage']),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          IconBroken.Profile,
                          color: xOrange,
                          size: 17.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            width: 220,
                            child: Text(
                                // _userData.userName,
                                (snapshot.data as dynamic)['username'],
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
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          IconBroken.Location,
                          color: xOrange,
                          size: 17.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                              "${(snapshot.data as dynamic)['usercountrylocation']},${(snapshot.data as dynamic)['usergovernoratelocation']} ${(snapshot.data as dynamic)['userarealocation']}",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: kTitleStyle.copyWith(color: xGray)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 40.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                            ),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUserId)
                                    .collection('following')
                                    .where('userid', isEqualTo:id)
                                    .snapshots(),
                                builder: (context, snapshotD) {
                                  if (snapshotD.data == null) {
                                    return const Text('');
                                  } else {
                                      print(currentUserId);
                                    return snapshotD.data!.docs.isEmpty ? Text(
                                      'Follow',
                                      style:
                                          kTitleStyle.copyWith(color: xBlack),
                                    ) :  Text(
                                      'Following',
                                      style:
                                      kTitleStyle.copyWith(color: xBlack),
                                    ) ;
                                  }
                                }),
                            onPressed: () {
                              notifyListeners();
                              Provider.of<FireBaseOperations>(context,
                                      listen: false)
                                  .followUser(
                                id,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid!,
                                {
                                  'username': Provider.of<FireBaseOperations>(
                                          context,
                                          listen: false)
                                      .initUserName,
                                  'userimage': Provider.of<FireBaseOperations>(
                                          context,
                                          listen: false)
                                      .initUserImage,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'useremail': Provider.of<FireBaseOperations>(
                                          context,
                                          listen: false)
                                      .initUserEmail,
                                  'time': Timestamp.now(),
                                },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid!,
                                id,
                                {
                                  'username':
                                      (snapshot.data as dynamic)['username'],
                                  'userimage':
                                      (snapshot.data as dynamic)['userimage'],
                                  'useremail':
                                      (snapshot.data as dynamic)['useremail'],
                                  'useruid':
                                      (snapshot.data as dynamic)['useruid'],
                                  'time': Timestamp.now(),
                                },
                              )
                                  .whenComplete(() {
                                warningText(context,'Followed ${(snapshot.data as dynamic)['username']}');
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: xOrange, // background
                              onPrimary: xWhite, // foreground
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                            ),
                            child: Text(
                              'Message',
                              style: kTitleStyle.copyWith(color: xWhite),
                            ),
                            onPressed: () {
                              String roomId =
                                  chatRoomId(name, userMap!['username']);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: userMap!,
                                    username:
                                        (snapshot.data as dynamic)['username'],
                                  ),
                                ),
                              );
                            },
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
    );
  }

  Widget middleProfile(
      BuildContext context, AsyncSnapshot snapshot, String userUid) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 38.0,
        left: 38.0,
        top: 20.0,
        bottom: 10.0,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        .where('useruid', isGreaterThanOrEqualTo: userUid)
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
                        .doc((snapshot.data as dynamic)['useruid'])
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
                        .doc((snapshot.data as dynamic)['useruid'])
                        .collection('followers')
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
          ],
        ),
      ),
    );
  }

  Widget contact(BuildContext context, AsyncSnapshot snapshot) {
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
                      bottomRight: Radius.circular(20))),
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
                            (snapshot.data as dynamic)['userphone'],
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
        (snapshot.data as dynamic)['role'] == 'company'
            ? const SizedBox(width: 10.0, height: 60.0)
            : Expanded(
                flex: 1,
                child: Row(children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
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
                  )
                ]),
              ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget footerProfile(
      BuildContext context, AsyncSnapshot snapshot, String userUid) {
    return DefaultTabController(
      length: (snapshot.data as dynamic)['role'] == 1 ? 3 : 2,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              (snapshot.data as dynamic)['role'] == 1
                  ? TabBar(
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
                  : TabBar(
                      physics: const BouncingScrollPhysics(),
                      unselectedLabelColor: xBlack,
                      indicatorColor: xOrange,
                      indicatorWeight: 2,
                      labelStyle: kTitleStyle,
                      labelColor: xBlack,
                      tabs: const [
                        Tab(text: "About"),
                        Tab(text: "Contact"),
                      ],
                    )
            ],
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,
            child: (snapshot.data as dynamic)['role'] == 1
                ? TabBarView(
                    children: [
                      loadAllUserPosts(context, snapshot, userUid),
                      profileAbout(context, snapshot),
                      contact(context, snapshot),
                    ],
                  )
                : TabBarView(
                    children: [
                      profileAbout(context, snapshot),
                      contact(context, snapshot),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Widget profileAbout(BuildContext context, AsyncSnapshot snapshot) {
    return ListView(
      children: <Widget>[
        Text(
          "About Company",
          style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15.0),
        Text(
          (snapshot.data as dynamic)['userbio'],
          style: kSubtitleStyle.copyWith(
            fontWeight: FontWeight.w300,
            height: 1.5,
            color: const Color(0xFF5B5B5B),
          ),
        ),
      ],
    );
  }

  Widget loadAllUserPosts(
      BuildContext context, AsyncSnapshot snapshot, String userUid) {
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
                    .where('useruid', isGreaterThanOrEqualTo: userUid)
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

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data()! as Map<String, dynamic>;
          Provider.of<PostOptions>(context, listen: false)
              .showTimeAgo(data['time']);
          return GestureDetector(
            child: Card(
              elevation: 0.0,
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
                      Provider.of<PostOptions>(context, listen: false)
                          .getTimePosted
                          .toString(),
                      style:
                          kSubtitleStyle.copyWith(color: xGray, fontSize: 13),
                    ),
                  ],
                ),
                subtitle: Text("Senior UI Designer",
                    style: kSubtitleStyle.copyWith(color: xGray)),
                trailing: GestureDetector(
                  child: const Icon(
                    Icons.bookmark_border,
                    color: xBlack,
                    size: 25,
                  ),
                  onTap: () {
                    print('hey');
                  },
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
          );
        }).toList());
  }

// checkFollowersSheet(BuildContext context, dynamic snapshot) {
//   return showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return Container(
//         height: MediaQuery.of(context).size.height * 0.4,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           color: constantColors.blueGreyColor,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc((snapshot.data as dynamic)['useruid'])
//               .collection('followers')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Text('Something went wrong');
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else {
//               return ListView(
//                   children: snapshot.data!.docs
//                       .map((DocumentSnapshot documentSnapshot) {
//                 Map<String, dynamic> data =
//                     documentSnapshot.data()! as Map<String, dynamic>;
//                 return ListTile(
//                   onTap: () {
//                     if (data['useruid'] !=
//                         Provider.of<Authentication>(context, listen: false)
//                             .getUserUid) {
//                       Navigator.pushReplacement(
//                         context,
//                         PageTransition(
//                           child: AltProfile(
//                             userUid: data['useruid'],
//                           ),
//                           type: PageTransitionType.leftToRight,
//                         ),
//                       );
//                     }
//                   },
//                   trailing: data['useruid'] ==
//                           Provider.of<Authentication>(context, listen: false)
//                               .getUserUid
//                       ? const SizedBox(width: 0.0, height: 0.0)
//                       : MaterialButton(
//                           color: constantColors.blueColor,
//                           child: Text(
//                             'Unfollow',
//                             style: TextStyle(
//                               color: constantColors.whiteColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                             ),
//                           ),
//                           onPressed: () {},
//                         ),
//                   leading: CircleAvatar(
//                     backgroundColor: constantColors.darkColor,
//                     backgroundImage: NetworkImage(data['userimage']),
//                   ),
//                   title: Text(
//                     data['username'],
//                     style: TextStyle(
//                       color: constantColors.whiteColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                   subtitle: Text(
//                     data['useremail'],
//                     style: TextStyle(
//                       color: constantColors.yellowColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                 );
//               }).toList());
//             }
//           },
//         ),
//       );
//     },
//   );
// }
//
// showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
//   return showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return Container(
//         height: MediaQuery.of(context).size.height * 0.6,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           color: constantColors.blueGreyColor,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.3,
//               width: MediaQuery.of(context).size.width,
//               child: FittedBox(
//                 child: Image.network(documentSnapshot['postimage']),
//               ),
//             ),
//             Text(
//               documentSnapshot['caption'],
//               style: TextStyle(
//                 color: constantColors.whiteColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 80.0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         child: Icon(
//                           FontAwesomeIcons.heart,
//                           color: constantColors.redColor,
//                           size: 22.0,
//                         ),
//                         onTap: () {
//                           print('Adding Like ... ');
//                           Provider.of<PostFunctions>(context, listen: false)
//                               .addLike(
//                             context,
//                             documentSnapshot['caption'],
//                             Provider.of<Authentication>(context,
//                                 listen: false)
//                                 .getUserUid!,
//                           );
//                         },
//                         onLongPress: () {
//                           Provider.of<PostFunctions>(context, listen: false)
//                               .showLikes(context, documentSnapshot['caption']);
//                         },
//                       ),
//                       StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('posts')
//                               .doc(documentSnapshot['caption'])
//                               .collection('likes')
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return Text('Something went wrong');
//                             }
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             } else {
//                               return Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   snapshot.data!.docs.length.toString(),
//                                   style: TextStyle(
//                                     color: constantColors.whiteColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                               );
//                             }
//                           })
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 80.0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         child: Icon(
//                           FontAwesomeIcons.comment,
//                           color: constantColors.blueColor,
//                           size: 22.0,
//                         ),
//                         onTap: () {
//                           Provider.of<PostFunctions>(context, listen: false)
//                               .showCommentsSheet(
//                               context, documentSnapshot, documentSnapshot['caption']);
//                         },
//                       ),
//                       StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('posts')
//                               .doc(documentSnapshot['caption'])
//                               .collection('comments')
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return const Text('Something went wrong');
//                             }
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             } else {
//                               return Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   snapshot.data!.docs.length.toString(),
//                                   style: TextStyle(
//                                     color: constantColors.whiteColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                               );
//                             }
//                           })
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 Provider.of<Authentication>(context, listen: false)
//                     .getUserUid ==
//                     documentSnapshot['useruid']
//                     ? IconButton(
//                   onPressed: () {
//                     Provider.of<PostFunctions>(context, listen: false)
//                         .showPostOptions(context, documentSnapshot['caption']);
//                   },
//                   icon: Icon(EvaIcons.moreVertical,
//                       color: constantColors.whiteColor),
//                 )
//                     : const SizedBox(
//                   width: 0.0,
//                   height: 0.0,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
}
