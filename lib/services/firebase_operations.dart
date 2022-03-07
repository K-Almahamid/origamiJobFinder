import 'dart:io';
import 'dart:typed_data';
import 'package:origami/models/user.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:origami/screens/signup/signup_utils.dart';
import 'package:origami/services/authentication.dart';
import 'package:provider/provider.dart';

class FireBaseOperations with ChangeNotifier {
  Future uploadUserAvatar(BuildContext context) async {
    UploadTask? imageUploadTask;
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<SignUpUtils>(context, listen: false).getUserAvatar!.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<SignUpUtils>(context, listen: false).getUserAvatar!);

    await imageUploadTask.whenComplete(() {
      print('Image Uploaded!');
    });

    imageReference.getDownloadURL().then((url) {
      Provider.of<SignUpUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'The User Avatar Url => ${Provider.of<SignUpUtils>(context, listen: false).userAvatarUrl}');
      notifyListeners();
    });
  }

  //--------------------------------------------------------------------------------

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
    //  .whenComplete(() {
    //   CacheHelper.putDataInSharedPreference(value: initUserName, key: 'username');
    //   CacheHelper.putDataInSharedPreference(value: initUserEmail, key: 'useremail');
    //   CacheHelper.putDataInSharedPreference(value: initUserImage, key: 'userimage');
    //   CacheHelper.putDataInSharedPreference(value: initUserPhone, key: 'userphone');
    //   CacheHelper.putDataInSharedPreference(value: initUserCountryLocation, key: 'usercountrylocation');
    //   CacheHelper.putDataInSharedPreference(value: initUserGovernorateLocation, key: 'usergovernoratelocation');
    //   CacheHelper.putDataInSharedPreference(value: initUserAreaLocation, key: 'userarealocation');
    //   CacheHelper.putDataInSharedPreference(value: initUserCV, key: 'usercv');
    // })
  }

  //--------------------------------------------------------------------------------
  String? initRole;
  String? initUserName;
  String? initUserEmail;
  String? initUserImage;
  String? initUserPhone;
  String? initUserCountryLocation;
  String? initUserGovernorateLocation;
  String? initUserAreaLocation;
  String? initUserCV;
  String? initUserBio;

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching User Data');
      initRole = doc['role'];
      initUserName = doc['username'];
      initUserEmail = doc['useremail'];
      initUserImage = doc['userimage'];
      initUserPhone = doc['userphone'];
      initUserCountryLocation = doc['usercountrylocation'];
      initUserGovernorateLocation = doc['usergovernoratelocation'];
      initUserAreaLocation = doc['userarealocation'];
      initUserCV = doc['usercv'];
      initUserBio = doc['userbio'];

      print(initRole);
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      print(initUserPhone);
      print(initUserCountryLocation);
      print(initUserGovernorateLocation);
      print(initUserAreaLocation);
      print(initUserCV);
      print(initUserBio);
      notifyListeners();
    });
  }

  saveData(BuildContext context) {
    try {
      // final user = User.data();
      // user.username= initUserName;
      // user.role=initRole;
      // user.useremail=initUserEmail;
      // user.userphone=initUserPhone;
      // user.usercountrylocation=initUserCountryLocation;
      // user.usergovernoratelocation=initUserGovernorateLocation;
      // user.userarealocation=initUserAreaLocation;
      // user.usercv=initUserCV ?? '';
      // user.userbio=initUserBio;
      //
      // CacheHelper.putDataInSharedPreference(value: Provider
      //     .of<Authentication>(context, listen: false)
      //     .getUserUid, key: 'useruid');
      // CacheHelper.putDataInSharedPreference(
      //     value: user.username, key: 'username');
      // CacheHelper.putDataInSharedPreference(
      //     value: user.role, key: 'role');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserEmail, key: 'useremail');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserImage, key: 'userimage');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserPhone, key: 'userphone');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserCountryLocation, key: 'usercountrylocation');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserGovernorateLocation, key: 'usergovernoratelocation');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserAreaLocation, key: 'userarealocation');
      // CacheHelper.putDataInSharedPreference(value: initUserCV, key: 'usercv');
      // CacheHelper.putDataInSharedPreference(
      //     value: initUserBio, key: 'userbio');
      CacheHelper.putDataInSharedPreference(
          value: initUserName, key: 'username');
      CacheHelper.putDataInSharedPreference(
          value: Provider.of<Authentication>(context, listen: false).getUserUid,
          key: 'useruid');
      CacheHelper.putDataInSharedPreference(
          value: initUserEmail, key: 'useremail');
      CacheHelper.putDataInSharedPreference(
          value: initUserImage, key: 'userimage');
      CacheHelper.putDataInSharedPreference(
          value: initUserPhone, key: 'userphone');
      CacheHelper.putDataInSharedPreference(
          value: initUserCountryLocation, key: 'usercountrylocation');
      CacheHelper.putDataInSharedPreference(
          value: initUserGovernorateLocation, key: 'usergovernoratelocation');
      CacheHelper.putDataInSharedPreference(
          value: initUserAreaLocation, key: 'userarealocation');
      CacheHelper.putDataInSharedPreference(value: initUserCV, key: 'usercv');
      CacheHelper.putDataInSharedPreference(value: initUserBio, key: 'userbio');
      CacheHelper.putDataInSharedPreference(value: initRole, key: 'role');
      print(
          'user save data ${CacheHelper.getDataFromSharedPreference(key: 'username')}');
      notifyListeners();
    } catch (e) {
      print('this error in catch firebase operation ${e.toString()}');
    }
  }

  //--------------------------------------------------------------------------------

  Future searchQuery(String queryString) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('about', isGreaterThanOrEqualTo: queryString)
        .get();
  }

  //--------------------------------------------------------------------------------

  Future followUser(
    String followingUid,
    String followingDocId,
    dynamic followingData,
    String followerUid,
    String followerDocId,
    dynamic followerData,
  ) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  //--------------------------------------------------------------------------------

  Future updateUserData(String userId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(data);
  }

//--------------------------------------------------------------------------------

  Future deleteUserData(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  //--------------------------------------------------------------------------------

  Future deleteFromFavorites(String email,String about) async {
    final doc = FirebaseFirestore.instance
        .collection('users-favorite-jobs')
        .doc(email)
        .collection('jobs')
        .doc(about);
    return await doc.delete();
  }

  //--------------------------------------------------------------------------------

  Future deletePost(String email,String about) async {
    final doc = FirebaseFirestore.instance
        .collection('posts')
        .doc(about);
    deleteFromFavorites(email, about);
    return await doc.delete();
  }

//--------------------------------------------------------------------------------

  Future applyForJob(String userId, String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('apply')
        .add(data);
  }

  //--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  //--------------------------------------------------------------------------------

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

//--------------------------------------------------------------------------------

  Future deletePostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  //--------------------------------------------------------------------------------

  UploadTask? task;
  late final String urlDownload;

  Future uploadCVFile(File file) async {
    if (file == null) return;
    final fileName = basename(file.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, file);
    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
    notifyListeners();
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
