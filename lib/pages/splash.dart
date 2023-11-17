import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';
import 'package:sth/pages/final_page.dart';
import 'package:sth/utils/consts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  List<Sport> sportsList = [
    Sport(name: Consts.news, sportId: Consts.POSTS_PAGE_ID),
    Sport(name: Consts.FEATURED_PROFILES, sportId: Consts.FEATURED_PROFILES_ID),
    Sport(name: Consts.LATEST_PROFILES, sportId: Consts.LATEST_PROFILES_ID),
  ];
  var repo = FuturePreferencesRepository<Sport>(SportDesSer());
  List<Sport> savedSports = [];
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    var list = repo.findAll();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    animation = Tween(begin: 0.0, end: 200.0).animate(animationController);
    // Use this to repeat the animation
    /*
     ..addListener((){

      // setState((){});
     });
     */
    list.then((onValue) {
      for (Sport s in onValue) {
        setState(() {
          savedSports.add(s);
          sportsList.add(s);
        });
      }
      Timer.periodic(const Duration(seconds: 2), (timer) {
        // Remove and replace this page with the new Page ie StartPage
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StartPage(
                      sportsList: sportsList,
                    )));
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
  const LogoAnimation({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: SizedBox(
        height: animation.value,
        width: animation.value,
        child: FittedBox(
          child: Text(
            Consts.appName,
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
