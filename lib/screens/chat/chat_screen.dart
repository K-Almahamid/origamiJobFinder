import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/chat/chat_room.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  // final user = User.data();
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //to name chatroom doc id
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  String? name, image, role, id, countryLocation;
//give initial value for status ... online
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
      User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
      name = user.username;
      id = user.useruid;
      image = user.userimage;
      role = user.role;
      countryLocation = user.usercountrylocation;

  }

  //update status
  void setStatus(String status) async {
    await _firestore.collection('users').doc(id).update({
      "status": status,
    });
  }

  //change status value
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("username", isGreaterThanOrEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        shadowColor: xOrange,
        title: Text('Chat', style: kPageTitleStyle),
        leading: const SizedBox(width: 0.0, height: 0.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top:20.0,bottom:20.0,left:20.0),
                    child: TextFormField(
                      style: kSubtitleStyle,
                      cursorColor: xOrange,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      decoration:  InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Search By Username',
                        hintStyle: kTitleStyle,
                        labelStyle: kTitleStyle,
                        prefixIcon: const Icon(IconBroken.Search,
                            color: xBlack),
                        border:  const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: xBlack,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: xBlack,
                          ),
                        ),
                      ),
                      textAlign: TextAlign.start,
                      controller: _search,
                      keyboardType: TextInputType.multiline,
                      onChanged:(val) {onSearch();},
                    ),
                  ),
                ),
                _search.text == ''
                    ? const Expanded(flex: 0, child:  SizedBox(width: 0.0, height: 0.0))
                    : GestureDetector(
                  child: const Icon(Icons.close, color: xBlack, size: 25),
                  onTap: () {
                    _search.text = '';
                  },
                ),
                const SizedBox(width: 20.0),
              ],
            ),
            isLoading
                ? Center(
              child: SizedBox(
                  height: size.height /3,
                  width: size.height /3,
                  child:Lottie.asset('assets/animations/loading.json')
              ),
            )
                : Column(
              children: [
                SizedBox(
                    height: size.height / 30
                ),
                userMap != null
                    ? ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(userMap!['userimage']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    userMap!['username'],
                    style: kTitleStyle,
                  ),
                  subtitle: Text(
                    userMap!['status'],
                    style: kSubtitleStyle.copyWith(
                        color: userMap!['status'] == 'Online'
                            ? xGreen
                            : xOrange),
                  ),
                  trailing:
                  const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(IconBroken.Chat, color: Colors.black),
                  ),
                  onTap: () {
                    String roomId = chatRoomId(
                        name!,
                        userMap!['username']);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: userMap!,
                          username:name!,
                        ),
                      ),
                    );
                  },
                )
                    : Container(),
              ],
            ),
          ],
        ),
      )
    );
  }
}
