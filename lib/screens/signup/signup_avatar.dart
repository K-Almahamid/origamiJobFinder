import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:origami/screens/home/home_screen.dart';
import 'package:origami/screens/signup/signup_cv.dart';
import 'package:origami/screens/signup/signup_helper.dart';
import 'package:origami/screens/signup/signup_utils.dart';
import 'package:origami/screens/signup/verification_email.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignUpAvatar extends StatefulWidget {
  @override
  _SignUpAvatarState createState() => _SignUpAvatarState();
}

class _SignUpAvatarState extends State<SignUpAvatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.shade100,
        leadingWidth: double.infinity,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 15.0),
          child: Text(
            'Origami',
            style: TextStyle(
              color: xOrange,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ephesis-Regular',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Adding a photo helps people recognize you',
                style: kPageTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey.shade300,
                    child: Provider.of<SignUpUtils>(context, listen: true)
                                .userAvatar ==
                            null
                        ? const Icon(
                            IconBroken.Profile,
                            size: 45.0,
                            color: xBlack,
                          )
                        : CircleAvatar(
                            radius: 65,
                            backgroundColor: xWhite,
                            backgroundImage: FileImage(
                              Provider.of<SignUpUtils>(context, listen: false)
                                  .userAvatar!,
                            ),
                          ),
                  ),
                  Positioned(
                    left: 80.0,
                    top: 90,
                    child: GestureDetector(
                      child: const CircleAvatar(
                        radius: 20.0,
                        backgroundColor: xSilver,
                        child: Icon(
                          IconBroken.Camera,
                          color: xOrange,
                          size: 35.0,
                        ),
                      ),
                      onTap: () {
                        Provider.of<SignUpUtils>(context, listen: false)
                            .selectAvatarOptions(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90.0),
            Provider.of<SignUpUtils>(context, listen: true).userAvatar != null
                ? Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: xOrange, // background
                              onPrimary: xWhite, // foreground
                            ),
                            child: Text('Back',
                                style: kSubtitleStyle.copyWith(color: xWhite)),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: SignUpCV(),
                                  type: PageTransitionType.rightToLeft,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: xOrange, // background
                              onPrimary: xWhite, // foreground
                            ),
                            child: Text('Confirm',
                                style: kSubtitleStyle.copyWith(color: xWhite)),
                            onPressed: () {
                              if (Provider.of<SignUpUtils>(context,
                                          listen: false)
                                      .userAvatar !=
                                  null) {
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .createAccount(
                                  Provider.of<SignUpHelper>(context,
                                          listen: false)
                                      .signUpEmailController
                                      .text,
                                  Provider.of<SignUpHelper>(context,
                                          listen: false)
                                      .signUpPasswordController
                                      .text,
                                )
                                    .whenComplete(
                                  () {
                                    print(
                                        'Creating Collection in signup avatar');
                                    Provider.of<FireBaseOperations>(context,
                                            listen: false)
                                        .createUserCollection(
                                      context,
                                      {
                                        'useruid': Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserUid,
                                        'role': Provider.of<SignUpHelper>(
                                                context,
                                                listen: false)
                                            .checkRole,
                                        'username': Provider.of<SignUpHelper>(
                                                context,
                                                listen: false)
                                            .signUpNameController
                                            .text,
                                        'useremail': Provider.of<SignUpHelper>(
                                                context,
                                                listen: false)
                                            .signUpEmailController
                                            .text,
                                        'userphone': Provider.of<SignUpHelper>(
                                                context,
                                                listen: false)
                                            .signUpPhoneController
                                            .text,
                                        'userbio': Provider.of<SignUpHelper>(
                                                context,
                                                listen: false)
                                            .signUpBioController
                                            .text,
                                        'usercountrylocation':
                                            Provider.of<SignUpHelper>(context,
                                                    listen: false)
                                                .country,
                                        'usergovernoratelocation':
                                            Provider.of<SignUpHelper>(context,
                                                    listen: false)
                                                .governorate,
                                        'userarealocation':
                                            Provider.of<SignUpHelper>(context,
                                                    listen: false)
                                                .area,
                                        'userimage': Provider.of<SignUpUtils>(
                                                context,
                                                listen: false)
                                            .getUserAvatarUrl,
                                        'usercv': Provider.of<SignUpHelper>(
                                                        context,
                                                        listen: false)
                                                    .checkRole ==
                                                'company'
                                            ? ''
                                            : Provider.of<FireBaseOperations>(
                                                    context,
                                                    listen: false)
                                                .urlDownload,
                                      },
                                    );
                                  },
                                ).whenComplete(
                                  () {
                                    Provider.of<FireBaseOperations>(context,
                                            listen: false)
                                        .initUserData(context)
                                        .whenComplete(
                                      () {
                                        if (Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid !=
                                            null) {
                                          if (FirebaseAuth.instance.currentUser!
                                              .emailVerified) {
                                            // save in the shared prefs that user logged.
                                            CacheHelper
                                                    .putDataInSharedPreference(
                                                        value: true,
                                                        key: 'Logged')
                                                .whenComplete(() {
                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  child: HomeScreen(),
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                ),
                                              );
                                            });
                                          } else if (FirebaseAuth.instance
                                                  .currentUser!.emailVerified ==
                                              false) {
                                            Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                child:
                                                    const VerificationEmail(),
                                                type: PageTransitionType
                                                    .bottomToTop,
                                              ),
                                            );
                                          }

                                          // .whenComplete(() {
                                          //   Provider.of<FireBaseOperations>(context, listen: false)
                                          //       .initUserData(context);
                                          // });
                                        }
                                      },
                                    );
                                  },
                                );
                              } else {
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .warningText(
                                        context, 'Fill all the data !');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
