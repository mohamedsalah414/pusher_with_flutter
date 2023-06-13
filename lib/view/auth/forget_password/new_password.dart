import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/api_url.dart';
import '../../../../../utils/app_constants.dart';

class NewPassword extends StatefulWidget {
    final String type,email;

  const NewPassword({Key? key, required this.type, required this.email}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool _isObscure = true;
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
         
            child: ListView(
              children: [
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: const Text('New Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                                         // color: AppConstants.cornflowerBlue3,

                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                const Text(
                  'Enter your new password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                                   // color: AppConstants.cornflowerBlue3,

                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [AutofillHints.email],
                  autofocus: false,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          // color: AppConstants.cornflowerBlue3,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    labelText: 'New Password',
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 54, 53, 53),
                        fontWeight: FontWeight.w900),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(163, 62, 249, 1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(163, 62, 249, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: () {
                  
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 115, 52, 170),
                    ),
                    child: const Text('Send',
                        style: TextStyle(
                            color: Color.fromARGB(255, 233, 224, 224),
                            fontSize: 17)),
                  ),
                )
              ],
            ),
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
