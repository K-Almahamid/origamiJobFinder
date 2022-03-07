import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:origami/screens/alt_profile/alt_profile_helper.dart';
import 'package:origami/screens/chat/chat_helper.dart';
import 'package:origami/screens/feed/feed_helper.dart';
import 'package:origami/screens/login/login_screen.dart';
import 'package:origami/screens/post/post_helper.dart';
import 'package:origami/screens/profile/profile_helpers.dart';
import 'package:origami/screens/search/search_helper.dart';
import 'package:origami/screens/settings/settings_helper.dart';
import 'package:origami/screens/signup/signup_utils.dart';
import 'package:origami/services/authentication.dart';
import 'package:origami/services/firebase_operations.dart';
import 'package:origami/utils/post_options.dart';
import 'package:provider/provider.dart';
import 'package:origami/screens/home/home_helper.dart';
import 'package:origami/screens/login/login_helper.dart';
import 'package:origami/screens/onboarding/onboarding_screen.dart';
import 'package:origami/screens/signup/signup_helper.dart';
import 'package:origami/screens/splash/splash_screen.dart';
import 'package:origami/shared/network/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Widget startScreen;
  bool? onBoard = CacheHelper.getDataFromSharedPreference(key: 'onboard');
  bool? logged = CacheHelper.getDataFromSharedPreference(key: 'Logged');

  if (onBoard != null) {
    if (logged == true) {
      startScreen =  const SplashScreen();
    } else {
      startScreen = LoginScreen();
    }
  } else {
    startScreen = onBoardingScreen();
  }
  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  late final Widget startWidgetScreen;

   MyApp(this.startWidgetScreen);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginHelper()),
        ChangeNotifierProvider(create: (_) => SignUpHelper()),
        ChangeNotifierProvider(create: (_) => SignUpUtils()),
        ChangeNotifierProvider(create: (_) => HomeHelper()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => FireBaseOperations()),
        ChangeNotifierProvider(create: (_) => ProfileHelper()),
        ChangeNotifierProvider(create: (_) => FeedHelper()),
        ChangeNotifierProvider(create: (_) => SettingsHelper()),
        ChangeNotifierProvider(create: (_) => PostHelper()),
        ChangeNotifierProvider(create: (_) => PostOptions()),
        ChangeNotifierProvider(create: (_) => SearchHelper()),
        ChangeNotifierProvider(create: (_) => ChatHelper()),
        ChangeNotifierProvider(create: (_) => AltProfileHelper()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Origami',
        theme: ThemeData(
          fontFamily: 'GideonRoman-Regular',
        ),
        home: startWidgetScreen,
      ),
    );
  }
}
