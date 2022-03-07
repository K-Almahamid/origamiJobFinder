import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/screens/home/home_screen.dart';
import 'package:origami/screens/login/login_helper.dart';
import 'package:origami/screens/login/login_screen.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({Key? key}) : super(key: key);

  @override
  _VerificationEmailState createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  bool show = false;
String text='Check your email!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: xWhite,
        leading: GestureDetector(
          child: const Icon(IconBroken.Arrow___Left_Circle,
              color: xBlack, size: 30.0),
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                show != true ? send(context) : check(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  send(BuildContext context) => Column(
        children: [
          Center(
            child: Lottie.network(
                'https://assets7.lottiefiles.com/packages/lf20_lggoo6au.json',
                height: 200),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Verify your email address',
                style: kPageTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            subtitle: Text(
              'Please click the button below to confirm your email address and active your account.',
              style: kTitleStyle.copyWith(color: xGray, height: 1.3),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: xOrange,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MaterialButton(
                  elevation: 2.0,
                  child: Text('Send Request',
                      style: kTitleStyle.copyWith(color: xWhite)),
                  onPressed: () {
                    setState(() {
                      FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      show = !show;
                    });
                  },
                ),
              )),
        ],
      );

  check(BuildContext context) => Column(
        children: [
          Center(
            child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_xa9hbbrf.json',
                height: 200),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Check your email!',
                style: kPageTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            subtitle: Text(
              'We have sent you a verification email to your \nemail address.Click and follow the link inside it.',
              style: kTitleStyle.copyWith(color: xBlack, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: xOrange,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MaterialButton(
                  elevation: 2.0,
                  child: Text(
                      FirebaseAuth.instance.currentUser!.emailVerified?'Verified, go home':'Check your email!',
                      style: kTitleStyle.copyWith(color: xWhite)),
                  onPressed: () {
                    setState(() {
                      FirebaseAuth.instance.currentUser!.reload();
                      if(FirebaseAuth.instance.currentUser!.emailVerified){
                        // save in the shared prefs that user logged.
                        CacheHelper.putDataInSharedPreference(value: true, key: 'Logged');
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: HomeScreen(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      }
                      else {
                        Provider.of<LoginHelper>(context,listen: false).warningText(context, 'Check your email!');
                      }
                    });
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 105.0, bottom: 20),
            child: Stack(
              children: [
                Text(
                  'Did not receive the email? Check your spam filter,\n or try another email address.',
                  style: kSubtitleStyle.copyWith(height: 1.3, color: xGray),
                ),
                Positioned(
                    right: 35,
                    top: 3,
                    child: TextButton(
                      child: Text(
                        'Send Again',
                        textAlign: TextAlign.center,
                        style: kSubtitleStyle.copyWith(height: 1.3, color: xOrange),
                      ),
                      onPressed: () {

                      },
                    ))
              ],
            ),
          ),
        ],
      );
}
