import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hera_user/view/chat/test_lazy_view.dart';
import 'package:hera_user/view/media/add_media_screen.dart';
import 'package:hera_user/view/widget/text_utils.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../Utils/app_constants.dart';
import '../../api/auth_interceptor.dart';
import '../../model/chat_model.dart';
import '../../utils/api_url.dart';

class ChatttttTest extends StatefulWidget {
  ChatttttTest({Key? key, required this.beautyCenterId}) : super(key: key);
  final int beautyCenterId;

  @override
  State<ChatttttTest> createState() => _ChatttttTestState();
}

class _ChatttttTestState extends State<ChatttttTest> {
   late int customerId;
  bool initPusher = false;
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final TextEditingController _chatController = TextEditingController();

  String _logCustomer = '';
  String _logBeautyCenter = '';
  final _apiKey = TextEditingController();
  final _cluster = TextEditingController();
  final _channelName = TextEditingController();
  final _eventName = TextEditingController();
  final _channelFormKey = GlobalKey<FormState>();
  final _eventFormKey = GlobalKey<FormState>();

  // final _listViewController = ScrollController();
  final ScrollController _listViewMessageController = ScrollController();
  final _data = TextEditingController();
  bool firstTime = true;

  bool subscription = false;

  late int customerIdd;


  Future<void> getCustomerId() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('id')??1;
    setState(() {
      customerIdd = customerId;
    });

  }
  // bool _firstAutoscrollExecuted = false;
  // bool _shouldAutoscroll = false;
  // void _scrollListener() {
  //    _firstAutoscrollExecuted = true;
  //
  //   if (_listViewMessageController.hasClients && _listViewMessageController.position.pixels == _listViewMessageController.position.maxScrollExtent) {
  //     _shouldAutoscroll = true;
  //     _scrollToBottom();
  //   } else {
  //     _shouldAutoscroll = false;
  //   }
  // }
  // void _scrollToBottom() {
  //   _listViewMessageController.jumpTo(_listViewMessageController.position.maxScrollExtent);
  // }
  void logCustomer(String text) {
    print("LOG: $text");
    setState(() {
      _logCustomer += text + "\n";
      // Timer(
      //     const Duration(milliseconds: 100),
      //     () => _listViewController
      //         .jumpTo(_listViewController.position.maxScrollExtent));
    });
  }

  void logBeautyCenter(String text) {
    print("LOG: $text");
    setState(() {
      _logBeautyCenter += text + "\n";
      // Timer(
      //     const Duration(milliseconds: 100),
      //     () => _listViewController
      //         .jumpTo(_listViewController.position.maxScrollExtent));
    });
  }

  // Stream<http.Response> getMessageStream() async* {
  //   yield* Stream.periodic(Duration(seconds: 5), (_) {
  //     return http.get(Uri.parse("http://numbersapi.com/random/"));
  //   }).asyncMap((event) async => await event);
  // }
  var lengthOfList;


  Future<MessageData> getMessagesFuture(int num) async {
    // showDialog(
    //   barrierColor: Colors.transparent,
    //   context:context,
    //   // barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
    final client = InterceptedClient.build(
        interceptors: [AuthorizationInterceptor(context)],
        retryPolicy: ExpiredTokenRetryPolicy(context));
    http.Response response;
    response = await client.post(
        Uri.parse(ApiUrl.baseURL + '/auth/getChat/${widget.beautyCenterId.toString()}'),
      params: {'numOfPage': num.toString(), 'numOfRows': '10'}
    );
    Map<String, dynamic> resposne = jsonDecode(response.body);
    // print('hi from msggg futureee $num');
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var access_token = prefs.getString('access_token');
    // // var id = prefs.getInt('id');
    //
    // var headers = {
    //   'Authorization': 'Bearer ${access_token.toString()}',
    //   'type': 'customer'
    // };
    // var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         ApiUrl.baseURL + '/auth/getChat/${widget.beautyCenterId.toString()}'));
    // request.fields.addAll({'numOfPage': num.toString(), 'numOfRows': '10'});
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    // String resposnee = await response.stream.bytesToString();
    // Map<String, dynamic> resposne = jsonDecode(resposnee);
    print(resposne);
    if (response.statusCode == 200) {
      var len = resposne['data']['response']['messages'];
      lengthOfList = resposne['data']['response']['length'];

      for (int i = 0; i < len.length; i++) {
        msgFuture.add(len[i]['content']);
        contentTypeFuture.add(len[i]['content_type']);
        senderTypeFuture.add(len[i]['sender_type']);
      }

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
    // Navigator.pop(context);
    return MessageData.fromJson(resposne);
  }

  // Stream<MessageData> getMessages() async* {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var access_token = prefs.getString('access_token');
  //   // var id = prefs.getInt('id');
  //
  //   var headers = {
  //     'Authorization': 'Bearer ${access_token.toString()}',
  //     'type': 'customer'
  //   };
  //   var request = http.MultipartRequest(
  //       'GET', Uri.parse(ApiUrl.baseURL + '/auth/chat/2'));
  //
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   String resposnee = await response.stream.bytesToString();
  //   Map<String, dynamic> resposne = jsonDecode(resposnee);
  //   print(resposne);
  //   if (response.statusCode == 200) {
  //     // _listViewMessageController
  //     //        .jumpTo(_listViewMessageController.position.maxScrollExtent);
  //     // Timer(
  //     //     const Duration(milliseconds: 1000),
  //     //     () => );
  //     // _listViewMessageController
  //     //     .jumpTo(_listViewMessageController.position.maxScrollExtent);
  //     print(resposne);
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  //   yield* Stream.periodic(Duration(milliseconds: 1000), (_) {
  //     setState(() {
  //       _listViewMessageController.animateTo(
  //           _listViewMessageController.position.maxScrollExtent,
  //           duration: Duration(milliseconds: 100),
  //           curve: Curves.ease);
  //       firstTime = false;
  //     });
  //     return MessageData.fromJson(resposne);
  //   }).asyncMap((event) async => await event);
  // }

  Future<void> sendMessage(String txt, String type) async {
    final client = InterceptedClient.build(
        interceptors: [AuthorizationInterceptor(context)],
        retryPolicy: ExpiredTokenRetryPolicy(context));
    http.Response response;
    response = await client.post(
        Uri.parse(ApiUrl.baseURL + '/auth/chat/${widget.beautyCenterId.toString()}'),
        params: {
          'contentMessage': txt,
          'type': 'customer',
          'content_type': type,
          'channel_name':
          'presence-${widget.beautyCenterId.toString()}${customerIdd.toString()}'
        }
    );
    Map<String, dynamic> resposne = jsonDecode(response.body);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var access_token = prefs.getString('access_token');
    // // var id = prefs.getInt('id');
    //
    // var headers = {'Authorization': 'Bearer ${access_token.toString()}'};
    // var request = http.MultipartRequest('POST',
    //     Uri.parse(ApiUrl.baseURL + '/auth/chat/${widget.beautyCenterId.toString()}'));
    // request.fields.addAll({
    //   'contentMessage': txt,
    //   'type': 'customer',
    //   'content_type': type,
    //   'channel_name':
    //       'presence-${widget.beautyCenterId.toString()}${customerIdd.toString()}'
    // });
    //
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    // String resposnee = await response.stream.bytesToString();
    // Map<String, dynamic> resposne = jsonDecode(resposnee);
    if (response.statusCode == 200) {
      setState(() {
        // _listViewMessageController.animateTo(
        //     _listViewMessageController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 100),
        //     curve: Curves.ease);
        _chatController.clear();
      });

      print(response);
    } else {
      print(response.reasonPhrase);
    }
  }

  late Future<MessageData> futureMessage;

  @override
  void initState() {
    super.initState();
    // _loadMore();
    // initPusher ==false ? initPlatformState(): subscribe();
    // subscribe();
    getCustomerId();
    futureMessage = getMessagesFuture(currentLength);
    initPlatformState();

    // _listViewMessageController.addListener(() {
    //   if (_listViewMessageController.position.maxScrollExtent ==
    //       _listViewMessageController.position.pixels) {
    //     print('firing');
    //   }
    // });
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   if (_listViewMessageController.hasClients) {
    //     _listViewMessageController.jumpTo(
    //         _listViewMessageController.position.minScrollExtent);
    //       // _listViewMessageController.position.maxScrollExtent,
    //       // curve: Curves.easeOut,
    //       // duration: const Duration(milliseconds: 500),
    //     // );
    //   }
    // });
    // _listViewMessageController.addListener(_scrollListener);
    // onEvent;
    // onEvent();
    // onEvent();

    // onConnectPressed();
  }

  // void initPusherChat() async {
  //   // if (!_channelFormKey.currentState!.validate()) {
  //   //   return;
  //   // }
  //   // Remove keyboard
  //   FocusScope.of(context).requestFocus(FocusNode());
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("apiKey", '244e53a24ee9b32e63c0');
  //   prefs.setString("cluster", 'eu');
  //   prefs.setString("channelName", '21');
  //
  //   try {
  //     setState(() {
  //       initPusher = true;
  //     });
  //
  //     await pusher.init(
  //       apiKey: '244e53a24ee9b32e63c0',
  //       cluster:'eu',
  //       onConnectionStateChange: onConnectionStateChange,
  //       // onError: onError,
  //       // onSubscriptionSucceeded: onSubscriptionSucceeded,
  //       onEvent: onEvent,
  //       // onSubscriptionError: onSubscriptionError,
  //       // onDecryptionFailure: onDecryptionFailure,
  //       // onMemberAdded: onMemberAdded,
  //       // onMemberRemoved: onMemberRemoved,
  //
  //       // authEndpoint: "<Your Authendpoint Url>",
  //       // onAuthorizer: onAuthorizer
  //     );
  //     subscribe();
  //     // await pusher.subscribe(channelName: _channelName.text);
  //     // await pusher.connect();
  //   } catch (e) {
  //     log("ERROR: $e");
  //   }
  // }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
     // print("Connection: $currentState");
  }

  // PusherEvent? event;
  void unsubscribe() async {
    await pusher.unsubscribe(

        channelName:
            'presence-${widget.beautyCenterId.toString()}${customerIdd.toString()}');
    // channelName: '${beautyCenterId.toString()}${customerId.toString()}');

    // channelName: 'presence-21');
    // await pusher.disconnect();
  }

  var senderType;
  var data;
  List<String> msgCustomer = [];
  List<String> contentType = [];
  List<String> indexx = [];

  List<String> msgFuture = [];
  List<String> contentTypeFuture = [];
  List<String> senderTypeFuture = [];

  Future<void> subscribe() async {
    // _listViewMessageController.animateTo(
    //     _listViewMessageController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 100),
    //     curve: Curves.ease);
    // await pusher.connect();

    await pusher.subscribe(

        // onMemberAdded: onMemberAdded,
       onSubscriptionSucceeded: (event){
         // subscription = true;
        print("subscription success");
        // print(event);
       },
        channelName:
            'presence-${widget.beautyCenterId.toString()}${customerIdd.toString()}',
        // channelName: 'presence-21',
        // channelName: '${beautyCenterId.toString()}${customerId.toString()}',
        onEvent: (event) {
          data = json.decode(event!.data);
          data['sender_type'] == 'customer'
              ? logCustomer("${data['content']}")
              : logBeautyCenter("${data['content']}");
          setState(() {
            // data['sender_type'] == 'customer'
            //     ? print('customer length of list before ${msgCustomer.length}')
            //     : print(
            //         'beauty center length of list before ${msgBeautyCenter.length}');
            senderType = data['sender_type'];
            // data['sender_type'] == 'customer'? msgCustomer.add(data['content']):msgBeautyCenter.add(data['content']);
            msgCustomer.add(data['content']);
            contentType.add(data['content_type']);
            // data['sender_type'] == 'customer'
            //     ? print('customer length of list after ${msgCustomer.length}')
            //     : print(
            //         'beauty center length of list after ${msgBeautyCenter.length}');
            indexx.add(senderType);
          });

          print("Got channel event: $data");
        });



    // onEvent();
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    // log("onEvent: $event");
  }

  // void onEvent(PusherEvent event) {
  //   pusher.onEvent!(event);
  //   var data = json.decode(event!.data);
  //  print("hi from event from chat test ${data['content']}");
  //  setState(() {
  //    log("onEvent: ${data['content']}");
  //
  //  });
  //   print("onEvent: $event");
  // }

  // Future<MessageData> onEvent() async{
  //   pusher.onEvent!(event!);
  //   var data = json.decode(event!.data);
  //
  //   //
  //   print("hi from event ${data['content']}");
  //   return MessageData.fromJson(data);
  // }
  void onSubscriptionSucceeded(String channelName, dynamic data) {

    print("onSubscriptionSucceeded: $channelName data: ${data.toString()}");
    final me = pusher.getChannel(channelName)?.me;
    print("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    // log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    // log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName member: ${member.toString()}");
    // log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    // log("onMemberRemoved: $channelName user: $member");
  }

  // dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
  //   return {
  //     "auth": "foo:bar",
  //     "channel_data": '{"user_id": 1}',
  //     "shared_secret": "foobar"
  //   };
  // }

  void onTriggerEventPressed() async {
    var eventFormValidated = _eventFormKey.currentState!.validate();

    if (!eventFormValidated) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("eventName", _eventName.text);
    prefs.setString("data", _data.text);
    pusher.trigger(PusherEvent(
        channelName: _channelName.text,
        eventName: _eventName.text,
        data: _data.text));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // initPusher ==false ? initPusherChat(): subscribe();
      subscribe();
      // onEvent;
      _apiKey.text = prefs.getString("apiKey") ?? '244e53a24ee9b32e63c0';
      _cluster.text = prefs.getString("cluster") ?? 'eu';
      _channelName.text = prefs.getString("channelName") ?? 'presence-21';
      _eventName.text = prefs.getString("eventName") ?? 'client-event';
      _data.text = prefs.getString("data") ?? 'test';
    });
  }

  bool isLoading = false;
  int currentLength = 1;
  final int increment = 10;

  Future _loadMore(/*int length*/) async {
    setState(() {
      isLoading = true;
    });

    // Add in an artificial delay
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    setState(() {
      futureMessage = getMessagesFuture(currentLength+1);
      // for (var i = currentLength; i <= 3; i++) {
      //   // currentLength++;
      //
      //   print('increment is ${i}');
      //   // data.add(i);
      // }
    });

    setState(() {
      print('lengthOfList ${lengthOfList ~/ 10}');
      print('currentLength ${currentLength}');
      if (currentLength <= lengthOfList ~/ 10) {
        isLoading = false;
        // if (lengthOfList % currentLength == 0) {
        //   isLoading = true;
        // }
        // if (lengthOfList % currentLength == 0) {
        //   isLoading = true;
        // }

        currentLength++;
      }
      // currentLength = length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        unsubscribe();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: currentLength > 1,
          child: FloatingActionButton(
            onPressed: () {
              _listViewMessageController.animateTo(
                _listViewMessageController.position.minScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
              setState(() {
                // isLoading = false;
                // currentLength = 1;
                // msgCustomer.clear();
                // msgFuture.clear();
                // futureMessage = getMessagesFuture(currentLength);
              });
            },
            mini: true,
            backgroundColor: Colors.white,
            elevation: 2,
            tooltip: 'Increment',
            child: Icon(
              Icons.arrow_downward,
              color: Colors.black,

            ),
          ),
        ),
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            pusher.connectionState == 'DISCONNECTED'
                ? 'DISCONNECTED'
                : 'CONNECTED',
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // msgCustomer.clear();
              // msgFuture.clear();
              unsubscribe();

            },
            icon: const Icon(Icons.arrow_back),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => TestLazyView(),
          //         ),
          //       );
          //     },
          //     icon: const Icon(CupertinoIcons.text_badge_star),
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LazyLoadScrollView(
            isLoading: isLoading,
            onEndOfPage: () => _loadMore(),
            child: ListView(
                reverse: true,
                controller: _listViewMessageController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                    ListView.builder(
                                // controller: _listViewMessageController,
                                reverse: false,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(5),
                                itemCount: indexx.length,
                                itemBuilder: (context, index) {
                                  print('index ${indexx[index]}');
                                  print('length ${msgCustomer.length}');
                                  print('sender type is $senderType');
                                  return Container(
                                      margin: indexx[index] == 'customer'
                                          ? EdgeInsets.only(
                                              left: 100, right: 10, top: 20)
                                          : EdgeInsets.only(
                                              left: 10, right: 100, top: 20),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: indexx[index] == 'customer'
                                            ? Colors.indigo.shade100
                                            : Colors.indigo.shade50,
                                        borderRadius: indexx[index] == 'customer'
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(30),
                                              )
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                                bottomRight: Radius.circular(30),
                                              ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // TextUtils(
                                          //     text: indexx[index]  ==
                                          //         'customer'
                                          //         ? 'customer'
                                          //         : 'beauty center'),
                                          contentType[index] == 'text'
                                              ? TextUtils(
                                                  text: msgCustomer[index],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                )
                                              : SizedBox(
                                                  height: 200,
                                                  child: Center(
                                                    child: Image.network(
                                                      msgCustomer[index],
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context, error,
                                                          stackTrace) {
                                                        return Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Image.asset(
                                                            'assets/images/prof.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ));
                                }),
                  FutureBuilder<MessageData>(
                      future: futureMessage,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                // controller: _listViewMessageController,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(5),
                                itemCount: msgFuture.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: senderTypeFuture[index] == 'customer'
                                        ? EdgeInsets.only(
                                            left: 100, right: 10, top: 20)
                                        : EdgeInsets.only(
                                            left: 10, right: 100, top: 20),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: senderTypeFuture[index] == 'customer'
                                          ? Colors.indigo.shade100
                                          : Colors.indigo.shade50,
                                      borderRadius: senderTypeFuture[index] ==
                                              'customer'
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                            )
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                    ),
                                    child: contentTypeFuture[index] == 'text'
                                        ? TextUtils(
                                            text: msgFuture[index],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          )
                                        : SizedBox(
                                            height: 200,
                                            child: Image.network(
                                              msgFuture[index],
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle),
                                                  child: Image.asset(
                                                    'assets/images/prof.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  );
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      })

                  // if (pusher.connectionState != 'CONNECTED')
                  // Form(
                  //     key: _channelFormKey,
                  //     child: Column(children: [
                  //       // TextFormField(
                  //       //   controller: _apiKey,
                  //       //   validator: (String? value) {
                  //       //     return (value != null && value.isEmpty)
                  //       //         ? 'Please enter your API key.'
                  //       //         : null;
                  //       //   },
                  //       //   decoration:
                  //       //   const InputDecoration(labelText: 'API Key'),
                  //       // ),
                  //       // TextFormField(
                  //       //   controller: _cluster,
                  //       //   validator: (String? value) {
                  //       //     return (value != null && value.isEmpty)
                  //       //         ? 'Please enter your cluster.'
                  //       //         : null;
                  //       //   },
                  //       //   decoration: const InputDecoration(
                  //       //     labelText: 'Cluster',
                  //       //   ),
                  //       // ),
                  //       // TextFormField(
                  //       //   controller: _channelName,
                  //       //   validator: (String? value) {
                  //       //     return (value != null && value.isEmpty)
                  //       //         ? 'Please enter your channel name.'
                  //       //         : null;
                  //       //   },
                  //       //   decoration: const InputDecoration(
                  //       //     labelText: 'Channel',
                  //       //   ),
                  //       // ),
                  //       // ElevatedButton(
                  //       //   onPressed: onConnectPressed,
                  //       //   child: const Text('Connect'),
                  //       // )
                  //     ])),
                  // else
                  //   Form(
                  //     key: _eventFormKey,
                  //     child: Column(children: <Widget>[
                  //       ListView.builder(
                  //           scrollDirection: Axis.vertical,
                  //           shrinkWrap: true,
                  //           itemCount: pusher
                  //               .channels[_channelName.text]?.members.length,
                  //           itemBuilder: (context, index) {
                  //             final member = pusher
                  //                 .channels[_channelName.text]!.members
                  //                 .elementAt(index);
                  //             return ListTile(
                  //                 title: Text(member.userInfo.toString()),
                  //                 subtitle: Text(member.userId));
                  //           }),
                  //       TextFormField(
                  //         controller: _eventName,
                  //         validator: (String? value) {
                  //           return (value != null && value.isEmpty)
                  //               ? 'Please enter your event name.'
                  //               : null;
                  //         },
                  //         decoration: const InputDecoration(
                  //           labelText: 'Event',
                  //         ),
                  //       ),
                  //       TextFormField(
                  //         controller: _data,
                  //         decoration: const InputDecoration(
                  //           labelText: 'Data',
                  //         ),
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: onTriggerEventPressed,
                  //         child: const Text('Trigger Event'),
                  //       ),
                  //     ]),
                  //   ),
                  // FutureBuilder<MessageData>(
                  //     future: futureMessage,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasError) {
                  //         print(snapshot.error);
                  //         return Center(
                  //             child: TextUtils(text: '${snapshot.error}'));
                  //       }
                  //       if (snapshot.hasData) {
                  //         return snapshot.data!.data.response.isNotEmpty
                  //             ? ListView.builder(
                  //                 // controller: _listViewMessageController,
                  //                 reverse: true,
                  //                 physics: const NeverScrollableScrollPhysics(),
                  //                 shrinkWrap: true,
                  //                 padding: const EdgeInsets.all(5),
                  //                 itemCount: snapshot.data!.data.response.length,
                  //                 itemBuilder: (context, index) {
                  //                   return Container(
                  //                       margin: snapshot.data!.data
                  //                                   .response[index].senderType ==
                  //                               'customer'
                  //                           ? EdgeInsets.only(
                  //                               left: 100, right: 10, top: 20)
                  //                           : EdgeInsets.only(
                  //                               left: 10, right: 100, top: 20),
                  //                       padding: const EdgeInsets.all(20),
                  //                       decoration: BoxDecoration(
                  //                         color: snapshot
                  //                                     .data!
                  //                                     .data
                  //                                     .response[index]
                  //                                     .senderType ==
                  //                                 'customer'
                  //                             ? Colors.indigo.shade100
                  //                             : Colors.indigo.shade50,
                  //                         borderRadius: snapshot
                  //                                     .data!
                  //                                     .data
                  //                                     .response[index]
                  //                                     .senderType ==
                  //                                 'customer'
                  //                             ? const BorderRadius.only(
                  //                                 topLeft: Radius.circular(30),
                  //                                 topRight: Radius.circular(30),
                  //                                 bottomLeft: Radius.circular(30),
                  //                               )
                  //                             : const BorderRadius.only(
                  //                                 topLeft: Radius.circular(30),
                  //                                 topRight: Radius.circular(30),
                  //                                 bottomRight:
                  //                                     Radius.circular(30),
                  //                               ),
                  //                       ),
                  //                       child: TextUtils(
                  //                           text: snapshot.data!.data
                  //                               .response[index].content));
                  //                 })
                  //             : const TextUtils(text: 'No Data');
                  //       }
                  //       return Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }),
                  // ListView.builder(
                  //     controller: _listViewMessageController,
                  //     reverse: true,
                  //     physics: const AlwaysScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     padding: const EdgeInsets.all(5),
                  //     itemCount: senderType ==
                  //         'customer'? _logCustomer.length : _logCustomer.length,
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //           margin: senderType ==
                  //               'customer'
                  //               ? EdgeInsets.only(
                  //               left: 100, right: 10, top: 20)
                  //               : EdgeInsets.only(
                  //               left: 10, right: 100, top: 20),
                  //           padding: const EdgeInsets.all(20),
                  //           decoration: BoxDecoration(
                  //             color: senderType ==
                  //                 'customer'
                  //                 ? Colors.indigo.shade100
                  //                 : Colors.indigo.shade50,
                  //             borderRadius: senderType ==
                  //                 'customer'
                  //                 ? const BorderRadius.only(
                  //               topLeft: Radius.circular(30),
                  //               topRight: Radius.circular(30),
                  //               bottomLeft: Radius.circular(30),
                  //             )
                  //                 : const BorderRadius.only(
                  //               topLeft: Radius.circular(30),
                  //               topRight: Radius.circular(30),
                  //               bottomRight:
                  //               Radius.circular(30),
                  //             ),
                  //           ),
                  //           child: TextUtils(
                  //               text: senderType ==
                  //                   'customer'
                  //                   ?_logCustomer:_logBeautyCenter,
                  //
                  //           ));
                  //       // return SizedBox(
                  //       //   child: Column(
                  //       //     children: [
                  //       //       Text(
                  //       //         _logCustomer,
                  //       //         style: const TextStyle(
                  //       //             fontSize: 25, fontWeight: FontWeight.bold,color: Colors.red),
                  //       //       ),
                  //       //       Text(
                  //       //         _logBeautyCenter,
                  //       //         style: const TextStyle(
                  //       //             fontSize: 25, fontWeight: FontWeight.bold,color: Colors.green),
                  //       //       ),
                  //       //     ],
                  //       //   ),
                  //       // );
                  //     }),
                ]),
          ),
        ),
        bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: Container(
            color: Colors.white,
            // padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: Form(
              child: TextFormField(
                controller: _chatController,
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppConstants.pastelePink,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddMedia(
                                              ImageSource.gallery, 'chat',widget.beautyCenterId)));
                                  // setState(() {
                                  //   // sendMessage(_chatController.text, 'image');
                                  //
                                  //   // futureMessage = getMessagesFuture();
                                  // });
                                },
                                icon: const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundColor: AppConstants.pastelePink,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    sendMessage(_chatController.text, 'text');
                                    // futureMessage = getMessagesFuture();
                                  });
                                },
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    fillColor: Colors.blueGrey[50],
                    hintText: 'Type a message',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(25),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
