import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/profile/profile_screen.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart' as geoCo;

class ProfileEdit extends StatefulWidget {
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

Position? position;
String country = '';
String governorate = '';
String area = '';
String finalAddress = 'Location Address';
File? file;
PlatformFile? platformFile;

TextEditingController editLocationController = TextEditingController();

class _ProfileEditState extends State<ProfileEdit> {
  // final user = User.data();

  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  TextEditingController editNameController = TextEditingController();

  TextEditingController editEmailController = TextEditingController();

  TextEditingController editPhoneController = TextEditingController();

  TextEditingController editBioController = TextEditingController();

  bool editPasswordObscure = false;

  String? image, id;
  @override
  void initState() {
    super.initState();
    User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    id = user.useruid;
    image = user.userimage;


    editNameController.text = user.username;
    editEmailController.text = user.useremail;
    editPhoneController.text = user.userphone;
    editBioController.text = user.userbio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        leadingWidth: 50,
        shadowColor: xOrange,
        leading: GestureDetector(
          child: const Icon(
            IconBroken.Arrow___Left_Circle,
            color: xBlack,
            size: 30,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profile', style: kPageTitleStyle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: platformFile != null
                              ? FileImage(file!) as ImageProvider
                              : NetworkImage(image!),
                        ),
                        Positioned(
                          left: 65.0,
                          top: 65,
                          child: GestureDetector(
                            child: const CircleAvatar(
                              radius: 20.0,
                              backgroundColor: xSilver,
                              child: Icon(
                                IconBroken.Camera,
                                color: xOrange,
                                size: 25.0,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectFile();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: editFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: editNameController,
                                  keyboardType: TextInputType.name,
                                  cursorColor: xOrange,
                                  style: kTitleStyle,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "Name",
                                    labelStyle: kTitleStyle,
                                    prefixIcon: const Icon(
                                      IconBroken.Profile,
                                      color: xBlack,
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
                                  controller: editEmailController,
                                  style: kTitleStyle,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: xOrange,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "Email",
                                    labelStyle: kTitleStyle,
                                    prefixIcon: const Icon(IconBroken.Message,
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
                                      EmailValidator(
                                          errorText: 'Not A Valid Email'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                TextFormField(
                                  controller: editPhoneController,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: xOrange,
                                  style: kTitleStyle,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "Phone",
                                    labelStyle: kTitleStyle,
                                    prefixIcon: const Icon(IconBroken.Call,
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
                                const SizedBox(height: 15.0),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: editLocationController,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        cursorColor: xOrange,
                                        style: kTitleStyle,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Location',
                                          hintText: editLocationController.text,
                                          labelStyle: kTitleStyle,
                                          prefixIcon: const Icon(
                                              IconBroken.Location,
                                              color: xBlack),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                              color: xBlack,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                              color: xBlack,
                                            ),
                                          ),
                                        ),
                                        validator: MultiValidator(
                                          [
                                            RequiredValidator(
                                                errorText: 'Required'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      flex: 1,
                                      child: MaterialButton(
                                        color: xOrange,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        child: Text('Get Location',
                                            textAlign: TextAlign.center,
                                            style: kSubtitleStyle.copyWith(
                                                color: xWhite)),
                                        onPressed: () {
                                          setState(() {
                                            updateUserCurrentLocation();
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
                                  style: kTitleStyle.copyWith(height: 1.5),
                                  cursorColor: xOrange,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(400)
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    labelText: 'Bio..',
                                    labelStyle: kTitleStyle,
                                    prefixIcon: const Icon(
                                        IconBroken.Info_Circle,
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
                                  textAlign: TextAlign.start,
                                  controller: editBioController,
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: xOrange,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: MaterialButton(
                              elevation: 2.0,
                              child: Text('Update',
                                  style: kTitleStyle.copyWith(color: xWhite)),
                              onPressed: () {
                                if (editFormKey.currentState!.validate()) {
                                  if (editLocationController.text !=
                                      'Location Address') {
                                    Provider.of<FireBaseOperations>(context,
                                            listen: false)
                                        .updateUserData(
                                            Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid!,
                                            {
                                          'username': editNameController.text,
                                          'useremail': editEmailController.text,
                                          'userphone': editPhoneController.text,
                                          'userbio': editBioController.text,
                                          'usercountrylocation': country,
                                          'usergovernoratelocation':
                                              governorate,
                                          'userarealocation': area,
                                        }).catchError((e) {
                                      warningText(context,'Error cant update data');
                                    }).whenComplete(() {
                                      CacheHelper.putDataInSharedPreference(value:editNameController.text, key: 'username');
                                      CacheHelper.putDataInSharedPreference(value: editEmailController.text, key: 'useremail');
                                      CacheHelper.putDataInSharedPreference(value: file , key: 'userimage');
                                      CacheHelper.putDataInSharedPreference(value: editPhoneController.text, key: 'userphone');
                                      CacheHelper.putDataInSharedPreference(value: country, key: 'usercountrylocation');
                                      CacheHelper.putDataInSharedPreference(value:governorate, key: 'usergovernoratelocation');
                                      CacheHelper.putDataInSharedPreference(value: area, key: 'userarealocation');
                                      CacheHelper.putDataInSharedPreference(value: editBioController, key: 'userbio');
                                    })
                                        .whenComplete(
                                      () {
                                        warningText(context,'Data updated successfully');
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            child: ProfileScreen(),
                                            type:
                                                PageTransitionType.bottomToTop,
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    warningText(context,'Please get your location');
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future updateUserCurrentLocation() async {
    try {
      setState(() async {
        var positionData =
            await GeolocatorPlatform.instance.getCurrentPosition();
        final cords =
            geoCo.Coordinates(positionData.latitude, positionData.longitude);
        var address =
            await geoCo.Geocoder.local.findAddressesFromCoordinates(cords);
        country = address.first.countryName ?? '';
        governorate = address.first.locality ?? '';
        area = address.first.subLocality ?? '';
        finalAddress = "$country $governorate $area";
        editLocationController.text = finalAddress;
      });
    } catch (e) {
      setState(() {
        editLocationController.text = 'Try Again Something Happen';
      });
    }
  }

  selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    if (result == null) return;
    file = File(result.files.single.path!);
    platformFile = result.files.first;
    // loadingController.forward();
  }
}
