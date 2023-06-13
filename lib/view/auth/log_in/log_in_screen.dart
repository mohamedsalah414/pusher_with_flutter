import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/app_constants.dart';
import '../../../utils/api_url.dart';
import '../../../viewModel/authVm.dart';
import '../../home_page/home_page_screen.dart';
import '../../widget/text_utils.dart';
import '../forget_password/forget_password_screen.dart';
import '../sign_up/sign_up_screen.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _passwordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();

    _passwordcontroller.dispose();

    super.dispose();
  }

  late FirebaseMessaging messaging;
  String devicetoken = "";

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    // sharedPreferencesName: 'Test2',
    // preferencesKeyPrefix: 'Test'
  );
  final storage = const FlutterSecureStorage();
  final _accountNameController =
  TextEditingController(text: 'flutter_secure_storage_service');
  String? _getAccountName() =>
      _accountNameController.text.isEmpty ? null : _accountNameController.text;
  IOSOptions _getIOSOptions() => IOSOptions(
    accountName: _getAccountName(),
  );
  Future<void> login() async {
    messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((value) {
      devicetoken = value!;
      print(devicetoken);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      'email': _emailcontroller.text,
      'password': _passwordcontroller.text,
      'type': 'customer',
      'device_token': devicetoken,
      'isRemembered': rememberMe ? '1' : '0',

    };
    print(data);

    var response = await http.post(
      Uri.parse(ApiUrl.login),
      body: ({
        'email': _emailcontroller.text,
        'password': _passwordcontroller.text,
        'type': 'customer',
        'device_token': devicetoken,
        'isRemembered': rememberMe ? '1' : '0',

      }),
    );

    // final  body = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      // await prefs.setString('token',data['remember_token']);
      await storage.write(
        key: 'refresh_token',
        value: 'Bearer ${body['refresh_token']}',
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      var refreshToken = await storage.read(
          key: 'refresh_token', aOptions: _getAndroidOptions());
      debugPrint('lol $refreshToken');

      Provider.of<AuthVM>(context, listen: false)
          .setAccessToken('Bearer ${body['access_token']}');
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      await pusher.connect();
      // prefs.setString("token",
      //     'token');
      prefs.setString("logged",'user');
      // prefs.setString("access_token",body['access_token']);
      prefs.setString("device_token", devicetoken.toString());
      prefs.setString('name', body['users']['name']);
      prefs.setInt('id', body['users']['id']);
      prefs.setString('email', body['users']['email']);
      prefs.setBool('is_logged', true);


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home(loggedInUser: 'user',)),
              (Route<dynamic> route) => false);
      print('success');
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['error'].toString()),
        backgroundColor: Colors.red,
      ));

      print('error');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error'),
        backgroundColor: Colors.red,
      ));
    }
  }
  // Future<void> login() async {
  //   // messaging = FirebaseMessaging.instance;
  //   // await messaging.getToken().then((value) {
  //   //   devicetoken = value!;
  //   //   print(devicetoken);
  //   // });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   FirebaseMessaging messaging;
  //   messaging = FirebaseMessaging.instance;
  //   String token = "";
  //
  //   await messaging.getToken().then((value) {
  //     token = value!;
  //     print('firebase token is : ' + token);
  //   });
  //   final data = {
  //     'email': _emailcontroller.text,
  //     'password': _passwordcontroller.text,
  //     'type': widget.type,
  //     'device_token': token,
  //     'isRemembered': '0',
  //   };
  //   print(data);
  //
  //   var response = await http.post(
  //     Uri.parse(ApiUrl.baseUrl + '/auth/login'),
  //     body: ({
  //       'email': _emailcontroller.text,
  //       'password': _passwordcontroller.text,
  //       'type': widget.type,
  //       'device_token': token,
  //       'isRemembered': rememberMe ? '1' : '0',
  //     }),
  //   );
  //
  //   // final  body = json.decode(response.body);
  //   print(response.body);
  //   print(response.statusCode);
  //   var body = json.decode(response.body);
  //   if (response.statusCode == 200) {
  //     // await prefs.setString('token',data['remember_token']);
  //
  //     // prefs.setString("token",
  //     //     'token');
  //
  //     // prefs.setString("access_token", 'Bearer ${body['access_token']}');
  //     await storage.write(
  //       key: 'refresh_token',
  //       value: 'Bearer ${body['refresh_token']}',
  //       aOptions: _getAndroidOptions(),
  //       iOptions: _getIOSOptions(),
  //     );
  //     var refreshToken = await storage.read(
  //         key: 'refresh_token', aOptions: _getAndroidOptions());
  //     debugPrint('lol $refreshToken');
  //
  //     Provider.of<AuthVM>(context, listen: false)
  //         .setAccessToken('Bearer ${body['access_token']}');
  //     prefs.setString("device_token", devicetoken.toString());
  //     prefs.setBool('is_logged', true);
  //
  //     prefs.setString("type", widget.type.toString());
  //     prefs.setString('name', body['users']['name']);
  //     prefs.setInt('id', body['users']['id']);
  //     prefs.setString('email', body['users']['email']);
  //
  //     if (widget.type == 'gym') {
  //       if (body['users']['isAdmin'] == 1) {
  //         prefs.setString('type', 'admin');
  //       } else {
  //         prefs.setInt('mainBranchId', body['users']['main_branch_id']);
  //       }
  //     }
  //     body['users']['isAdmin'] == 1
  //         ? prefs.setString("access_token", 'Bearer ${body['access_token']}')
  //         : null;
  //
  //     PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  //     pusher.connect();
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => body['users']['isAdmin'] == 1
  //               ? const HomeAdminNavigator()
  //               : widget.type == 'user'
  //               ? const HomeNavigatorUser()
  //               : widget.type == 'gym'
  //               ? const HomeNavigatorGym()
  //               : const HomeNavigatorTrainer(),
  //         ),
  //             (Route<dynamic> route) => false);
  //     print('success');
  //   } else if (response.statusCode == 401) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(body['error'].toString()),
  //       backgroundColor: Colors.red,
  //     ));
  //
  //     print('error');
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Error'),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.rose,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 80, bottom: 60),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: const [
                  //     TextUtils(
                  //       text: 'Welcome',
                  //       fontSize: 35,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black,
                  //     ),
                  //     TextUtils(
                  //       text: 'Back',
                  //       fontSize: 35,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black,
                  //     ),
                  //     SizedBox(
                  //       height: 15,
                  //     ),
                  //
                  //   ],
                  //
                  // ),
                  SvgPicture.asset(
                    'assets/images/undraw_handcrafts_welcome.svg',
                    fit: BoxFit.cover,
                    width: 200,
                  )
                ],
              ),

              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      validator: (value) => value!.isEmpty
                          ? 'enter a valid email or Phone'
                          : null,
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Email or Phone',
                        // hintText: 'Enter your email or phone',
                        // Here is key idea
                        labelStyle: const TextStyle(
                          decorationColor: AppConstants.black,
                          fontSize: 16,
                          color: AppConstants.black,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _passwordcontroller,
                      obscureText: !_passwordVisible,
                      validator: (value) =>
                          value!.isEmpty ? 'enter a valid password' : null,
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Password',
                        // hintText: 'Enter your password',
                        // Here is key idea
                        labelStyle: const TextStyle(
                          decorationColor: AppConstants.black,
                          fontSize: 16,
                          color: AppConstants.black,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppConstants.black,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CheckboxListTile(
                  title: TextUtils(text: 'Remember me'),
                  value: rememberMe,
                  onChanged: (val) {
                    setState(() {
                      setState(() {
                        rememberMe = val!;
                      });
                    });
                  }),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordPage(type: 'customer',)));
                },
                child: const TextUtils(
                    text: 'Forgot password?',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  child: const Text('Log in'),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      login();
                      // login(_emailcontroller.text.toString(),
                      //     _passwordcontroller.text.toString());
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // SizedBox(
              //   width: size.width,
              //   child: ElevatedButton(
              //     child: const Text('Continue as a guest'),
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const Home()));
              //     },
              //   ),
              // ),
              SizedBox(
                height: size.height / 8,
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextUtils(
                          text: 'Don\'t have an account? ',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: const TextUtils(
                          text: 'Sign Up ',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
