import 'package:flutter/material.dart';
import 'package:origami/screens/post/new_post_screen.dart';
import 'package:origami/services/user_data.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:page_transition/page_transition.dart';
class HomeHelper with ChangeNotifier {

  Widget bottomNavBar(BuildContext context, int index,
      PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: xOrange,
      unSelectedColor: xBlack,
      strokeColor: xBlackAccent,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (value) {
        index = value;
        pageController.jumpToPage(value);
        notifyListeners();
      },
      backgroundColor: xWhite,
      items: [
        CustomNavigationBarItem(icon: const Icon(IconBroken.Home)),
        CustomNavigationBarItem(icon: const Icon(IconBroken.Chat)),
        CustomNavigationBarItem(icon: const Icon(IconBroken.Heart)),
        CustomNavigationBarItem(icon: const Icon(IconBroken.Setting)),
      ],
    );
  }

  Widget floatingActionButton (BuildContext context)=>FloatingActionButton(
    backgroundColor: xSilver,
      elevation: 0.0,
      hoverElevation: 10,
      splashColor: xWhite,
      highlightElevation: 10,
      isExtended: true,
      clipBehavior: Clip.antiAlias,
      child: const Icon(
          IconBroken.Paper_Plus,
          color: xBlack,
          size: 32,
        ),
      onPressed: (){
        Navigator.push(
          context,
          PageTransition(
            child: NewPostScreen(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      });
}