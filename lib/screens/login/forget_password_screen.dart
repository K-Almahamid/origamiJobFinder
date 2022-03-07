import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';

class forgetPasswordScreen extends StatefulWidget {
  const forgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _forgetPasswordScreenState createState() => _forgetPasswordScreenState();
}

class _forgetPasswordScreenState extends State<forgetPasswordScreen> {
  TextEditingController forgetPasswordController = TextEditingController();
  GlobalKey<FormState> resSetFormKey = GlobalKey<FormState>();
  bool show = false;

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
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                show != true ? send(context) : check(context),
              ],
            )),
      ),
    );
  }

  send(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: UnDraw(
              illustration: UnDrawIllustration.forgot_password,
              color: xOrange,
              height: 160,
              placeholder: const Text("Illustration is loading..."),
              //optional, default is the CircularProgressIndicator().
              errorWidget:
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
            ),
          ),
          const SizedBox(height: 10),
          Text('Reset Password', style: kPageTitleStyle),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 25),
            child: Text(
              'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
              style: kTitleStyle.copyWith(height: 1.3),
            ),
          ),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: resSetFormKey,
            child: TextFormField(
              controller: forgetPasswordController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: xOrange,
              style: kTitleStyle,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Enter Email",
                labelStyle: kTitleStyle,
                prefixIcon: const Icon(IconBroken.Message, color: xBlack),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: xBlack,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: xBlack,
                  ),
                ),
              ),
              validator: MultiValidator(
                [
                  RequiredValidator(errorText: 'Required'),
                  EmailValidator(errorText: 'Not A Valid Email'),
                ],
              ),
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
                    if (resSetFormKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: forgetPasswordController.text)
                          .whenComplete(() {
                        setState(() {
                          show = !show;
                        });
                      });
                    }
                  },
                ),
              )),
        ],
      );

  check(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 100,
                child: Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_xa9hbbrf.json'),
              ),
            ),
            const SizedBox(height: 20),
            Text('Check your mail', style: kPageTitleStyle),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 25),
              child: Text(
                'We have sent a password recover \n instructions to your email.',
                textAlign: TextAlign.center,
                style: kTitleStyle.copyWith(height: 1.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 220.0, bottom: 25),
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
                      FirebaseAuth.instance.sendPasswordResetEmail(email: forgetPasswordController.text);
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      );
}
