import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../../../../utils/app_constants.dart';
import '../../widget/text_utils.dart';

class ForgetPasswordPage extends StatefulWidget {
  final String type;

  const ForgetPasswordPage({Key? key, required this.type}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: TextUtils(
        text: 'Forget password',
      )),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 60),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailcontroller,
                    validator: (value) =>
                        value!.isEmpty ? 'enter a valid email' : null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    //This will obscure text dynamically
                    decoration: InputDecoration(
                      labelText: 'Email',
                      // hintText: 'Enter your email or phone',
                      // Here is key idea
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: const TextStyle(
                        // decorationColor: AppConstants.raisinBlack,
                        fontSize: 16,
                        // color: AppConstants.raisinBlack,
                        fontWeight: FontWeight.bold,
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
            Center(
              child: SizedBox(
                width: size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                  child: const TextUtils(
                      text: 'Forgot Password',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      print('presseddd');

                      // login();
                      // login(_emailcontroller.text.toString(),
                      //     _passwordcontroller.text.toString());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
