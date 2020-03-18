import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';
import 'package:sth/pages/final_page.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  List<Sport> sportsList = [
    Sport(name: Consts.NEWS, sportId: '000111000'),
    Sport(name: Consts.FEATURED_PROFILES, sportId: '11001'),
    Sport(name: Consts.LATEST_PROFILES, sportId: "11002"),
  ];
  var repo = new FuturePreferencesRepository<Sport>(new SportDesSer());
  List<Sport> savedSports = new List();
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    var list = repo.findAll();
    animationController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    animation = Tween(begin: 0.0, end: 200.0).animate(animationController);
    // Use this to repeat the animation
    /*
     ..addListener((){

      // setState((){});
     });
     */
    list.then((onValue) {
      for (Sport s in onValue) {
        print(s.name);
        setState(() {
          savedSports.add(s);
          sportsList.add(s);
        });
      }
      new Timer.periodic(Duration(seconds: 2), (timer) {
      
         AppUtils(context: context).goBack();
         AppUtils(context: context).gotoPage(page: StartPage(sportsList: sportsList,));
        // Navigator.replace(context,
        //     oldRoute: MaterialPageRoute(
        //         builder: (BuildContext context) => SplashPage()),
        //     newRoute: MaterialPageRoute(
        //         builder: (BuildContext context) => StartPage(
        //               sportsList: sportsList,
        //             )));
         timer.cancel();
      });
       
    });
    //
    //Checking the status of the animation and do some work
    // make sure to put it before calling forward on animationController
    //
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: LogoAnimation(
          animation: animation,
        ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class LogoAnimation extends AnimatedWidget {
  LogoAnimation({Key key, Animation animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Center(
      child: Container(
        height: animation.value,
        width: animation.value,
        child: FittedBox(
          child: Text(
            Consts.APP_NAME,
            style: TextStyle(
              color: Colors.red,
              fontSize: animation.value,
            ),
          ),
        ),
      ),
    );
  }
}
