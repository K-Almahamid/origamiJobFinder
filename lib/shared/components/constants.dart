import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origami/models/user.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const xBlack = Color(0xFF21202A);
const xBlackAccent = Color(0xFF312651);
const xGray = Color(0xFF83829A);
const xOrange = Color(0xFFFF4C29);
const xWhite = Color(0xFFE6E4E6);
const xSilver = Color(0xFFE6E4E6);
const xGreen = Color(0xFF4E9F3D);
const kMessageColor = Color(0xFFF9C4BA);
const xMessageColor = Color(0xFFFEF4EA);

var kPageTitleStyle = GoogleFonts.questrial(
  fontSize: 23.0,
  fontWeight: FontWeight.w500,
  color: xBlack,
  wordSpacing: 2.5,
);

var kTitleStyle = GoogleFonts.questrial(
  fontSize: 16.0,
  color: xBlack,
  fontWeight: FontWeight.w400,
);
var kSubtitleStyle = GoogleFonts.questrial(
  fontSize: 14.0,
  color: xBlack,
);

void storeData(context)  {

  User user = User(
    Provider.of<Authentication>(context, listen: false).getUserUid!,
    Provider.of<FireBaseOperations>(context, listen: false).initRole!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserName!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserEmail!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserImage!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserPhone!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserCV!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserBio!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserCountryLocation!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserGovernorateLocation!,
    Provider.of<FireBaseOperations>(context, listen: false).initUserAreaLocation!,
  );

  String userData = jsonEncode(user);
  print('this is stroe data = ${userData}');
  CacheHelper.putDataInSharedPreference(key: 'userdata', value: userData);
}