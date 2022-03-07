import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:origami/models/user.dart';
import 'package:origami/screens/feed/feed_helper.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:provider/provider.dart';


class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  TabController? tabController;

  String? name, image, role, id, countryLocation,email;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 8, vsync: this);
    User user = User.fromJson(
        jsonDecode(CacheHelper.getDataFromSharedPreference(key: 'userdata')));
    name = user.username;
    id = user.useruid;
    image = user.userimage;
    role = user.role;
    email = user.useremail;
    countryLocation = user.usercountrylocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xWhite,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          Provider.of<FeedHelper>(context, listen: true)
              .feedAppbar(context, role!, image!),
        ],
        body: Container(
          margin: const EdgeInsets.only(left: 18.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Provider.of<FeedHelper>(context, listen: true)
                    .feedHeader(context, name!),
                Text(
                  "Nearby jobs",
                  style: kTitleStyle,
                ),
                const SizedBox(height: 15.0),
                Provider.of<FeedHelper>(context, listen: false)
                    .feedNearbyJobs(context, countryLocation!, id!,email!),
                const SizedBox(height: 30.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    labelColor: xBlack,
                    unselectedLabelColor: xGray,
                    physics: const ClampingScrollPhysics(),
                    labelStyle: kSubtitleStyle,
                    indicatorColor: xOrange,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: const EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    tabs: const [
                      Tab(text: 'Recent'),
                      Tab(text: 'Nearby'),
                      Tab(text: 'Remote'),
                      Tab(text: 'anywhere'),
                      Tab(text: 'freelance'),
                      Tab(text: 'contract'),
                      Tab(text: 'parttime'),
                      Tab(text: 'fulltime'),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedRecentJobs(context, id,email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedNearbyJobs(context, countryLocation!, id!,email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedJobs(context, id!, 'remote', 'Remote',email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedJobs(context, id!, 'anywhere', 'Anywhere',email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedJobs(context, id!, 'freelance', 'Freelance',email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedJobs(context, id!, 'contract', 'Contract',email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedJobs(context, id!, 'parttime', 'Part Time',email!),
                      Provider.of<FeedHelper>(context, listen: false)
                          .feedJobs(context, id!, 'fulltime', 'Full Time',email!),
                    ],
                  ),
                ),
                const SizedBox(height: 35.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
