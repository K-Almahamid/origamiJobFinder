import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:provider/provider.dart';

class SignUpUtils with ChangeNotifier {
  final picker = ImagePicker();
  File? userAvatar;

  File? get getUserAvatar => userAvatar;

  String? userAvatarUrl;

  String? get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null
        ? print("Select Image")
        : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar!.path);

    // userAvatar != null
    //     ? Provider.of<SignUpHelper>(context, listen: false)
    //         .showUserAvatar(context)
    //     : print('Image Upload Error');

    notifyListeners();
  }

  Future selectAvatarOptions(BuildContext context) async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  color: xBlack,
                  height: 5.0,
                  width: 60.0,
                ),
              ),
              const SizedBox(height: 30.0),
              TextButton(
                child: const Text(
                  'Take a photo',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: xBlack,
                  ),
                ),
                onPressed: () {
                  pickUserAvatar(context, ImageSource.camera).whenComplete(
                    () {
                      Provider.of<FireBaseOperations>(context, listen: false)
                          .uploadUserAvatar(context);
                    },
                  );
                },
              ),
              TextButton(
                child: const Text(
                  'Choose a photo from the gallery',
                  style: TextStyle(
                    color: xBlack,
                  ),
                ),
                onPressed: () {
                  pickUserAvatar(context, ImageSource.gallery).whenComplete(
                    () {
                      Provider.of<FireBaseOperations>(context, listen: false)
                          .uploadUserAvatar(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
