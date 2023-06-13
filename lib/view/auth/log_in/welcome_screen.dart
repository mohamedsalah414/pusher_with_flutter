import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../Utils/app_constants.dart';
import '../../home_page/home_page_screen.dart';
import 'log_in_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CarouselController _controller = CarouselController();

  Future<void> setGuest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("city", _chosenCity.toString());
    prefs.setString("logged", 'guest');
  }
  Future<void> setCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("city", _chosenCity.toString());
  }

  var _chosenCity;
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.rose,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCarouselSlider(size),
            Container(
              padding: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: AppConstants.black),
                    borderRadius: BorderRadius.circular(15)),
                height: 65,
                width: size.width,
                child: DropdownButton<String>(
                  alignment: Alignment.bottomCenter,
                  dropdownColor: AppConstants.pink,
                  elevation: 0,

                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: AppConstants.black),
                  underline: Container(
                    height: 0,
                    width: 0,
                    color: Colors.transparent,
                  ),

                  isExpanded: true,
                  value: _chosenCity,
                  //elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  items: AppConstants.city
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.black,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select City",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _chosenCity = value!;
                      print(_chosenCity);
                    });
                  },
                ),
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                child: const Text(
                  'Continue as a guest',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  primary: AppConstants.copperRose,
                ),
                onPressed: () {
                  if (_chosenCity != null) {
                    setGuest();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Home(loggedInUser: 'guest',)));
                  } else {
                    showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message: "Please select a city",
                        ));
                  }

                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => const Home()));
                },
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                child: const Text('Log In',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                ),
                onPressed: () {
                  if (_chosenCity != null) {
                    setCity();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInPage()));
                  } else {
                    showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message: "Please select a city",
                        ));
                  }

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const LogInPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(size) {
    return Stack(
      children: [
        CarouselSlider.builder(
          // itemCount: snapshot.data!.directors.length,
          itemCount: AppConstants.welcomeImages.length,
          options: CarouselOptions(
            height: size.height / 2,
            enlargeCenterPage: false,
            initialPage: _current,
            autoPlay: false,
            reverse: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),

          itemBuilder: (context, i, id) {
            return Container(
              width: size.width,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: size.width,
                        child: Image.network(
                          AppConstants.welcomeImages[i],
                          width: size.width,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: size.width,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Image.asset(
                                'assets/images/prof.png',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AppConstants.welcomeImages.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Colors.white)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
