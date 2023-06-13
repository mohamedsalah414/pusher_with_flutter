import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apiHelper.dart';
import '../auth/log_in/welcome_screen.dart';
import '../home_page/home_page_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var logged = prefs.getString('logged');
    print(logged.toString());

    if (logged != null && logged != 'guest') {
      await AuthApi.newToken(context);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => (logged == null)
            ? const WelcomePage()
            : logged == 'guest'
                ? const WelcomePage()
                : Home(
                    loggedInUser: logged,
                  )));
  }

  late Future<dynamic> futureCheck;

  @override
  initState() {
    super.initState();
    futureCheck = check();
    Timer(const Duration(seconds: 3), () => futureCheck);
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/logo.png'), context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            scale: 0.7,
          ),
        ),
      ),
    );
  }

// checkLoggedIn() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var logged = prefs.getBool('is_logged') ?? false;
//   var firstTime = prefs.getBool('firstTime') ?? true;
//   // SharedPreferences.setMockInitialValues({});

//     if (logged) {
//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (BuildContext context) => const Home()));
//     } else {
//     Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (BuildContext context) => const Login()));
//     }

//   print(logged);
// }
}
