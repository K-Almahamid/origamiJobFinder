import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:origami/models/posts.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/post/job_details.dart';
import 'package:origami/shared/components/components.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:origami/utils/post_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final user = User.data();

  TextEditingController searchController = TextEditingController();
  late Future resultsLoaded;
  List allResults = [];
  List resultsList = [];

  String? name, image,email ,role, id, countryLocation;
  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChange);
    User user = User.fromJson(jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    name = user.username;
    id = user.useruid;
    email = user.useremail;

  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChange);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getAllPosts();
  }

  _onSearchChange() {
    searchResultsList();
    print(searchController.text);
  }

  searchResultsList() {
    var showResults = [];
    if (searchController.text != "") {
      //we have search parameter
      for (var postSnapshot in allResults) {
        var about = Posts.fromSnapshot(postSnapshot).about!.toLowerCase();
        if (about.contains(searchController.text.toLowerCase())) {
          showResults.add(postSnapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  getAllPosts() async {
    var data = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .get();

    setState(() {
      allResults = data.docs;
    });
    searchResultsList();
    return 'Completed';
  }

  // Map<String, dynamic>? userMap;
  // void getData(id) async {
  //
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where("useruid", isEqualTo: id)
  //       .get()
  //       .then((value) {
  //     userMap = value.docs[0].data();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: xSilver,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        shadowColor: xOrange,
        title: Text('Search', style: kPageTitleStyle),
        leading: GestureDetector(
          child: const Icon(IconBroken.Arrow___Left_Circle,
              color: xBlack, size: 30),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            toolbarHeight: 80,
            floating: true,
            // pinned: true,
            backgroundColor: xWhite,
            elevation: 0.0,
            leadingWidth: 0.0,
            leading: const SizedBox(),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 20.0),
                      child: TextFormField(
                        style: kTitleStyle,
                        cursorColor: xOrange,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Find your job now',
                          labelStyle: kTitleStyle,
                          hintStyle: kTitleStyle,
                          prefixIcon:
                              const Icon(IconBroken.Search, color: xBlack),
                          border: const OutlineInputBorder(),
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
                          // focusedBorder: InputBorder.none,
                          // disabledBorder: InputBorder.none,
                          // enabledBorder: InputBorder.none,
                          // errorBorder: InputBorder.none,
                          // border: InputBorder.none,
                        ),
                        textAlign: TextAlign.start,
                        controller: searchController,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                  searchController.text == ''
                      ? const Expanded(
                          flex: 0, child: SizedBox(width: 0.0, height: 0.0))
                      : GestureDetector(
                          child:
                              const Icon(Icons.close, color: xBlack, size: 25),
                          onTap: () {
                            searchController.text = '';
                          },
                        ),
                  const SizedBox(width: 20.0),
                ],
              ),
            ),
          )
        ],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20.0, bottom: 20),
              child: Text(
                "Recent Jobs",
                style: kPageTitleStyle,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: resultsList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    buildPostsList(context, resultsList[index],email!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostsList(BuildContext context, DocumentSnapshot document,String email) {
    final post = Posts.fromSnapshot(document);
    final size = MediaQuery.of(context).size;
    // getData(post.useruid);
    Provider.of<PostOptions>(context, listen: false).showTimeAgo(post.time);
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10, left: 20.0, right: 20.0),
            child: GestureDetector(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height / 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: NetworkImage(post.userimage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width / 1.5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            IconBroken.Profile,
                                            color: xOrange,
                                            size: 15.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 25.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: Text(
                                               name!,
                                                style: kTitleStyle.copyWith(
                                                    color: xBlack),
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: size.height / 12),
                                          post.useruid! == id
                                              ? GestureDetector(
                                                  child: const Icon(
                                                    Icons.more_vert,
                                                    color: xBlack,
                                                  ),
                                                  onTap: () {
                                                    postOptions(context,email,post.about!);
                                                  },
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 20,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(IconBroken.Location,
                                              color: xOrange, size: 15.0),
                                          const SizedBox(width: 5.0),
                                          Text(
                                            "${post.usercountrylocation!},${post.usergovernoratelocation!}",
                                            style: kSubtitleStyle.copyWith(
                                                color: xGray),
                                            overflow: TextOverflow.fade,
                                            softWrap: true,
                                            maxLines: 1,
                                          ),
                                          SizedBox(width: size.width /20),
                                          Row(
                                            children: [
                                              const Icon(IconBroken.Time_Circle,
                                                  color: xOrange, size: 15.0),
                                              Text(
                                                Provider.of<PostOptions>(
                                                        context,
                                                        listen: false)
                                                    .getTimePosted
                                                    .toString(),
                                                style: kSubtitleStyle.copyWith(
                                                  color: xGray,
                                                  fontSize: 10,
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.jobtitle!,
                                style: kTitleStyle,
                              ),
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  post.about!,
                                  style: kSubtitleStyle,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            post.remote! != ''
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: xBlack,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      post.remote!,
                                      style: kSubtitleStyle.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: 0.0, height: 0.0),
                            post.anywhere! != ''
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: xBlack,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      post.anywhere!,
                                      style: kSubtitleStyle.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: 0.0, height: 0.0),
                            post.fulltime! != ''
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: xBlack,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      post.fulltime!,
                                      style: kSubtitleStyle.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: 0.0, height: 0.0),
                            post.parttime != ''
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: xBlack,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      post.parttime!,
                                      style: kSubtitleStyle.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: 0.0, height: 0.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: JobDetails(
                      about: post.about!,
                    ),
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
            ),
          )
        ]);
  }
}
