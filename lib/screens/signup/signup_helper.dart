import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:geolocator/geolocator.dart';
import 'package:origami/screens/signup/signup_utils.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:provider/provider.dart';

class SignUpHelper with ChangeNotifier {
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpPhoneController = TextEditingController();
  TextEditingController signUpLocationController = TextEditingController();
  TextEditingController signUpBioController = TextEditingController();

  String checkRole= 'user';

  Position? position;
  String country = '';
  String governorate = '';
  String area = '';
  String finalAddress ='Location Address';

  File? file;
  PlatformFile? platformFile;

  selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'doc']);
    if (result == null) return;
    file = File(result.files.single.path!);
    platformFile = result.files.first;
    notifyListeners();
    // loadingController.forward();
  }

  // Widget signUpForm1(BuildContext context) {
  //    return Scaffold(
  //      backgroundColor: Colors.grey.shade100,
  //      body: Padding(
  //        padding: const EdgeInsets.only(top: 20.0),
  //        child: Column(
  //          crossAxisAlignment: CrossAxisAlignment.start,
  //          children: [
  //            // Text(
  //            //   'Origami',
  //            //   style: TextStyle(
  //            //     color: constantColors.redColor,
  //            //     fontSize: 50,
  //            //     fontWeight: FontWeight.bold,
  //            //     fontFamily: 'Ephesis-Regular',
  //            //   ),
  //            // ),
  //            Form(
  //              autovalidateMode: AutovalidateMode.onUserInteraction,
  //              key: signUpFormKey,
  //              child: Column(
  //                crossAxisAlignment: CrossAxisAlignment.start,
  //                mainAxisAlignment: MainAxisAlignment.center,
  //                children: [
  //                  const SizedBox(height: 20.0),
  //                  TextFormField(
  //                    controller: signUpNameController,
  //                    keyboardType: TextInputType.name,
  //                    cursorColor: constantColors.darkColor,
  //                    decoration: InputDecoration(
  //                      border: const OutlineInputBorder(),
  //                      labelText: "Username",
  //                      labelStyle: TextStyle(color: constantColors.darkColor),
  //                      prefixIcon: Icon(IconBroken.Profile,
  //                          color: constantColors.darkColor),
  //                      focusedBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                      enabledBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                    ),
  //                    validator: MultiValidator(
  //                      [
  //                        RequiredValidator(errorText: 'Required'),
  //                        LengthRangeValidator(
  //                          min: 6,
  //                          max: 25,
  //                          errorText:
  //                              'must be more then 6 and less than 25 characters',
  //                        ),
  //                      ],
  //                    ),
  //                  ),
  //                  const SizedBox(height: 15.0),
  //                  TextFormField(
  //                    controller: signUpEmailController,
  //                    keyboardType: TextInputType.emailAddress,
  //                    cursorColor: constantColors.darkColor,
  //                    decoration: InputDecoration(
  //                      border: const OutlineInputBorder(),
  //                      labelText: "Enter Email",
  //                      labelStyle: TextStyle(color: constantColors.darkColor),
  //                      prefixIcon: Icon(IconBroken.Message,
  //                          color: constantColors.darkColor),
  //                      focusedBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                      enabledBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                    ),
  //                    validator: MultiValidator(
  //                      [
  //                        RequiredValidator(errorText: 'Required'),
  //                        EmailValidator(errorText: 'Not A Valid Email'),
  //                      ],
  //                    ),
  //                  ),
  //                  const SizedBox(height: 15.0),
  //                  TextFormField(
  //                    controller: signUpPhoneController,
  //                    keyboardType: TextInputType.phone,
  //                    cursorColor: constantColors.darkColor,
  //                    decoration: InputDecoration(
  //                      border: const OutlineInputBorder(),
  //                      labelText: "Phone",
  //                      labelStyle: TextStyle(color: constantColors.darkColor),
  //                      prefixIcon:
  //                          Icon(IconBroken.Call, color: constantColors.darkColor),
  //                      focusedBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                      enabledBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                    ),
  //                    validator: MultiValidator(
  //                      [
  //                        RequiredValidator(errorText: 'Required'),
  //                      ],
  //                    ),
  //                  ),
  //                  const SizedBox(height: 15.0),
  //                  TextFormField(
  //                    controller: signUpPasswordController,
  //                    keyboardType: TextInputType.visiblePassword,
  //                    cursorColor: constantColors.darkColor,
  //                    obscureText: signUpPasswordObscure,
  //                    decoration: InputDecoration(
  //                      border: const OutlineInputBorder(),
  //                      labelText: "Enter Password",
  //                      labelStyle: TextStyle(color: constantColors.darkColor),
  //                      prefixIcon:
  //                          Icon(IconBroken.Lock, color: constantColors.darkColor),
  //                      // suffixIcon: GestureDetector(
  //                      //   onTap: () {
  //                      //     signUpPasswordObscure = !signUpPasswordObscure;
  //                      //     notifyListeners();
  //                      //   },
  //                      //   child: Icon(
  //                      //     signUpPasswordObscure
  //                      //         ? FontAwesomeIcons.eyeSlash
  //                      //         : FontAwesomeIcons.eye,
  //                      //     color: constantColors.darkColor,
  //                      //     size: 20,
  //                      //   ),
  //                      // ),
  //                      focusedBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.redColor,
  //                        ),
  //                      ),
  //                      enabledBorder: OutlineInputBorder(
  //                        borderRadius: BorderRadius.circular(8.0),
  //                        borderSide: BorderSide(
  //                          color: constantColors.darkColor,
  //                        ),
  //                      ),
  //                    ),
  //                    validator: MultiValidator(
  //                      [
  //                        RequiredValidator(errorText: 'Required'),
  //                        LengthRangeValidator(
  //                          min: 7,
  //                          max: 20,
  //                          errorText: 'must be more then 6 and less than 20',
  //                        ),
  //                      ],
  //                    ),
  //                  ),
  //                  const SizedBox(height: 25.0),
  //                  Row(
  //                    children: [
  //                      Expanded(
  //                        flex: 3,
  //                        child: TextFormField(
  //                          readOnly: true,
  //                          controller: signUpLocationController,
  //                          keyboardType: TextInputType.streetAddress,
  //                          cursorColor: constantColors.darkColor,
  //                          decoration: InputDecoration(
  //                            border: const OutlineInputBorder(),
  //                            labelText: 'Location',
  //                            hintText: signUpLocationController.text,
  //                            labelStyle:
  //                                TextStyle(color: constantColors.darkColor),
  //                            prefixIcon: Icon(IconBroken.Location,
  //                                color: constantColors.darkColor),
  //                            focusedBorder: OutlineInputBorder(
  //                              borderRadius: BorderRadius.circular(8.0),
  //                              borderSide: BorderSide(
  //                                color: constantColors.darkColor,
  //                              ),
  //                            ),
  //                            enabledBorder: OutlineInputBorder(
  //                              borderRadius: BorderRadius.circular(8.0),
  //                              borderSide: BorderSide(
  //                                color: constantColors.darkColor,
  //                              ),
  //                            ),
  //                          ),
  //                          validator: MultiValidator(
  //                            [
  //                              RequiredValidator(errorText: 'Required'),
  //                            ],
  //                          ),
  //                        ),
  //                      ),
  //                      const SizedBox(width: 4.0),
  //                      Expanded(
  //                        flex: 1,
  //                        child: MaterialButton(
  //                          color: constantColors.redColor,
  //                          height: MediaQuery.of(context).size.height * 0.08,
  //                          shape: RoundedRectangleBorder(
  //                            borderRadius: BorderRadius.circular(7.0),
  //                            // side: BorderSide(color: Colors.black)
  //                          ),
  //                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
  //                          child: Text(
  //                            'Get Location',
  //                            textAlign: TextAlign.center,
  //                            style: TextStyle(
  //                              color: constantColors.whiteColor,
  //                              fontSize: 15,
  //                            ),
  //                          ),
  //                          onPressed: () {
  //                            getUserCurrentLocation();
  //                          },
  //                        ),
  //                      ),
  //                    ],
  //                  ),
  //                ],
  //              ),
  //            ),
  //          ],
  //        ),
  //      ),
  //    );
  //  }

  // signUpForm2(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SingleChildScrollView(
  //             child: Column(
  //               children: <Widget>[
  //                 const SizedBox(height: 20),
  //                 Text(
  //                   'Upload your CV file',
  //                   style: TextStyle(
  //                     fontSize: 25,
  //                     color: Colors.grey.shade800,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   'File should be jpg, png, jpeg, pdf, doc',
  //                   style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 GestureDetector(
  //                   onTap: selectFile,
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 40.0, vertical: 20.0),
  //                     child: DottedBorder(
  //                       borderType: BorderType.RRect,
  //                       radius: const Radius.circular(10),
  //                       dashPattern: const [10, 4],
  //                       strokeCap: StrokeCap.round,
  //                       color: Colors.red.shade400,
  //                       child: Container(
  //                         width: double.infinity,
  //                         height: 150,
  //                         decoration: BoxDecoration(
  //                             color: Colors.red.shade50.withOpacity(.3),
  //                             borderRadius: BorderRadius.circular(10)),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Icon(
  //                               IconBroken.Folder,
  //                               color: constantColors.redColor,
  //                               size: 40,
  //                             ),
  //                             const SizedBox(
  //                               height: 15,
  //                             ),
  //                             Text(
  //                               'Select your file',
  //                               style: TextStyle(
  //                                 fontSize: 15,
  //                                 color: Colors.grey.shade400,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 platformFile != null
  //                     ? Container(
  //                         padding: const EdgeInsets.all(20),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'Selected File',
  //                               style: TextStyle(
  //                                 color: Colors.grey.shade400,
  //                                 fontSize: 15,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 10),
  //                             Container(
  //                               padding: const EdgeInsets.all(8),
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: Colors.white,
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     color: Colors.grey.shade200,
  //                                     offset: const Offset(0, 1),
  //                                     blurRadius: 3,
  //                                     spreadRadius: 2,
  //                                   )
  //                                 ],
  //                               ),
  //                               child: Row(
  //                                 children: [
  //                                   ClipRRect(
  //                                     borderRadius: BorderRadius.circular(8),
  //                                     child: Image.file(
  //                                       file!,
  //                                       width: 70,
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 10),
  //                                   Expanded(
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           platformFile!.name,
  //                                           style: const TextStyle(
  //                                               fontSize: 13,
  //                                               color: Colors.black),
  //                                         ),
  //                                         const SizedBox(height: 5),
  //                                         Text(
  //                                           '${(platformFile!.size / 1024).ceil()} KB',
  //                                           style: TextStyle(
  //                                               fontSize: 13,
  //                                               color: Colors.grey.shade500),
  //                                         ),
  //                                         const SizedBox(height: 5),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 10),
  //                                 ],
  //                               ),
  //                             ),
  //                             const SizedBox(height: 20),
  //                             MaterialButton(
  //                               minWidth: double.infinity,
  //                               height: 45,
  //                               color: Colors.black,
  //                               child: const Text(
  //                                 'Upload',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                               onPressed: () {
  //                                  Provider.of<FireBaseOperations>(context,listen: false).uploadCVFile(file!);
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : Container(),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  imageSignUpForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
      child: Column(
        children: [
          const Text(
            'Adding a photo helps people recognize you',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey.shade300,
                  child: Provider.of<SignUpUtils>(context, listen: false)
                              .userAvatar ==
                          null
                      ? const Icon(
                          IconBroken.Profile,
                          size: 45.0,
                          color: xBlack,
                        )
                      : CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey.shade300,
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
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey.shade400,
                      child: const Icon(
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
        ],
      ),
    );
  }

  Future getUserCurrentLocation() async {
    try{
      var positionData = await GeolocatorPlatform.instance.getCurrentPosition();
      final cords =
      geoCo.Coordinates(positionData.latitude, positionData.longitude);
      var address =
      await geoCo.Geocoder.local.findAddressesFromCoordinates(cords);
      country = address.first.countryName ?? '';
      governorate = address.first.locality ?? '';
      area = address.first.subLocality ?? '';
      finalAddress = "$country $governorate $area";
      signUpLocationController.text = finalAddress;
      notifyListeners();
    }catch(e){
      signUpLocationController.text='Try Again Something Happen';
      notifyListeners();
    }
  }



  warningText(BuildContext context, String? warning) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: xBlack,
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              warning!,
              style: const TextStyle(
                color: xWhite,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }


}
