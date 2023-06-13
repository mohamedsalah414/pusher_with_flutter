import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/app_constants.dart';
import '../../../utils/api_url.dart';
import '../../widget/text_utils.dart';
import '../log_in/log_in_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _namecontroller.dispose();

    _emailcontroller.dispose();

    _phonecontroller.dispose();

    _passwordcontroller.dispose();

    super.dispose();
  }
  late FirebaseMessaging messaging;
  String devicetoken = "";
  bool checkBoxValue = false;
  Future<void> register() async {
    messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((value) {
      devicetoken = value!;
      print(devicetoken);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var city = prefs.getString('city');
    final data = {
      'type': 'customer',
      'name': _namecontroller.text,
      'password': _passwordcontroller.text,
      'phone': _phonecontroller.text,
      'email': _emailcontroller.text,
      'address': city.toString(),
      'device_token': devicetoken,

    };
    print(data);

    // String body = json.encode(data);
      var response = await http.post(
        Uri.parse(ApiUrl.register),
        body: (data),
      );
      var body = json.decode(response.body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LogInPage()));
        print('success');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(body['msg'].toString()),
          backgroundColor: Colors.red,
        ));
        print('error');
      }

  }
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
                      keyboardType: TextInputType.name,
                      controller: _namecontroller,
                      validator: (value) => value!.isEmpty
                          ? 'enter a valid name'
                          : null,
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      validator: (value) => value!.isEmpty
                          ? 'enter a valid email'
                          : null,
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                      keyboardType: TextInputType.phone,
                      controller: _phonecontroller,
                      validator: (value) =>
                          value!.isEmpty ? 'enter a valid Phone' : null,
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Phone',
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
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      register();
                      // login(_emailcontroller.text.toString(),
                      //     _passwordcontroller.text.toString());
                    }
                  },
                ),
              ),
              SizedBox(
                height: size.height / 8,
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextUtils(
                          text: 'Have an account? ',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogInPage()));
                        },
                        child: const TextUtils(
                          text: 'Log In ',
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
