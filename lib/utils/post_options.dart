import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostOptions with ChangeNotifier {
  String? timePosted;

  String? get getTimePosted => timePosted;

  showTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    timePosted = timeago.format(dateTime);
    print(timePosted);
    // notifyListeners();
  }
}