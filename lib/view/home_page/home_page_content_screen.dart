import 'dart:async';
import 'dart:convert';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/app_constants.dart';
import '../../api/auth_interceptor.dart';
import '../../model/home_page.dart';
import '../../model/queue.dart';
import '../../utils/api_url.dart';
import '../widget/text_utils.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final bool _viewed = true;
  final bool _shaked = true;

  bool _reservedTime = false;
  List<Map<String, dynamic>> queuese = [];

  bool _onPressedReserved = false;
  late String loggedInUser;

  Future<Response> getHomePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUser = prefs.getString('logged').toString();
    });
    final client = InterceptedClient.build(
        interceptors: [AuthorizationInterceptor(context)],
        retryPolicy: ExpiredTokenRetryPolicy(context));
    http.Response response;
    response = await client.get(
      Uri.parse(ApiUrl.baseURL + '/customer/home'),
    );
    Map<String, dynamic> resposne = jsonDecode(response.body);
    // var access_token = prefs.getString('access_token');
    // var customerId = prefs.getInt('id');
    //
    // print('Accessssss $access_token');
    // var request = http.MultipartRequest(
    //     'GET', Uri.parse(ApiUrl.baseURL + '/customer/home'));
    // var headers = {'Authorization': 'Bearer ${access_token.toString()}'};
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    // String resposnee = await response.stream.bytesToString();
    // Map<String, dynamic> resposne = jsonDecode(resposnee);
    print(response.statusCode);
    print(resposne);

    if (response.statusCode == 200) {
      print(resposne);
    } else {
      print(resposne);
    }
    return Response.fromJson(resposne['data']['response']);
  }

  Stream<Queue> getQueue = (() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var access_token = prefs.getString('access_token');
    // var id = prefs.getInt('id');
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    const storage = FlutterSecureStorage();
    var refreshToken = await storage.read(
        key: 'refresh_token', aOptions: _getAndroidOptions());
    yield* Stream.periodic(const Duration(seconds: 10), (_) async {
      var headers = {
        'Authorization': '${refreshToken}',
      };
      var request = http.MultipartRequest(
          'GET', Uri.parse(ApiUrl.baseURL + '/customer/getOrderNumber'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resposnee = await response.stream.bytesToString();
      Map<String, dynamic> resposne = jsonDecode(resposnee);
      print(resposne);
      if (response.statusCode == 200) {
        // var len = resposne['data']['response'];
        //
        // for (int i = 0; i < len.length; i++) {
        //   DateTime time = DateTime.parse(len[i]['time']);
        //   time.isAfter(len[i+1]['time']) ? time = len[i]['time'] : time = len[i+1]['time'];
        //   print('time is '+time.toString());
        // }
        // _listViewMessageController
        //        .jumpTo(_listViewMessageController.position.maxScrollExtent);
        // Timer(
        //     const Duration(milliseconds: 1000),
        //     () => );
        // _listViewMessageController
        //     .jumpTo(_listViewMessageController.position.maxScrollExtent);
        print(resposne);
      } else {
        print(response.reasonPhrase);
      }
      // setState(() {
      //   // _listViewMessageController.animateTo(
      //   //     _listViewMessageController.position.maxScrollExtent,
      //   //     duration: Duration(milliseconds: 100),
      //   //     curve: Curves.ease);
      //   // firstTime = false;
      // });
      return Queue.fromJson(resposne);
    }).asyncMap((event) async => await event);
  })();

  late Future<Response> futureHomePage;

  // late Stream<Queue> futureGetQueue;
  // futureGetQueue = getQueue();

  @override
  initState() {
    super.initState();
    futureHomePage = getHomePage();
  }

  @override
  Widget build(BuildContext context) {
    OverlayEntry overlayEntry;

    Size size = MediaQuery.of(context).size;
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _shaked != _shaked;
      });
    });
    return Scaffold(
      // backgroundColor: AppConstants.snow,
      body: Stack(
        children: [
          FutureBuilder<Response>(
              future: futureHomePage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loggedInUser == 'user'
                            ? StreamBuilder<Queue>(
                                stream: getQueue,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot
                                        .data!.data.response.isNotEmpty) {
                                      var dt =
                                          snapshot.data!.data.response[0].time;
                                      // print('dt '+dt);
                                      // DateTime dateTime = DateTime.parse(dt);
                                      // print('dateTime '+dateTime.toString());
                                      DateTime time =
                                          DateFormat('HH:mm').parse(dt);
                                      var timet =
                                          DateFormat('hh:mm a').format(time);
                                      // var now = DateTime.now();
                                      // print('time '+time.toString());
                                      // setState(() {
                                      //   _reservedTime = time.difference(DateTime.now()) <= Duration(minutes: 30) ? false : true;
                                      // });
                                      snapshot.data!.data.response[0].active ==
                                              0
                                          ? _reservedTime = false
                                          : _reservedTime = true;
                                      return Visibility(
                                        visible: _reservedTime &&
                                            _onPressedReserved == true,
                                        child: Center(
                                          child: GestureDetector(
                                            // onTap: () {
                                            //   setState(() {
                                            //     _onPressedReserved = true;
                                            //   });
                                            // },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  width: size.width * 0.7,
                                                  height: size.height * 0.15,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: AppConstants.rose,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      // Opacity(
                                                      //   opacity: 0.15,
                                                      //   child: Image.asset(
                                                      //     'assets/images/alert.png',
                                                      //     fit: BoxFit.cover,
                                                      //     scale: 1,
                                                      //     alignment: Alignment.center,
                                                      //     colorBlendMode: BlendMode.modulate,
                                                      //   ),
                                                      // ),
                                                      Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const TextUtils(
                                                              text:
                                                                  'Today\'s Queue',
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              // color:
                                                              // AppConstants
                                                              //     .black,
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                                timet
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  // color: AppConstants
                                                                  //     .black
                                                                )),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                                'Queue: ' +
                                                                    snapshot
                                                                        .data!
                                                                        .data
                                                                        .response[
                                                                            0]
                                                                        .waitingNumber
                                                                        .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  // color: AppConstants
                                                                  //     .black
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 15,
                                                  left: -40,
                                                  child: Opacity(
                                                    opacity: 1,
                                                    child: Image.asset(
                                                      'assets/images/alert.png',
                                                      fit: BoxFit.cover,
                                                      scale: 1.7,
                                                      alignment:
                                                          Alignment.center,
                                                      colorBlendMode:
                                                          BlendMode.modulate,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  }
                                  if (snapshot.hasError) {
                                    print(snapshot.error.toString());
                                    return const Center(child: Text('Error'));
                                  }

                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                })
                            : SizedBox(),
                        _buildOffer(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextUtils(
                              text: 'Top Rated',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              // color: AppConstants.black
                            ),

                            // TextButton(
                            //   onPressed: () {
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //         builder: (context) =>
                            //     //         const Schedule()));
                            //   },
                            //   child: const TextUtils(
                            //     text: 'See all >',
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.topRated.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // padding: EdgeInsets.all(15),
                                          height: 130,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2.5,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              snapshot
                                                  .data!.topRated[index].image,
                                              fit: BoxFit.cover,
                                              scale: 1,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/prof.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data!.topRated[index].name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            // color: AppConstants.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!.topRated[index].rate,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                // color: AppConstants.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: Text(
                                            snapshot
                                                .data!.topRated[index].address,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              // color: AppConstants.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        // const Text(
                                        //   '\$\$\$',
                                        //   textAlign: TextAlign.center,
                                        //   style: TextStyle(
                                        //     color: AppConstants.black,
                                        //     fontWeight: FontWeight.w400,
                                        //     fontSize: 18,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            TextUtils(
                              text: 'Best Offers',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              // color: AppConstants.black
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) =>
                            //             const OfferPage()));
                            //   },
                            //   child: const TextUtils(
                            //     text: 'See all >',
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.bestOffers.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // padding: EdgeInsets.all(15),
                                          height: 160,
                                          width: 240,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2.5,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              snapshot.data!.bestOffers[index]
                                                  .image,
                                              fit: BoxFit.cover,
                                              scale: 1,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/prof.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: Text(
                                            snapshot
                                                .data!.bestOffers[index].name,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              // color: AppConstants.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: Text(
                                            '${snapshot.data!.bestOffers[index].percent.toInt()} %',
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              // color: AppConstants.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        loggedInUser == 'user'
                            ? Visibility(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextUtils(
                                        text: 'Recently Viewed',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.black),
                                    SizedBox(
                                      height: 250,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: AppConstants
                                              .BeautyCenterName.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: GestureDetector(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      // padding: EdgeInsets.all(15),
                                                      height: 130,
                                                      width: 180,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              AppConstants
                                                                      .AdImage[
                                                                  index]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2.5,
                                                            blurRadius: 5,
                                                            offset: const Offset(
                                                                0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      AppConstants
                                                              .BeautyCenterName[
                                                          index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        // color: AppConstants.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'rate',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // color: AppConstants.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'location',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // color: AppConstants.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const Text(
                                                      '\$\$\$',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // color: AppConstants.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {},
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                visible: _viewed,
                              )
                            : SizedBox(),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error'));
                }
                return const Center(child: const CircularProgressIndicator());
              }),
          // Positioned(child: ElevatedButton(onPressed: (){},child: Text(''),),bottom: 2,),
          Align(
            child: ElevatedButton(
              onPressed: () {},
              child: ShakeAnimatedWidget(
                enabled: _shaked,
                duration: const Duration(milliseconds: 300),
                shakeAngle: Rotation.deg(z: 7),
                curve: Curves.linear,
                child: Image.asset(
                  'assets/images/makeup.png',
                  fit: BoxFit.cover,
                  scale: 9,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: AppConstants.pastelePink,
              ),
            ),
            alignment: AlignmentDirectional.centerEnd,
          ),
          Visibility(
              visible: _reservedTime && _onPressedReserved == false,
              child: GestureDetector(
                child: Overlay(
                  initialEntries: [
                    overlayEntry = OverlayEntry(
                      builder: (context) {
                        return Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: size.height,
                            width: size.width,
                            color: Colors.black.withOpacity(.9),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onPressedReserved = true;
                                  });
                                },
                                child: Center(
                                  child: GestureDetector(
                                    // onTap: () {
                                    //   setState(() {
                                    //     _onPressedReserved = true;
                                    //   });
                                    // },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: size.width * 0.7,
                                          height: size.height * 0.15,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppConstants.rose,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            children: [
                                              // Opacity(
                                              //   opacity: 0.15,
                                              //   child: Image.asset(
                                              //     'assets/images/alert.png',
                                              //     fit: BoxFit.cover,
                                              //     scale: 1,
                                              //     alignment: Alignment.center,
                                              //     colorBlendMode: BlendMode.modulate,
                                              //   ),
                                              // ),
                                              Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const [
                                                    TextUtils(
                                                      text:
                                                          'Be Attention!\n your turn after 15 minutes',
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      align: TextAlign.center,
                                                      // color: AppConstants.black,
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 15,
                                          left: -40,
                                          child: Opacity(
                                            opacity: 1,
                                            child: Image.asset(
                                              'assets/images/alert.png',
                                              fit: BoxFit.cover,
                                              scale: 1.7,
                                              alignment: Alignment.center,
                                              colorBlendMode:
                                                  BlendMode.modulate,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _onPressedReserved = true;
                    // overlayEntry.remove();
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _buildOffer() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: AppConstants.BeautyCenterName.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                child: Container(
                  // padding: EdgeInsets.all(15),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(AppConstants.AdImage[index]),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2.5,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Text(
                        AppConstants.BeautyCenterName[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      )),
                ),
                onTap: () {},
              ),
            );
          }),
    );
  }
}
