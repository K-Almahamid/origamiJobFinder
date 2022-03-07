import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/home/home_screen.dart';
import 'package:origami/screens/post/applies_screen.dart';
import 'package:origami/screens/profile/profile_helpers.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostHelper with ChangeNotifier {
  TextEditingController aboutTheOpportunityController = TextEditingController();
  TextEditingController firstReqController = TextEditingController();
  TextEditingController secondReqController = TextEditingController();
  TextEditingController thirdReqController = TextEditingController();
  TextEditingController minSalaryController = TextEditingController();
  TextEditingController maxSalaryController = TextEditingController();

  bool fullTimeIsSelected = false;
  bool partTimeIsSelected = false;
  bool remoteIsSelected = false;
  bool contractIsSelected = false;
  bool freelanceIsSelected = false;
  bool anywhereIsSelected = false;
  String fullTime = '';
  String partTime = '';
  String remote = '';
  String contract = '';
  String freelance = '';
  String anywhere = '';

  var formKey = GlobalKey<FormState>();

  static List<String> jobsTitleList = [
    'Computer technician',
    'Computer support technician',
    'Help desk worker',
    'Help desk analyst',
    'Help desk support',
    'Help desk technician',
    'Desktop support specialist',
    'IT support specialist',
    'IT technician',
    'Problem manager',
    'Operations analyst',
    'Technical assistance specialist',
    'Technical specialist',
    'Technical support',
    'Support specialist',
    'Computer operator',
    'Web designer',
    'Web engineer',
    'Web producers',
    'Web development manager',
    'Web development project manager',
    'User experience (UX) designer',
    'User interface (UI) designer',
    'UX/UI researcher',
    'UX/UI specialist',
    'Webmaster',
    'Web producer',
    'Web project manager',
    'Web content manager',
    'Multimedia architect',
    'Web analytics developer',
    'Search engine optimization (SEO) consultant',
    'SEO manager',
    'Internet engineer',
    'Interaction designer',
    'Front-end designer',
    'Front-end developer',
    'Mobile developer',
    'Full-stack developer',
    'Systems designer',
    'Senior systems analyst',
    'Application support analyst',
    'Systems analyst',
    'IT coordinator',
    'IT manager',
    'Solutions architect',
    'Technology manager',
    'Technology assistant',
    'Technology specialist',
    'Technical account manager',
    'IT sales executive',
    'IT sales director',
    'Business systems analyst',
    'Security specialist',
    'IT security analyst',
    'Network security engineer',
    'Information security analyst',
    'Information security engineer',
    'Information security manager',
    'Information security consultant',
    'Information security project manager',
    'Information security program manager',
    'Management information director',
    'Cyber security specialist',
    'Cyber security manager',
    'Computer forensic investigator',
    'Database developer',
    'Database analyst',
    'Database manager',
    'Database engineer',
    'Database specialist',
    'Database coordinator',
    'Data quality manager',
    'Data modeler',
    'Data scientist',
    'Data architect',
    'Information architect',
    'Computer data scientist',
    'Computer network specialist',
    'Computer systems analyst',
    'Computer and information research scientist',
    'Computer and information research manager',
    'Network administrator',
    'Network architect',
    'Network analyst',
    'Network technician',
    'Network operations engineer',
    'Network reliability engineer',
    'Network infrastructure specialist',
    'Software engineer',
    'Software architect',
    'Software test engineer',
    'Software development manager',
    'Software development engineer',
    'Artificial intelligence engineer',
    'Application developer',
    'Application designer',
    'Application engineer',
    'DevOps engineer',
    'Computer programmer',
    'Lead programmer',
    'Iteration manager',
    'Frameworks specialist',
    'Game developer',
    'Cloud systems engineer',
    'Cloud computing engineer',
    'Cloud architect',
    'Cloud system administrator',
    'Cloud consultant',
    'Cloud services provider',
    'Cloud services developer',
    'Cloud product manager',
    'Chief information officer (CIO)',
    'Chief technology officer (CTO)',
    'IT manager',
    'IT director',
    'IT project manager',
    'Director of technology',
    'Technical operations officer',
    'Information management systems director',
    'Senior IT consultant',
    'Technical lead',
  ];

  String? value;

  Map<String, dynamic>? userMap;

  void getData(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("useruid", isEqualTo: id)
        .get()
        .then((value) {
      userMap = value.docs[0].data();
    });
  }

  Widget icon = const Icon(IconBroken.Arrow___Down_2);

  Future addToFavorite(String email, String name, String image, String title,
      String about, time) async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('users-favorite-jobs');
    return _collectionRef.doc(email).collection('jobs').doc(about).set({
      'username': name,
      'userimage': image,
      'jobtitle': title,
      'about': about,
      'time': time,
    }).then((value) => print('Added to favorite'));
  }

  Future applyJob(
      String id, String email, String name, String image, String about) async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('posts');
    return _collectionRef.doc(about).collection('apply').doc(email).set({
      'useruid': id,
      'useremail': email,
      'username': name,
      'userimage': image,
      'about': about,
      'time': Timestamp.now(),
    }).then((value) => print('applied'));
  }

  PreferredSizeWidget postAppBar(
          BuildContext context,
          id,
          String countryLocation,
          String governorateLocation,
          String areaLocation,
          name,
          email,
          image,
          bio) =>
      AppBar(
        backgroundColor: xWhite,
        elevation: 3.0,
        shadowColor: xOrange,
        leading: IconButton(
          icon: const Icon(IconBroken.Close_Square, color: xBlack, size: 30),
          onPressed: () {
            // postCloseDialog(context);
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text('New Post ', style: kPageTitleStyle),
        actions: [
          Center(
            child: TextButton(
              child:
                  Text('Post', style: kPageTitleStyle.copyWith(color: xOrange)),
              onPressed: () async {
                if (fullTimeIsSelected) {
                  fullTime = 'Full Time';
                } else if (partTimeIsSelected) {
                  partTime = 'Part Time';
                }
                if (contractIsSelected) {
                  contract = 'Contract';
                } else if (freelanceIsSelected) {
                  freelance = 'Freelance';
                }
                if (remoteIsSelected) {
                  remote = 'Remote';
                }
                if (anywhereIsSelected) {
                  anywhere = 'Anywhere';
                }
                if (formKey.currentState!.validate()) {
                  Provider.of<FireBaseOperations>(context, listen: false)
                      .uploadPostData(aboutTheOpportunityController.text, {
                        'useruid': id,
                        'username': name,
                        'userimage': image,
                        'useremail': email,
                        'usercountrylocation': countryLocation,
                        'usergovernoratelocation': governorateLocation,
                        'userarealocation': areaLocation,
                        'userbio': bio,
                        'time': Timestamp.now(),
                        //tags..
                        'fulltime': fullTime,
                        'parttime': partTime,
                        'remote': remote,
                        'contract': contract,
                        'freelance': freelance,
                        'anywhere': anywhere,
                        //about the opportunity
                        'about': aboutTheOpportunityController.text,
                        //job requirements
                        'firstrequirement': firstReqController.text,
                        'secondrequirement': secondReqController.text,
                        'thirdrequirement': thirdReqController.text,
                        //min max salary
                        'minsalary': minSalaryController.text,
                        'maxsalary': maxSalaryController.text,
                        'jobtitle': value,
                      })
                      .catchError((e) {
                        warningText(context, e.toString());
                      })
                      .whenComplete(() => FirebaseFirestore.instance
                              .collection('users')
                              .doc(id)
                              .collection('posts')
                              .add({
                            'usercountrylocation': countryLocation,
                            'usergovernoratelocation': governorateLocation,
                            'userarealocation': areaLocation,
                            //tags..
                            'fulltime': fullTime,
                            'parttime': partTime,
                            'remote': remote,
                            'contract': contract,
                            'freelance': freelance,
                            'anywhere': anywhere,
                            'about': aboutTheOpportunityController.text,
                            'firstrequirement': firstReqController.text,
                            'secondrequirement': secondReqController.text,
                            'thirdrequirement': thirdReqController.text,
                            'time': Timestamp.now(),
                          }))
                      .whenComplete(() {
                        aboutTheOpportunityController.text = '';
                        firstReqController.text = '';
                        secondReqController.text = '';
                        thirdReqController.text = '';
                        minSalaryController.text = '';
                        maxSalaryController.text = '';
                        fullTime = '';
                        partTime = '';
                        remote = '';
                        contract = '';
                        freelance = '';
                        anywhere = '';
                        fullTimeIsSelected = false;
                        partTimeIsSelected = false;
                        remoteIsSelected = false;
                        contractIsSelected = false;
                        freelanceIsSelected = false;
                        // toast(context, 'Posted successfully',
                        //     Icons.done_rounded, xGreen, xGreen);
                        Navigator.pop(context);
                      });
                }
              },
            ),
          ),
          const SizedBox(width: 15.0),
        ],
      );

  Widget postBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  dropdownColor: xWhite,
                  hint: Text('Select job title from below',
                      style: kSubtitleStyle.copyWith(
                          fontSize: 15, color: xOrange)),
                  isDense: true,
                  icon: const Icon(IconBroken.Arrow___Down_Circle),
                  iconSize: 25,
                  items: jobsTitleList.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    this.value = value;
                    notifyListeners();
                  },
                ),
              ),
            ),
            divider(),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: xBlack,
                trailing: icon,
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                  child: Text(
                    'Add tags to your post..',
                    style: kSubtitleStyle.copyWith(color: xGray),
                  ),
                ),
                tilePadding: const EdgeInsets.only(right: 10),
                onExpansionChanged: (val) {
                  icon = val == true
                      ? const Icon(IconBroken.Arrow___Up_Circle,
                          color: xBlack, size: 25)
                      : const Icon(IconBroken.Arrow___Down_Circle,
                          color: xBlack, size: 25);
                  notifyListeners();
                },
                title: Text('Tags..',
                    style:
                        kSubtitleStyle.copyWith(fontSize: 20, color: xOrange)),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: ChoiceChip(
                          selectedColor: xOrange,
                          label: const Text('Full Time'),
                          avatar: const Icon(IconBroken.Time_Circle),
                          selected: fullTimeIsSelected,
                          elevation: 5,
                          labelStyle: kTitleStyle,
                          pressElevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                  color: xBlack.withOpacity(0.5), width: 2)),
                          onSelected: (newBoolValue) {
                            fullTimeIsSelected = newBoolValue;
                            partTimeIsSelected = !newBoolValue;
                            notifyListeners();
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: ChoiceChip(
                          selectedColor: xOrange,
                          label: const Text('Part Time'),
                          avatar: const Icon(IconBroken.Time_Circle),
                          selected: partTimeIsSelected,
                          elevation: 5,
                          labelStyle: kTitleStyle,
                          pressElevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                  color: xBlack.withOpacity(0.5), width: 2)),
                          onSelected: (newBoolValue) {
                            partTimeIsSelected = newBoolValue;
                            fullTimeIsSelected = !newBoolValue;
                            notifyListeners();
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: ChoiceChip(
                          selectedColor: xOrange,
                          label: const Text('Remote'),
                          avatar: const Icon(
                            Icons.social_distance,
                          ),
                          selected: remoteIsSelected,
                          elevation: 5,
                          labelStyle: kTitleStyle,
                          pressElevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                  color: xBlack.withOpacity(0.5), width: 2)),
                          onSelected: (newBoolValue) {
                            remoteIsSelected = newBoolValue;
                            notifyListeners();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: ChoiceChip(
                          selectedColor: xOrange,
                          label: const Text('Contract'),
                          avatar: const Icon(EvaIcons.fileTextOutline),
                          selected: contractIsSelected,
                          elevation: 5,
                          labelStyle: kTitleStyle,
                          pressElevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                  color: xBlack.withOpacity(0.5), width: 2)),
                          onSelected: (newBoolValue) {
                            contractIsSelected = newBoolValue;
                            freelanceIsSelected = !newBoolValue;
                            notifyListeners();
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: ChoiceChip(
                          selectedColor: xOrange,
                          label: const Text('Freelance'),
                          avatar: const Icon(EvaIcons.code),
                          selected: freelanceIsSelected,
                          elevation: 5,
                          labelStyle: kTitleStyle,
                          pressElevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                  color: xBlack.withOpacity(0.5), width: 2)),
                          onSelected: (newBoolValue) {
                            freelanceIsSelected = newBoolValue;
                            contractIsSelected = !newBoolValue;
                            notifyListeners();
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: ChoiceChip(
                          selectedColor: xOrange,
                          label: const Text('Anywhere'),
                          avatar: const Icon(IconBroken.Location),
                          selected: anywhereIsSelected,
                          elevation: 5,
                          labelStyle: kTitleStyle,
                          pressElevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                  color: xBlack.withOpacity(0.5), width: 2)),
                          onSelected: (newBoolValue) {
                            anywhereIsSelected = newBoolValue;
                            notifyListeners();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Job Overview',
                    style:
                        kSubtitleStyle.copyWith(fontSize: 20, color: xOrange)),
                const SizedBox(height: 15),
                TextFormField(
                  style:
                      kSubtitleStyle.copyWith(wordSpacing: 1.0, fontSize: 18),
                  cursorColor: xOrange,
                  maxLength: 400,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'About the Opportunity ',
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.start,
                  controller: aboutTheOpportunityController,
                  keyboardType: TextInputType.multiline,
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: 'Required'),
                      LengthRangeValidator(
                        min: 10,
                        max: 400,
                        errorText: 'At least 10 characters must be entered',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Responsibilities',
                    style:
                        kSubtitleStyle.copyWith(fontSize: 20, color: xOrange)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    style:
                        kSubtitleStyle.copyWith(wordSpacing: 1.0, fontSize: 18),
                    cursorColor: xOrange,
                    maxLength: 200,
                    maxLines: null,
                    minLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'First Job Requirement',
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.start,
                    controller: firstReqController,
                    keyboardType: TextInputType.multiline,
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: 'Required'),
                        LengthRangeValidator(
                          min: 10,
                          max: 200,
                          errorText: 'At least 10 characters must be entered',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    style:
                        kSubtitleStyle.copyWith(wordSpacing: 1.0, fontSize: 18),
                    cursorColor: xOrange,
                    maxLength: 200,
                    maxLines: null,
                    minLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Second Job Requirement',
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.start,
                    controller: secondReqController,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    style:
                        kSubtitleStyle.copyWith(wordSpacing: 1.0, fontSize: 18),
                    cursorColor: xOrange,
                    maxLength: 200,
                    maxLines: null,
                    minLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Third Job Requirement',
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.start,
                    controller: thirdReqController,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
            divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Salary Range..',
                    style:
                        kSubtitleStyle.copyWith(fontSize: 20, color: xOrange)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Min. Salary',
                        style: kPageTitleStyle.copyWith(fontSize: 20)),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextFormField(
                        style: kSubtitleStyle.copyWith(
                            wordSpacing: 1.0,
                            fontSize: 18,
                            letterSpacing: 2,
                            height: 1.5),
                        cursorColor: xOrange,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          hintText: 'Enter Minimum salary',
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                        ],
                        textAlign: TextAlign.start,
                        controller: minSalaryController,
                        keyboardType: TextInputType.number,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: 'Required'),
                            LengthRangeValidator(
                              min: 2,
                              max: 5,
                              errorText:
                                  'At least two-digit number must be entered',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Max. Salary',
                        style: kPageTitleStyle.copyWith(fontSize: 20)),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextFormField(
                        style: kSubtitleStyle.copyWith(
                            wordSpacing: 1.0, fontSize: 18),
                        cursorColor: xOrange,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          hintText: 'Enter Maximum salary',
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                        ],
                        textAlign: TextAlign.start,
                        controller: maxSalaryController,
                        keyboardType: TextInputType.number,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: 'Required'),
                            LengthRangeValidator(
                              min: 2,
                              max: 5,
                              errorText:
                                  'At least two-digit number must be entered',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget jobDetailsAppBar(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    getData((snapshot.data as dynamic)['useruid']);
    return AppBar(
      backgroundColor: xSilver.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          IconBroken.Arrow___Left_Circle,
          color: xBlack,
          size: 30,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        userMap!['username'],
        style: kTitleStyle,
      ),
      actions: [
        Center(
          child: Text(
            Provider.of<PostOptions>(context, listen: false)
                .getTimePosted
                .toString(),
            style: kTitleStyle.copyWith(color: xGray, fontSize: 15),
          ),
        ),
        const SizedBox(width: 15.0),
      ],
    );
  }

  Widget jobDetailsBody(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return DefaultTabController(
      length: 2,
      child: Container(
        width: double.infinity,
        // margin: EdgeInsets.only(top: 50.0),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(maxHeight: 280.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: NetworkImage(userMap!['userimage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      (snapshot.data as dynamic)['jobtitle'],
                      style: kTitleStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (snapshot.data as dynamic)['remote'] != ''
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: xBlack.withOpacity(.5)),
                                  ),
                                  child: Text(
                                    (snapshot.data as dynamic)['remote'],
                                    style: kSubtitleStyle,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          (snapshot.data as dynamic)['anywhere'] != ''
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: xBlack.withOpacity(.5)),
                                  ),
                                  child: Text(
                                    (snapshot.data as dynamic)['anywhere'],
                                    style: kSubtitleStyle,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          (snapshot.data as dynamic)['contract'] != ''
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: xBlack.withOpacity(.5)),
                                  ),
                                  child: Text(
                                    (snapshot.data as dynamic)['contract'],
                                    style: kSubtitleStyle,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          (snapshot.data as dynamic)['freelance'] != ''
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: xBlack.withOpacity(.5)),
                                  ),
                                  child: Text(
                                    (snapshot.data as dynamic)['freelance'],
                                    style: kSubtitleStyle,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          (snapshot.data as dynamic)['fulltime'] != ''
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: xBlack.withOpacity(.5)),
                                  ),
                                  child: Text(
                                    (snapshot.data as dynamic)['fulltime'],
                                    style: kSubtitleStyle,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          (snapshot.data as dynamic)['parttime'] != ''
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: xBlack.withOpacity(.5)),
                                  ),
                                  child: Text(
                                    (snapshot.data as dynamic)['parttime'],
                                    style: kSubtitleStyle,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              IconBroken.Location,
                              color: xOrange,
                              size: 17.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  (snapshot.data as dynamic)[
                                              'usercountrylocation'] !=
                                          ''
                                      ? Text(
                                          "${(snapshot.data as dynamic)['usercountrylocation']} ,",
                                          style: kTitleStyle)
                                      : const SizedBox(
                                          width: 0.0,
                                          height: 0.0,
                                        ),
                                  (snapshot.data as dynamic)[
                                              'usergovernoratelocation'] !=
                                          ''
                                      ? Text(
                                          "${(snapshot.data as dynamic)['usergovernoratelocation']}",
                                          style: kTitleStyle)
                                      : const SizedBox(
                                          width: 0.0,
                                          height: 0.0,
                                        ),
                                  (snapshot.data
                                              as dynamic)['userarealocation'] !=
                                          ''
                                      ? Text(
                                          ",${(snapshot.data as dynamic)['userarealocation']}",
                                          style: kTitleStyle)
                                      : const SizedBox(
                                          width: 0.0,
                                          height: 0.0,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: xBlack.withOpacity(.2),
                      ),
                    ),
                    // borderRadius: BorderRadius.circular(12.0),
                    child: TabBar(
                      unselectedLabelColor: xBlack,
                      indicator: BoxDecoration(
                        color: xOrange,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      tabs: const [
                        Tab(text: "Description"),
                        Tab(text: "Company"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: TabBarView(
                children: [
                  jobDescription(context, snapshot),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .profileAbout(context, userMap!['userbio']),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget jobDescription(BuildContext context, AsyncSnapshot snapshot) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 25.0),
        Text(
          "Job Overview",
          style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15.0),
        Text(
          (snapshot.data as dynamic)['about'],
          style: kSubtitleStyle.copyWith(
            fontWeight: FontWeight.w300,
            height: 1.5,
            color: const Color(0xFF5B5B5B),
          ),
        ),
        const SizedBox(height: 25.0),
        Text(
          "Responsibilities",
          style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15.0),
        Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "•  ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20.0),
              ),
              Expanded(
                child: Text(
                  "${(snapshot.data as dynamic)['firstrequirement']}\n",
                  style: kSubtitleStyle.copyWith(
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                    color: const Color(0xFF5B5B5B),
                  ),
                ),
              ),
            ],
          ),
          (snapshot.data as dynamic)['secondrequirement'] == ''
              ? const SizedBox(height: 0.0, width: 0.0)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "•  ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Expanded(
                      child: Text(
                        "${(snapshot.data as dynamic)['secondrequirement']}\n",
                        style: kSubtitleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                          color: const Color(0xFF5B5B5B),
                        ),
                      ),
                    ),
                  ],
                ),
          (snapshot.data as dynamic)['thirdrequirement'] == ''
              ? const SizedBox(height: 0.0, width: 0.0)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "•  ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Expanded(
                      child: Text(
                        "${(snapshot.data as dynamic)['thirdrequirement']}\n",
                        style: kSubtitleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                          color: const Color(0xFF5B5B5B),
                        ),
                      ),
                    ),
                  ],
                ),
        ]),
        const SizedBox(height: 15.0),
        Text(
          "Salary Range",
          style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15.0),
        Row(
          children: [
            const Icon(
              Icons.attach_money,
              color: xOrange,
              size: 17.0,
            ),
            Text(
              "${(snapshot.data as dynamic)['minsalary']} -",
              style: kTitleStyle,
            ),
            const Icon(
              Icons.attach_money,
              color: xOrange,
              size: 17.0,
            ),
            Text(
              "${(snapshot.data as dynamic)['maxsalary']}",
              style: kTitleStyle,
            ),
          ],
        ),
      ],
    );
  }

  jobDetailsFooterForUser(
      BuildContext context,
      String email,
      String about,
      String name,
      String image,
      String id,
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Container(
        padding: const EdgeInsets.only(left: 18.0, bottom: 25.0, right: 18.0),
        // margin: EdgeInsets.only(bottom: 25.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users-favorite-jobs')
                    .doc(email)
                    .collection('jobs')
                    .where('about', isEqualTo: about)
                    .snapshots(),
                builder: (context, snapshotD) {
                  if (snapshotD.data == null) {
                    return const Text('');
                  }
                  return GestureDetector(
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: xBlack.withOpacity(.5)),
                        borderRadius: BorderRadius.circular(12.0),
                        color: xWhite,
                      ),
                      //snapshotD.data!.docs.isEmpty
                      child: snapshotD.data!.docs.isEmpty
                          ? const Icon(Icons.bookmark_border, color: xBlack)
                          : const Icon(Icons.bookmark_rounded, color: xOrange),
                    ),
                    onTap: () => snapshotD.data!.docs.isEmpty
                        ? addToFavorite(
                            email,
                            (snapshot.data as dynamic)['username'],
                            (snapshot.data as dynamic)['userimage'],
                            (snapshot.data as dynamic)['jobtitle'],
                            (snapshot.data as dynamic)['about'],
                            (snapshot.data as dynamic)['time'],
                          )
                        : warningText(context, 'Already Added'),
                  );
                }),
            const SizedBox(width: 15.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(about)
                      .collection('apply')
                      .where('useremail', isEqualTo: email)
                      .snapshots(),
                  builder: (context, snapshotD) {
                    if (snapshotD.data == null) {
                      return const Text('');
                    }
                    return SizedBox(
                      height: 50.0,
                      child: snapshotD.data!.docs.isEmpty
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: xBlack,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text('Apply for job',
                                  style: kTitleStyle.copyWith(color: xWhite)),
                              onPressed: () => applyJob(
                                id,
                                email,
                                name,
                                image,
                                about,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: xGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text('Already Applied',
                                  style: kTitleStyle.copyWith(color: xBlack)),
                              onPressed: () {
                                print('Already Applied');
                              }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  jobDetailsFooterForCompany(BuildContext context, String about, String email,
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Container(
        padding: const EdgeInsets.only(left: 18.0, bottom: 25.0, right: 18.0),
        // margin: EdgeInsets.only(bottom: 25.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users-favorite-jobs')
                    .doc(email)
                    .collection('jobs')
                    .where('about', isEqualTo: about)
                    .snapshots(),
                builder: (context, snapshotD) {
                  if (snapshotD.data == null) {
                    return const Text('');
                  }
                  return GestureDetector(
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: xBlack.withOpacity(.5)),
                        borderRadius: BorderRadius.circular(12.0),
                        color: xWhite,
                      ),
                      //snapshotD.data!.docs.isEmpty
                      child: snapshotD.data!.docs.isEmpty
                          ? const Icon(Icons.bookmark_border, color: xBlack)
                          : const Icon(Icons.bookmark_rounded, color: xOrange),
                    ),
                    onTap: () => snapshotD.data!.docs.isEmpty
                        ? addToFavorite(
                            email,
                            (snapshot.data as dynamic)['username'],
                            (snapshot.data as dynamic)['userimage'],
                            (snapshot.data as dynamic)['jobtitle'],
                            (snapshot.data as dynamic)['about'],
                            (snapshot.data as dynamic)['time'],
                          )
                        : warningText(context, 'Already Added'),
                  );
                }),
            const SizedBox(width: 15.0),
            Expanded(
              child: SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: xBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text('Show applies for job',
                      style: kTitleStyle.copyWith(color: xWhite)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AppliesScreen(about: about),
                        type: PageTransitionType.bottomToTop,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  postCloseDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade100,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Save for later?', style: kPageTitleStyle),
              const SizedBox(height: 10.0),
              Text(
                'The post you started will be here \n when you return.',
                style: kTitleStyle,
              )
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text(
                    'Go back',
                    style: kSubtitleStyle.copyWith(color: xBlack),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Discard',
                      style: kSubtitleStyle.copyWith(color: xOrange)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: HomeScreen(),
                        type: PageTransitionType.bottomToTop,
                      ),
                    ).whenComplete(() {
                      aboutTheOpportunityController.text = '';
                      firstReqController.text = '';
                      secondReqController.text = '';
                      thirdReqController.text = '';
                      minSalaryController.text = '';
                      maxSalaryController.text = '';
                      fullTime = '';
                      partTime = '';
                      remote = '';
                      contract = '';
                      freelance = '';
                      anywhere = '';
                      fullTimeIsSelected = false;
                      partTimeIsSelected = false;
                      remoteIsSelected = false;
                      contractIsSelected = false;
                      freelanceIsSelected = false;
                    });
                  },
                ),
                TextButton(
                    child: Text(
                      'Save',
                      style: kSubtitleStyle.copyWith(color: xBlack),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: HomeScreen(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item, style: kTitleStyle),
      );
}
