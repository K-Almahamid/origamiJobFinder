import 'package:flutter/material.dart';
import 'package:origami/screens/login/login_screen.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/network/local/cache_helper.dart';
import 'package:origami/shared/styles/icon_broken.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHelper with ChangeNotifier{


  logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade100,
          title: Center(
              child: Column(
                children: [
                  Text('Sign Out ?', style: kPageTitleStyle),
                ],
              )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    onSurface: Colors.orangeAccent,
                    side: const BorderSide(
                      color: xGray,
                    ),
                    elevation: 55,
                  ),
                  label: Text(
                    'Cancel',
                    style: kTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  icon: const Icon(
                    IconBroken.Close_Square,
                    color: xGray,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: xOrange,
                    primary: Colors.white,
                    onSurface: Colors.orangeAccent,
                    side: const BorderSide(
                      color: xOrange,
                    ),
                    elevation: 55,
                  ),
                  label: Text(
                    'Yes',
                    style: kTitleStyle.copyWith(color: xWhite),
                    textAlign: TextAlign.center,
                  ),
                  icon: const Icon(
                    IconBroken.Logout,
                    color: xWhite,
                    size: 20,
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutViaEmail()
                        .whenComplete(
                          () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: LoginScreen(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                    ).whenComplete(() {
                       SharedPreferences? sharedPreferences;
                      // sharedPreferences!.remove('userdata');
                      CacheHelper.putDataInSharedPreference(
                          value: false, key: 'Logged');
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}