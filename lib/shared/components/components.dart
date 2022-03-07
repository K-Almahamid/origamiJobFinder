
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:provider/provider.dart';

Widget divider() => const Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Divider(color: xOrange, thickness: 1.4, endIndent: 10),
    );

String formattedDate(timeStamp) {
  var dateFromTimeStamp =
      DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('hh:mm a').format(dateFromTimeStamp);
}
warningText(BuildContext context, warning) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            color: xSilver,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft:Radius.circular(15.0) ,
            ),
          ),
          child: Center(
            child: Text(warning!, style: kTitleStyle),
          ),
        ),
      );
    },
  );
}

postOptions(BuildContext context,String email,String about) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            color: xSilver,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  color: xBlack,
                  width: 80.0,
                  height: 2.0,
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  IconBroken.Edit,
                  color: xOrange,
                  size: 18,
                ),
                label: Text(
                  'Edit Post',
                  style: kTitleStyle,
                ),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(
                  IconBroken.Delete,
                  color: xOrange,
                  size: 18,
                ),
                label: Text(
                  'Delete',
                  style: kTitleStyle,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  deletePostDialog(context,about,email);
                },
              ),
            ],
          ),
        );
      });
}

postOptionsFav(BuildContext context,String email,String about) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            color: xSilver,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  color: xBlack,
                  width: 80.0,
                  height: 2.0,
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  IconBroken.Bookmark,
                  color: xOrange,
                  size: 18,
                ),
                label: Text(
                  'Remove From Favorites',
                  style: kTitleStyle,
                ),
                onPressed: () {
                  Provider.of<FireBaseOperations>(context,listen: false).deleteFromFavorites(email,about);
                  Navigator.pop(context);
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  IconBroken.Edit,
                  color: xOrange,
                  size: 18,
                ),
                label: Text(
                  'Edit Post',
                  style: kTitleStyle,
                ),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(
                  IconBroken.Delete,
                  color: xOrange,
                  size: 18,
                ),
                label: Text(
                  'Delete',
                  style: kTitleStyle,
                ),
                onPressed: () {

                },
              ),
            ],
          ),
        );
      });
}

deletePostDialog(BuildContext context,String about,email) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade100,
        title: Center(
            child: Column(
              children: [
                Text('Delete Post ?', style: kPageTitleStyle),
              ],
            )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  onSurface: Colors.orangeAccent,
                  side: const BorderSide(
                    color: xGray,
                  ),
                  elevation: 55,
                ),
                label: Text(
                  'Cancel',
                  style: kTitleStyle,
                  textAlign: TextAlign.center,
                ),
                icon: const Icon(
                  IconBroken.Close_Square,
                  color: xGray,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: xOrange,
                  primary: Colors.white,
                  onSurface: Colors.orangeAccent,
                  side: const BorderSide(
                    color: xOrange,
                  ),
                  elevation: 55,
                ),
                label: Text(
                  'Yes',
                  style: kTitleStyle.copyWith(color: xWhite),
                  textAlign: TextAlign.center,
                ),
                icon: const Icon(
                  IconBroken.Logout,
                  color: xWhite,
                  size: 20,
                ),
                onPressed: () {
                  Provider.of<FireBaseOperations>(context,listen: false).deletePost(email,about);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
