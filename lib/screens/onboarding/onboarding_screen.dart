import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/screens/login/login_screen.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';


class onBoardingScreen extends StatefulWidget {
  @override
  _onBoardingScreenState createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  final PageController pageController = PageController();
  int page = 0;
  List<String> titles = [
    'Find Your Dream Job!',
    'Find Your Dream Job!',
    'Find Your Dream Job!'
  ];
  List<String> subTitles = [
'One place with the best jobs companies in tech. Apply to all of them with a single profile and get in touch with hiring managers directly.',
    'Find your dream job between more than 1million job offers from clint all around the world',
'We help you to find your dream job according to your skill set, location & preference to buid your career'
  ];
  List<String> imagesURl = [
    'assets/animations/border1.json',
    'assets/animations/border2.json',
    'assets/animations/border3.json',
  ];

  void nexPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      setState(() {
        page = pageController.page!.round();
      });
    });
    return Scaffold(
      backgroundColor: xSilver,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => onBoardingPage(
                  context,
                  imagesURl[index],
                  titles[index],
                  subTitles[index],
                ),
                itemCount: titles.length,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 20.0),
                GestureDetector(
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: xBlack,
                    ),
                  ),
                  onTap: () {
                    onSubmitSkipOnBoard();
                  },
                ),
                const Spacer(),
                pageArrow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column onBoardingPage(
    BuildContext context,
    String imageUrl,
    String title,
    String subTitle,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            width: MediaQuery.of(context).size.width,
            child: Lottie.asset(imageUrl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 240.0,
                child: Text(
                  title,
                  maxLines: 2,
                  style:kPageTitleStyle
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                subTitle,
                style: kSubtitleStyle.copyWith(fontSize: 18,wordSpacing: 2,letterSpacing: 1.5,),
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
      ],
    );
  }

  SizedBox pageArrow() {
    return SizedBox(
      height: 75.0,
      width: 75.0,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 60.0,
              width: 60.0,
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(xOrange),
                value: (page + 1) / (titles.length ),
              ),
            ),
          ),
          GestureDetector(
            child: Center(
              child: SizedBox(
                height: 70.0,
                width: 70.0,
                child: page != titles.length - 1
                    ? const Icon(
                        IconBroken.Arrow___Right_Circle,
                        size: 50,
                        color: xBlack,
                      )
                    : Lottie.asset(
                        'assets/animations/borderCheck.json'),
              ),
            ),
            onTap: () {
              if (page < titles.length -1 && page != titles.length) {
                pageController.animateToPage(
                  page+1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInCirc,
                );
              } else {
                onSubmitSkipOnBoard();
              }
            },
          )
        ],
      ),
    );
  }

  void onSubmitSkipOnBoard(){
    // save in the shared prefs that on boarding finished.
    CacheHelper.putDataInSharedPreference(value: true, key: 'onboard')
        .then((value) {
      if(value) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: LoginScreen(),
            type: PageTransitionType.leftToRight,
          ),
        );
      }
    });

  }
}
