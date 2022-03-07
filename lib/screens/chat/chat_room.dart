import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/alt_profile/alt_profile_screen.dart';
import 'package:origami/screens/profile/profile_screen.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final String username;

  ChatRoom({
    required this.chatRoomId,
    required this.userMap,
    required this.username,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": widget.username,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    //check if it is empty
    if (_message.text.isNotEmpty) {
      //message data
      Map<String, dynamic> messages = {
        "sendby": widget.username,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };
      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  String? name, image, role, id, countryLocation;

  @override
  void initState() {
    super.initState();
    User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    name = user.username;
    id = user.useruid;
    image = user.userimage;
    role = user.role;
    countryLocation = user.usercountrylocation;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        backgroundColor: xSilver,
        elevation: 3.0,
        shadowColor: xOrange,
        leadingWidth: 50,
        leading: GestureDetector(
          child: const Icon(
            IconBroken.Arrow___Left_Circle,
            color: xBlack,
            size: 25,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection("users")
              .doc(widget.userMap['useruid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Row(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: NetworkImage(widget.userMap['userimage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: (){
                      if (widget.userMap['useruid'] !=
                         id) {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AltProfileScreen(
                              userUid: widget.userMap['useruid'],
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
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userMap['username'],
                          style: kTitleStyle.copyWith(fontSize: 18)),
                      const SizedBox(height: 5.0),
                      Text(
                        snapshot.data!['status'],
                        style: kSubtitleStyle.copyWith(
                            color: snapshot.data!['status'] == 'Online'
                                ? xGreen
                                : xOrange),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.3,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 7,
              width: size.width,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: size.height / 13.8,
                width: size.width / 1.0,
                child: Column(
                  children: [
                    Container(height: 1.2, color: xOrange),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height / 20,
                          width: size.width / 1.4,
                          child: TextField(
                            controller: _message,
                            style: kSubtitleStyle.copyWith(
                                wordSpacing: 1.0, fontSize: 18),
                            cursorColor: xOrange,
                            maxLines: null,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(400)
                            ],
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: "Type something..",
                              hintStyle: kTitleStyle.copyWith(color: xGray),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => getImage(),
                          icon: const Icon(IconBroken.Image_2,
                              color: xBlack),
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: xBlack,
                            ),
                            onPressed: onSendMessage),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {

    bool isMe = map['sendby'] ==name ? true
        : false;

    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                    color: isMe
                        ? kMessageColor
                        : xMessageColor,
                  ),
                  child: Text(
                    map['message'],
                    style: kTitleStyle.copyWith(color: xBlack),
                  ),
                ),
                Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: isMe
                        ? const EdgeInsets.only(right: 8.0)
                        : const EdgeInsets.only(left: 8.0),
                    child: Text(
                      formattedDate(map['time']),
                      style:
                      kSubtitleStyle.copyWith(color: xGray, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: size.height / 3.5,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 3.5,
                width: size.width / 2.2,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(2.2),
                decoration: BoxDecoration(
                  color: isMe ? kMessageColor : xMessageColor,
                  borderRadius: isMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                ),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: map['message'] != ""
                      ? Image.network(
                          map['message'],
                          fit: BoxFit.fill,
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: xBlack,
      appBar: AppBar(
        backgroundColor: xBlack,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(IconBroken.Close_Square,size: 35,color: xWhite),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          height: size.height * 0.6,
          width: size.width,
          color: Colors.black,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

//
