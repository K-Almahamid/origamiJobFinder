import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:origami/screens/login/login_helper.dart';
import 'package:origami/screens/signup/signup_helper.dart';
import 'package:origami/screens/signup/signup_info.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Check extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign up as', style: kPageTitleStyle.copyWith(color: xBlack)),
            const SizedBox(height: 40),
            Stack(
              children: [
                Center(
                  child: UnDraw(
                    illustration: UnDrawIllustration.choice,
                    color: xOrange,
                    height: 250,
                    placeholder: const Text("Illustration is loading..."),
                    //optional, default is the CircularProgressIndicator().
                    errorWidget: const Icon(Icons.error_outline,
                        color: Colors.red, size: 50),
                  ),
                ),
                Positioned(
                    left: 205,
                    top: 45,
                    child: Text(
                      'Company',
                      style: kSubtitleStyle.copyWith(color: xBlack),
                    )),
                Positioned(
                    left: 60,
                    top: 75,
                    child: Text(
                      'User',
                      style: kTitleStyle.copyWith(color: xWhite),
                    )),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: xOrange,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: MaterialButton(
                elevation: 2.0,
                child:
                    Text('Company', style: kTitleStyle.copyWith(color: xWhite)),
                onPressed: () {
                  Provider.of<SignUpHelper>(context, listen: false).checkRole ='company';
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: SignUpInfo(),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: xOrange,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: MaterialButton(
                elevation: 2.0,
                child: Text('User', style: kTitleStyle.copyWith(color: xWhite)),
                onPressed: () {
                  Provider.of<SignUpHelper>(context, listen: false).checkRole = 'user';
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: SignUpInfo(),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
