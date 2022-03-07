import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:origami/screens/home/home_screen.dart';
import 'package:origami/screens/login/forget_password_screen.dart';
import 'package:origami/screens/signup/check.dart';
import 'package:origami/screens/signup/verification_email.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoginHelper with ChangeNotifier {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool passwordObscure = true;

  loginForm(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Row(
              children: const [
                Text(
                  'Origami',
                  style: TextStyle(
                    color: xOrange,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ephesis-Regular',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            'Login now to find your dream job.',
            style: kTitleStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 35.0),
          TextFormField(
            controller: loginEmailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: xOrange,
            style: kTitleStyle,
            // autofillHints: const [AutofillHints.email],
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
          const SizedBox(height: 15.0),
          TextFormField(
            controller: loginPasswordController,
            keyboardType: TextInputType.visiblePassword,
            style: kTitleStyle,
            cursorColor: xOrange,
            obscureText: passwordObscure,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Enter Password",
              labelStyle: kTitleStyle,
              prefixIcon: const Icon(IconBroken.Lock, color: xBlack),
              suffixIcon: GestureDetector(
                onTap: () {
                  passwordObscure = !passwordObscure;
                  notifyListeners();
                },
                child: Icon(
                  passwordObscure
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: xBlack,
                  size: 20,
                ),
              ),
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
                LengthRangeValidator(
                  min: 7,
                  max: 20,
                  errorText: 'must be more then 6 and less than 20',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Forget your password?',
                    style: kTitleStyle.copyWith(color: xOrange)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const forgetPasswordScreen(),
                  type: PageTransitionType.bottomToTop,
                ),
              );
            },
          ),
          const SizedBox(height: 25.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: xOrange,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: MaterialButton(
              child: Text(
                'LOGIN',
                style: kSubtitleStyle.copyWith(color: xWhite),
              ),
              onPressed: () {
                if (loginFormKey.currentState!.validate()) {
                  Provider.of<Authentication>(context, listen: false)
                      .loginToAccount(
                    context,
                    loginEmailController.text,
                    loginPasswordController.text,
                  )
                      .catchError(
                    (e) {
                      warningText(context, 'Something went wrong email or password incorrect');
                      // loginToast(
                      //     context,
                      //     'Something went wrong email or password incorrect',
                      //     IconBroken.Danger,
                      //     xOrange,
                      //     xOrange,
                      //     false);
                    },
                  ).whenComplete(
                    () {
                      Provider.of<FireBaseOperations>(context, listen: false)
                          .initUserData(context);
                    },
                  ).whenComplete(() {
                    if (Provider.of<Authentication>(context, listen: false)
                            .getUserUid !=
                        null) {
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        // save in the shared prefs that user logged.
                        CacheHelper.putDataInSharedPreference(
                                value: true, key: 'Logged')
                            .whenComplete(() {
                              storeData(context);
                          notifyListeners();
                        }).whenComplete(
                          () {
                            storeData(context);
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: HomeScreen(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                        );
                      } else if (FirebaseAuth
                              .instance.currentUser!.emailVerified ==
                          false) {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: const VerificationEmail(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      }
                    }
                  });
                }
                notifyListeners();
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 30.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: 50.0,
          //         height: 2.0,
          //         color: xGray,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //         child: Text('Or continue with', style: kTitleStyle),
          //       ),
          //       Container(
          //         width: 50.0,
          //         height: 2.0,
          //         color: xGray,
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 30.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       GestureDetector(
          //         onTap: () {},
          //         child: Container(
          //           child: const Icon(
          //             FontAwesomeIcons.google,
          //             color: xOrange,
          //           ),
          //           width: 60.0,
          //           height: 40.0,
          //           decoration: BoxDecoration(
          //             border: Border.all(color: xOrange),
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 25.0),
          //         child: GestureDetector(
          //           child: Container(
          //             child: const Icon(
          //               FontAwesomeIcons.facebook,
          //               color: xBlackAccent,
          //             ),
          //             width: 60.0,
          //             height: 40.0,
          //             decoration: BoxDecoration(
          //               border: Border.all(color: xBlackAccent),
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?', style: kSubtitleStyle),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: Check(),
                        type: PageTransitionType.leftToRight,
                      ),
                    );
                  },
                  child: Text(
                    'Sign up',
                    style: kSubtitleStyle.copyWith(color: xOrange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  saveData(BuildContext context) {
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserName,
        key: 'username');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<Authentication>(context, listen: false).getUserUid,
        key: 'useruid');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserEmail,
        key: 'useremail');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserImage,
        key: 'userimage');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserPhone,
        key: 'userphone');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserCountryLocation,
        key: 'usercountrylocation');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserGovernorateLocation,
        key: 'usergovernoratelocation');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false)
            .initUserAreaLocation,
        key: 'userarealocation');
    CacheHelper.putDataInSharedPreference(
        value:
            Provider.of<FireBaseOperations>(context, listen: false).initUserCV,
        key: 'usercv');
    CacheHelper.putDataInSharedPreference(
        value:
            Provider.of<FireBaseOperations>(context, listen: false).initUserBio,
        key: 'userbio');
    CacheHelper.putDataInSharedPreference(
        value: Provider.of<FireBaseOperations>(context, listen: false).initRole,
        key: 'role');
  }
}
