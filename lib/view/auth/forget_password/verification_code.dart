import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/api_url.dart';
import '../../../../../utils/app_constants.dart';
// import 'newPassword_screen.dart';

class Verification extends StatefulWidget {
  final String type, email;

  const Verification({Key? key, required this.type, required this.email})
      : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";
  var onTapRecognizer;
  StreamController<ErrorAnimationType> errorController = StreamController();

  bool hasError = false;
  String currentText = "";
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }


  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.7),
                      BlendMode.modulate,
                    ),
                    image: AssetImage('images/model.jpg'),
                    fit: BoxFit.cover)),
            child: ListView(children: [
              SizedBox(
                height: 80,
              ),
              Center(
                child: const Text('Verification',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,

                    )),
              ),
              SizedBox(
                height: 50,
              ),
              const Text(
                'Enter the verification code we just sent you on your email address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                length: 5,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    // activeFillColor: AppConstants.wildBlueYonder,
                    inactiveColor: Color.fromARGB(148, 206, 197, 197),
                    inactiveFillColor: Color.fromARGB(148, 206, 197, 197),
                    activeColor: Colors.transparent),
                animationDuration: Duration(milliseconds: 300),
                //backgroundColor: Colors.blue.shade50,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                onCompleted: (v) async {
                  print("Completed");
                 
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context,
              ),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  // color: AppConstants.cornflowerBlue3,
                )),
          ),
        ],
      ),
    );
  }

 
}
