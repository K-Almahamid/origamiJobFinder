

class User {
  String useruid;
  String role;
  String username;
  String useremail;
  String userimage;
  String userphone;
  String usercv;
  String userbio;
  String usercountrylocation;
  String usergovernoratelocation;
  String userarealocation;

  User(
    this.useruid,
    this.role,
    this.username,
    this.useremail,
    this.userimage,
    this.userphone,
    this.usercv,
    this.userbio,
    this.usercountrylocation,
    this.usergovernoratelocation,
    this.userarealocation,
  );

  User.fromJson(Map<String, dynamic> json)
      : useruid = json['useruid'],
        role = json['role'],
        username = json['username'],
        useremail = json['useremail'],
        userimage = json['userimage'],
        userphone = json['userphone'],
        usercv = json['usercv'],
        userbio = json['userbio'],
        usercountrylocation = json['usercountrylocation'],
        usergovernoratelocation = json['usergovernoratelocation'],
        userarealocation = json['userarealocation'];

  // formatting for upload to firebase when creating the trip
  Map<String, dynamic> toJson() => {
        'useruid': useruid,
        'role': role,
        'username': username,
        'useremail': useremail,
        'userphone': userphone,
        'userimage': userimage,
        'userbio': userbio,
        'usercv': usercv,
        'usercountrylocation': usercountrylocation,
        'usergovernoratelocation': usergovernoratelocation,
        'userarealocation': userarealocation,
      };

// creating a user object
// User.data()
//     : useruid = CacheHelper.getDataFromSharedPreference(key: 'useruid'),
//       role = CacheHelper.getDataFromSharedPreference(key: 'role'),
//       username = CacheHelper.getDataFromSharedPreference(key: 'username'),
//       useremail = CacheHelper.getDataFromSharedPreference(key: 'useremail'),
//       userimage = CacheHelper.getDataFromSharedPreference(key: 'userimage'),
//       userphone = CacheHelper.getDataFromSharedPreference(key: 'userphone'),
//       userbio = CacheHelper.getDataFromSharedPreference(key: 'userbio'),
//       usercv = CacheHelper.getDataFromSharedPreference(key: 'usercv'),
//       usercountrylocation =
//           CacheHelper.getDataFromSharedPreference(key: 'usercountrylocation'),
//       usergovernoratelocation = CacheHelper.getDataFromSharedPreference(
//           key: 'usergovernoratelocation'),
//       userarealocation =
//           CacheHelper.getDataFromSharedPreference(key: 'userarealocation');
}
