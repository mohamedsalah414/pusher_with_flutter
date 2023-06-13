import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewModel/authVm.dart';
import 'apiHelper.dart';

//IMP http_interceptor and http plugin used for this
// 1 Interceptor class
class AuthorizationInterceptor extends InterceptorContract {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  // We need to intercept request
  BuildContext context;
  AuthorizationInterceptor(this.context);

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var type = prefs.getString('type');
    var accessToken = Provider.of<AuthVM>(context, listen: false).accessToken;
    print('hioiii from interceptRequest');
    print('hioiii from interceptRequest accessToken $accessToken');
    Map<String, String> headers = Map.from(request.headers);
    headers['Authorization'] = accessToken!;
    headers['type'] = 'customer';
    return request.copyWith(headers: headers);
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async =>
      response;

// @override
// Future<bool> shouldInterceptRequest() {
//    var accessToken = Provider.of<AuthVM>(context, listen: false).accessToken;
//    return accessToken==null? true:false;

// }

// @override
// Future<bool> shouldInterceptResponse() {
//   throw UnimplementedError();
// }
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var type = prefs.getString('type');
//     // Fetching token from your locacl data
//     const storage = FlutterSecureStorage();
//     print('hioiii from interceptRequest');

//

//     print('hioiii from interceptRequest accessToken $accessToken');

//     // Clear previous header and update it with updated token
//     request.headers.clear();

//     request.headers['Authorization'] = accessToken!;
//     request.headers['type'] = type!;

//     // data.headers['content-type'] = 'application/json';
//   } catch (e) {
//     print(e);
//   }

//   return request;
// }

// // Currently we do not have any need to intercept response
// @override
// Future<BaseResponse> interceptResponse(
//         {required BaseResponse response}) async =>
//     response;

}

//2 Retry Policy
//This is where request retry
class ExpiredTokenRetryPolicy extends RetryPolicy {
  BuildContext context;
  ExpiredTokenRetryPolicy(this.context);
  //Number of retry
  @override
  int get maxRetryAttempts => 2;
// late BuildContext context;
  @override
  Future<bool> shouldAttemptRetryOnException(
      Exception reason,
      BaseRequest request,
      ) async {
    print(reason.toString());

    return false;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    print('hiiiii shouldAttemptRetryOnResponse');
    //This is where we need to update our token on 401 response
    if (response.statusCode == 401) {
      //Refresh your token here. Make refresh token method where you get new token from
      //API and set it to your local data
      print('hioiii from rerty');
      await AuthApi.newToken( context);
      //Find bellow the code of this function
      return true;
    }
    return false;
  }
}