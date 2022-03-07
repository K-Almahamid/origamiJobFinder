import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:origami/shared/network/local/cache_helper.dart';

class UserData {
  String userUid = CacheHelper.getDataFromSharedPreference(key: 'useruid');
  String userName = CacheHelper.getDataFromSharedPreference(key: 'username');
  String userEmail = CacheHelper.getDataFromSharedPreference(key: 'useremail');
  String userImage = CacheHelper.getDataFromSharedPreference(key: 'userimage');
  String userPhone = CacheHelper.getDataFromSharedPreference(key: 'userphone');
  String userCountryLocation =
      CacheHelper.getDataFromSharedPreference(key: 'usercountrylocation');
  String userGovernorateLocation =
      CacheHelper.getDataFromSharedPreference(key: 'usergovernoratelocation');
  String userAreaLocation =
      CacheHelper.getDataFromSharedPreference(key: 'userarealocation');
  String userCV = CacheHelper.getDataFromSharedPreference(key: 'usercv');
}
