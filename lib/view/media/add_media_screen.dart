import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api_url.dart';
import '../../utils/app_constants.dart';

class AddMedia extends StatefulWidget {
  final type;
  final typeScreen;
  final int beautyCenterId;

  const AddMedia(this.type, this.typeScreen, this.beautyCenterId);

  @override
  State<AddMedia> createState() => _AddMediaState(this.type, this.typeScreen);
}

class _AddMediaState extends State<AddMedia> {
  _AddMediaState(this.type, typeScreen);
  var typeScreen;
  var _image;
  var imagePicker;
  var type;
  var path;
  int customerId = 0;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    type = widget.typeScreen;
    print(typeScreen);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.pink,
        // title: Text(type == ImageSource.camera ? " Camera" : " Gallery")
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: GestureDetector(
            onTap: () async {
              print('tapped');
              var source = type == ImageSource.camera
                  ? ImageSource.camera
                  : ImageSource.gallery;
              XFile image;

              // imageOrvideo == 'image'
              //     ?
              image = await imagePicker.pickImage(
                  source: source,
                  imageQuality: 50,
                  preferredCameraDevice: CameraDevice.front);
              //     : image = await imagePicker.pickVideo(
              //   source: source,
              // );
              setState(() {
                print('pathhhhhh' + image.path);
                path = image.path;
                _image = File(image.path);
              });
            },
            child: _image != null
                ? SizedBox(
                    height: size.height - 100,
                    width: size.width,
                    child: Image.file(
                      _image,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 50),
                    child: CircleAvatar(
                      backgroundColor: AppConstants.pink,
                      radius: 100,
                      child: Icon(
                        type == ImageSource.camera
                            ? Icons.camera_alt
                            : Icons.photo_library,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (path != null) {
            await widget.typeScreen == 'chat'
                ? sendMessage(path)
                : uploadImage(path);
          } else {
            // Flushbar(
            //   backgroundColor: Colors.black,
            //   message: 'Please Pick Image first',
            //   icon: const Icon(
            //     Icons.error_outline,
            //     size: 28.0,
            //     color: Color.fromRGBO(163, 62, 249, 1),
            //   ),
            //   duration: Duration(seconds: 3),
            //   leftBarIndicatorColor: Color.fromRGBO(163, 62, 249, 1),
            // ).show(context);
          }
          // Navigator.pop(context);
        },
        child:
            Icon(widget.typeScreen == 'chat' ? Icons.send : Icons.file_upload),
      ),
    );
  }

  Future<void> sendMessage(path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var access_token = prefs.getString('access_token');
    // var id = prefs.getInt('id');
    customerId = prefs.getInt('id') ?? 0;

    var headers = {'Authorization': 'Bearer ${access_token.toString()}'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            ApiUrl.baseURL + '/auth/chat/${widget.beautyCenterId.toString()}'));
    request.fields.addAll({
      'type': 'customer',
      'content_type': 'image',
      'channel_name':
          'presence-${widget.beautyCenterId.toString()}${customerId.toString()}'
    });
    request.files
        .add(await http.MultipartFile.fromPath('contentMessage', path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String resposnee = await response.stream.bytesToString();
    Map<String, dynamic> resposne = jsonDecode(resposnee);
    if (response.statusCode == 200) {
      Navigator.pop(context);

      print(response);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> uploadImage(path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var access_token = prefs.getString('access_token');
    // var id = prefs.getInt('id');

    var headers = {
      'type': 'customer',
      'Authorization': 'Bearer ${access_token.toString()}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUrl.baseURL + '/auth/uploadImage'));

    request.files.add(await http.MultipartFile.fromPath('image', path));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String resposnee = await response.stream.bytesToString();
    Map<String, dynamic> resposne = jsonDecode(resposnee);
    if (response.statusCode == 200) {
      Navigator.pop(context);

      print(response);
    } else {
      print(response.reasonPhrase);
    }
  }
}
