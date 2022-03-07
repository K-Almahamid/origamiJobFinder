import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:origami/screens/signup/signup_avatar.dart';
import 'package:origami/screens/signup/signup_helper.dart';
import 'package:origami/screens/signup/signup_info.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignUpCV extends StatefulWidget {
  @override
  State<SignUpCV> createState() => _SignUpCVState();
}

class _SignUpCVState extends State<SignUpCV> {
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
        padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        'Upload your CV file',
                        style: kPageTitleStyle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'File should be jpg, png, jpeg, pdf, doc',
                        style: kTitleStyle.copyWith(color: xGray),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: Provider.of<SignUpHelper>(context, listen: true)
                            .selectFile,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: Colors.red.shade400,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade50.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    IconBroken.Folder,
                                    color: xOrange,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Select your file',
                                    style:
                                        kSubtitleStyle.copyWith(color: xGray),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Provider.of<SignUpHelper>(context, listen: false)
                                  .platformFile !=
                              null
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected File',
                                    style:
                                        kSubtitleStyle.copyWith(color: xGray),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: const Offset(0, 1),
                                          blurRadius: 3,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Provider.of<SignUpHelper>(
                                                              context,
                                                              listen: false)
                                                          .platformFile!
                                                          .extension ==
                                                      'pdf' ||
                                                  Provider.of<SignUpHelper>(
                                                              context,
                                                              listen: false)
                                                          .platformFile!
                                                          .extension ==
                                                      'doc'
                                              ? const Icon(Icons.description)
                                              : Image.file(
                                                  Provider.of<SignUpHelper>(
                                                          context,
                                                          listen: false)
                                                      .file!,
                                                  width: 70,
                                                ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Provider.of<SignUpHelper>(
                                                        context,
                                                        listen: false)
                                                    .platformFile!
                                                    .name,
                                                style: kSubtitleStyle.copyWith(
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                '${(Provider.of<SignUpHelper>(context, listen: false).platformFile!.size / 1024).ceil()} KB',
                                                style: kSubtitleStyle.copyWith(
                                                    color:
                                                        xGray.withOpacity(0.7)),
                                              ),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 50.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: xOrange,
                                              // background
                                              onPrimary: xWhite, // foreground
                                            ),
                                            child: Text(
                                              'Back',
                                              style: kSubtitleStyle.copyWith(
                                                  color: xWhite),
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  child: SignUpInfo(),
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: xOrange,
                                              // background
                                              onPrimary: xWhite, // foreground
                                            ),
                                            child: Text('Next',
                                                style: kSubtitleStyle.copyWith(
                                                    color: xWhite)),
                                            onPressed: () {
                                              Provider.of<FireBaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .uploadCVFile(
                                                      Provider.of<SignUpHelper>(
                                                              context,
                                                              listen: false)
                                                          .file!)
                                                  .whenComplete(() {
                                                Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                    child: SignUpAvatar(),
                                                    type: PageTransitionType
                                                        .leftToRight,
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 20),
                                  // MaterialButton(
                                  //   minWidth: double.infinity,
                                  //   height: 45,
                                  //   color: Colors.black,
                                  //   child: const Text(
                                  //     'Upload',
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  //   onPressed: () {
                                  //     Provider.of<FireBaseOperations>(context,
                                  //             listen: false)
                                  //         .uploadCVFile(Provider.of<SignUpHelper>(
                                  //                 context,
                                  //                 listen: false)
                                  //             .file!);
                                  //   },
                                  // ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
