
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:origami/screens/signup/signup_avatar.dart';
import 'package:origami/screens/signup/signup_cv.dart';
import 'package:origami/screens/signup/signup_helper.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignUpInfo extends StatefulWidget {
  @override
  State<SignUpInfo> createState() => _SignUpInfoState();
}

class _SignUpInfoState extends State<SignUpInfo> {

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  bool signUpPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    Provider.of<SignUpHelper>(context, listen: false)
        .signUpLocationController
        .text = Provider.of<SignUpHelper>(context, listen: false).finalAddress;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller:
                          Provider.of<SignUpHelper>(context, listen: false)
                              .signUpNameController,
                      keyboardType: TextInputType.name,
                      cursorColor: xOrange,
                      style: kTitleStyle,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Name",
                        labelStyle: kTitleStyle,
                        prefixIcon:
                            const Icon(IconBroken.Profile, color: xBlack),
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
                            min: 6,
                            max: 25,
                            errorText:
                                'must be more then 6 and less than 25 characters',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller:
                          Provider.of<SignUpHelper>(context, listen: false)
                              .signUpEmailController,
                      style: kTitleStyle,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: xOrange,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Email",
                        labelStyle: kTitleStyle,
                        prefixIcon:
                            const Icon(IconBroken.Message, color: xBlack),
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
                      controller:
                          Provider.of<SignUpHelper>(context, listen: false)
                              .signUpPhoneController,
                      style: kTitleStyle,
                      keyboardType: TextInputType.phone,
                      cursorColor: xOrange,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Phone",
                        labelStyle: kTitleStyle,
                        prefixIcon: const Icon(IconBroken.Call, color: xBlack),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller:
                          Provider.of<SignUpHelper>(context, listen: false)
                              .signUpPasswordController,
                      style: kTitleStyle,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: xOrange,
                      obscureText: signUpPasswordObscure,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        labelStyle: kTitleStyle,
                        prefixIcon: const Icon(IconBroken.Lock, color: xBlack),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              signUpPasswordObscure = !signUpPasswordObscure;
                            });
                          },
                          child: Icon(
                            signUpPasswordObscure
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            color: xBlack,
                            size: 20,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: xOrange,
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
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            readOnly: true,
                            controller: Provider.of<SignUpHelper>(context,
                                    listen: false)
                                .signUpLocationController,
                            style: kTitleStyle,
                            keyboardType: TextInputType.streetAddress,
                            cursorColor: xOrange,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Location',
                              hintText: Provider.of<SignUpHelper>(context,
                                      listen: false)
                                  .signUpLocationController
                                  .text,
                              labelStyle: kTitleStyle,
                              prefixIcon: const Icon(IconBroken.Location,
                                  color: xBlack),
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            color: xOrange,
                            height: MediaQuery.of(context).size.height * 0.08,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              // side: BorderSide(color: Colors.black)
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Text('Get Location',
                                textAlign: TextAlign.center,
                                style: kSubtitleStyle.copyWith(color: xWhite)),
                            onPressed: () {
                              setState(() {
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .getUserCurrentLocation();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: kSubtitleStyle.copyWith(
                          height: 1.5),
                      cursorColor: xOrange,
                      inputFormatters: [LengthLimitingTextInputFormatter(400)],
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        labelText: 'Bio..',
                        labelStyle: kTitleStyle,
                        prefixIcon:
                            const Icon(IconBroken.Info_Circle, color: xBlack),
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
                      textAlign: TextAlign.start,
                      controller:
                          Provider.of<SignUpHelper>(context, listen: false)
                              .signUpBioController,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: xOrange, // background
                                onPrimary: xWhite, // foreground
                              ),
                              child: Text(
                                'Cancel',
                                style: kSubtitleStyle.copyWith(color: xWhite),
                              ),
                              onPressed: () {
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .signUpNameController
                                    .text = '';
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .signUpEmailController
                                    .text = '';
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .signUpPhoneController
                                    .text = '';
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .signUpPasswordController
                                    .text = '';
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .signUpLocationController
                                    .text = '';
                                Provider.of<SignUpHelper>(context,
                                        listen: false)
                                    .signUpBioController
                                    .text = '';
                                Navigator.pop(context);
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
                              child: Text('Next',
                                  style:
                                      kSubtitleStyle.copyWith(color: xWhite)),
                              onPressed: () {
                                if (signUpFormKey.currentState!.validate()) {
                                  if(
                                  Provider.of<SignUpHelper>(context, listen: false).signUpLocationController.text != 'Location Address'){
                                    if(Provider.of<SignUpHelper>(context, listen: false).checkRole == 'company'){
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          child: SignUpAvatar(),
                                          type: PageTransitionType.leftToRight,
                                        ),
                                      );
                                    }
                                    else {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          child: SignUpCV(),
                                          type: PageTransitionType.leftToRight,
                                        ),
                                      );
                                    }
                                  }
                                  else {
                                    warningText(context,'Please get location by click on the button');
                                  }
                                }

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
