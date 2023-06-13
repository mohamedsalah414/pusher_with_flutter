import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hera_user/utils/app_constants.dart';
import 'package:hera_user/viewModel/authVm.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/api_url.dart';
import 'utils/palette.dart';
import 'view/splash_screen/splash_screen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPusherChat();
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                icon: android.smallIcon,
                ongoing: false,
                styleInformation: const BigTextStyleInformation('')),
          ),
        );
      }
    });

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  initPusherChat() async {
    // if (!_channelFormKey.currentState!.validate()) {
    //   return;
    // }
    // Remove keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      await pusher.init(
        apiKey: 'fa306df2a43609a08a4b',
        cluster: 'eu',
        // authParams: {
        //   'headers': { 'Authorization': 'Bearer ${access_token.toString()}',
        //      'X-CSRF-Token': 'g4HQYeRmhvaG2P5OqnPxXcbEoX9ZiQfs7F9HMHww'
        //   },
        // },

        // onConnectionStateChange: onConnectionStateChange,
        // onError: onError,
        // onSubscriptionSucceeded: onSubscriptionSucceeded,
        // onEvent: onEvent,
        // onSubscriptionError: onSubscriptionError,
        // onDecryptionFailure: onDecryptionFailure,
        // onMemberAdded: onMemberAdded,
        // onMemberRemoved: onMemberRemoved,

        // authEndpoint: "<Your Authendpoint Url>",
        onAuthorizer: onAuthorizer,
        // authEndpoint: 'http://192.168.1.11/IT-Corner/hera/public/api/custom/broadcasting/auth/a'
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var logged = prefs.getBool('is_logged') ?? false;
      print(logged);
      if (logged) {
        await pusher.connect();
      }
      // subscribe();
      // await pusher.subscribe(channelName: _channelName.text);
      // await pusher.connect();
    } catch (e) {
      print(e);
      // log("ERROR: $e");
    }
  }

  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var access_token = prefs.getString('access_token');
    // print(socketId);
    // print(options);
    // print(channelName);
    const storage = FlutterSecureStorage();
    var refreshToken = await storage.read(
        key: 'refresh_token', aOptions: _getAndroidOptions());
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUrl.baseURL + '/custom/broadcasting/auth/a'));
    request.fields.addAll({'socket_id': socketId, 'channel_name': channelName});
    var headers = {'Authorization': '$refreshToken', 'type': 'customer'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String resposnee = await response.stream.bytesToString();
    Map<String, dynamic> resposne = jsonDecode(resposnee);

    print('111111');
    print(json.encode(resposne['channel_data']).toString());
    return {
      "auth": resposne['auth'],
      "channel_data": resposne['channel_data'],
      "shared_secret": "a09d18825dc770711719",
    };
  }

  // void onEvent(PusherEvent event) {
  //  var data = json.decode(event!.data);
  //   print("hi from event ${data['content']}");
  //   print("onEvent: $event");
  // }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthVM(),
          ),
        ],
        child: MaterialApp(
          title: 'Hera',
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white)),
            scaffoldBackgroundColor: AppConstants.xiketik,
            backgroundColor: AppConstants.xiketik,
            primarySwatch: Palette.kPink,
            primaryColor: AppConstants.pastelePink,
            textTheme: TextThemes.darkTextTheme,
          ),
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: AppConstants.black)),
            scaffoldBackgroundColor: AppConstants.snow,
            backgroundColor: AppConstants.snow,
            primarySwatch: Palette.kPink,
            primaryColor: AppConstants.pastelePink,
            textTheme: TextThemes.lightTextTheme,
          ),
          home: const SplashScreen(),
        ));
  }
}
