import 'package:flutter/material.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:origami/shared/styles/icon_broken.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: xWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: xSilver,
        elevation: 3.0,
        shadowColor: xOrange,
        title:const Text(
          'Origami',
          style: TextStyle(
            color: xOrange,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ephesis-Regular',
          ),
        ),
        leading: GestureDetector(
          child: const Icon(IconBroken.Arrow___Left_Circle,
              color: xBlack, size: 30),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 25, right: 25, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text('About Origami', style: kPageTitleStyle),
              ),
              Text(
                'Origami it is an application that helps you find a job faster than the usual method by filling in your data, including the location, where the application filters jobs based on the entered location and thus ensures that you find jobs nearby and also filters jobs in terms of remotely anywhere contract freelance, full-time or part-time.',
                style: kTitleStyle.copyWith(height: 1.2,letterSpacing: 1.1,fontSize: 19),
              ),
          const SizedBox(height: 40),
          SizedBox(
            height: size.height / 5,
            width: size.width,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Contact Information',style: kSubtitleStyle.copyWith(color: xGray)),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0,left: 10,right: 10),
                      child: Row(
                        children: [
                          const Icon(IconBroken.Message,color: xOrange,size: 20),
                          const SizedBox(width: 5),
                          Text('Email : ',style: kTitleStyle),
                          Text('korigamiii@gmail.com',style: kTitleStyle.copyWith(color: xGray,textBaseline: TextBaseline.ideographic)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0,left: 10,right: 10),
                      child: Row(
                        children: [
                          const Icon(IconBroken.Call,color: xOrange,size: 20),
                          const SizedBox(width: 5),
                          Text('Phone : ',style: kTitleStyle),
                          Text('0785604150',style: kTitleStyle.copyWith(color: xGray,textBaseline: TextBaseline.ideographic)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
            ],
          ),
        ),
      ),
    );
  }
}
