import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hera_user/model/chat_room.dart';
import 'package:hera_user/view/chat/chat_test_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:intl/intl.dart';

import '../../api/auth_interceptor.dart';
import '../../utils/api_url.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  Future<ChatRoom> getMessagesFuture() async {
    final client = InterceptedClient.build(
        interceptors: [AuthorizationInterceptor(context)],
        retryPolicy: ExpiredTokenRetryPolicy(context));
    http.Response response;
    response = await client.get(Uri.parse(ApiUrl.baseURL + '/auth/chatRoom'));
    Map<String, dynamic> resposne = jsonDecode(response.body);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var access_token = prefs.getString('access_token');
    // // var id = prefs.getInt('id');
    //
    // var headers = {
    //   'Authorization': 'Bearer ${access_token.toString()}',
    //   'type': 'customer'
    // };
    // var request = http.MultipartRequest(
    //     'GET', Uri.parse(ApiUrl.baseURL + '/auth/chatRoom'));
    //
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    // String resposnee = await response.stream.bytesToString();
    // Map<String, dynamic> resposne = jsonDecode(resposnee);
    print(resposne);
    if (response.statusCode == 200) {
      print(resposne);
    } else {
      print(response.reasonPhrase);
    }
    return ChatRoom.fromJson(resposne);
  }

  late Future<ChatRoom> futureGetChatRoom;

  @override
  void initState() {
    super.initState();
    futureGetChatRoom = getMessagesFuture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Chat Room'),
      ),
      body: FutureBuilder<ChatRoom>(
          future: futureGetChatRoom,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text('Error'),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!.data.response.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: _refreshList,
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Container(
                            child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.data.response.length,
                                itemBuilder: (context, index) {
                                  // var str = snapshot.data!.data.response[index].date;
                                  // var newStr = str.substring(0, 10) +
                                  //     ' ' +
                                  //     str.substring(11, 23);
                                  // DateTime dt = DateTime.parse(newStr);
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatttttTest(
                                                    beautyCenterId: snapshot
                                                        .data!
                                                        .data
                                                        .response[index]
                                                        .id,
                                                  )));
                                    },
                                    title: SizedBox(
                                        width: size.width,
                                        child: Text(
                                          snapshot
                                              .data!.data.response[index].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        )),
                                    subtitle: SizedBox(
                                      width: size.width,
                                      child: Text(
                                        snapshot.data!.data.response[index]
                                            .lastMessage,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    leading: SizedBox.fromSize(
                                      size: Size.square(70),
                                      child: ClipOval(
                                        child: Image.network(
                                          snapshot
                                              .data!.data.response[index].image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, url, error) {
                                            return Image.asset(
                                              'assets/images/prof.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: size.width / 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!.data.response[index]
                                                .date,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            DateFormat.jm().format(
                                                DateFormat("hh:mm").parse(
                                                    snapshot.data!.data
                                                        .response[index].time)),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.grey,
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text('No Chat Room'),
                    );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<void> _refreshList() async {
    final homeList = getMessagesFuture();
    setState(() {
      futureGetChatRoom = homeList;
    });
  }
}
