
import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  String? useruid;
  String? username;
  String? userimage;
  String? useremail;
  String? userbio;
  String? usercountrylocation;
  String? usergovernoratelocation;
  String? userarealocation;
  Timestamp? time;
  String? about;
  String? jobtitle;
  String? firstrequirement;
  String? secondrequirement;
  String? thirdrequirement;
  String? remote;
  String? parttime;
  String? fulltime;
  String? freelance;
  String? contract;
  String? anywhere;
  String? minsalary;
  String? maxsalary;

  Posts(
    this.useruid,
    this.username,
    this.userimage,
    this.useremail,
    this.userbio,
    this.usercountrylocation,
    this.usergovernoratelocation,
    this.userarealocation,
    this.time,
    this.jobtitle,
    this.about,
    this.firstrequirement,
    this.secondrequirement,
    this.thirdrequirement,
    this.remote,
    this.parttime,
    this.fulltime,
    this.freelance,
    this.contract,
    this.anywhere,
    this.minsalary,
    this.maxsalary,
  );

  // formatting for upload to firebase when creating the trip
  Map<String, dynamic> toJson() => {
        'useruid': useruid,
        'username': username,
        'userimage': userimage,
        'useremail': useremail,
        'userbio': userbio,
        'usercountrylocation': usercountrylocation,
        'usergovernoratelocation': usergovernoratelocation,
        'userarealocation': userarealocation,
        'time': time,
        'about': about,
        'jobtitle': jobtitle,
        'firstrequirement': firstrequirement,
        'secondrequirement': secondrequirement,
        'thirdrequirement': thirdrequirement,
        'remote': remote,
        'parttime': parttime,
        'fulltime': fulltime,
        'freelance': freelance,
        'contract': contract,
        'anywhere': anywhere,
        'minsalary': minsalary,
        'maxsalary': maxsalary,
      };

  // creating a posts object from a firebase snapshot
  Posts.fromSnapshot(DocumentSnapshot snapshot)
      : useruid = snapshot['useruid'],
        username = snapshot['username'],
        userimage = snapshot['userimage'],
        useremail = snapshot['useremail'],
        userbio = snapshot['userbio'],
        usercountrylocation = snapshot['usercountrylocation'],
        usergovernoratelocation = snapshot['usergovernoratelocation'],
        userarealocation = snapshot['userarealocation'],
        time = snapshot['time'],
        about = snapshot['about'],
        jobtitle = snapshot['jobtitle'],
        firstrequirement = snapshot['firstrequirement'],
        secondrequirement = snapshot['secondrequirement'],
        thirdrequirement = snapshot['thirdrequirement'],
        remote = snapshot['remote'],
        anywhere = snapshot['anywhere'],
        fulltime = snapshot['fulltime'],
        parttime = snapshot['parttime'],
        contract = snapshot['contract'],
        freelance = snapshot['freelance'],
        minsalary = snapshot['minsalary'],
        maxsalary = snapshot['maxsalary'];
}
