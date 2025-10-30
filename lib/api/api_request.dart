import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:myhotx/api/msg.dart';

/*
status 0 Fail;
status 1 Success;
status 2 Session Expired;
*/

class ResponseMdl {
  bool isSuccess;
  Map<String, dynamic> data;
  ResponseMdl({this.isSuccess = false, this.data = const {}});
  Map<String, dynamic> toMap() {
    return {'isSuccess': isSuccess, 'data': data};
  }
}

class ApiRequest {
  static ApiRequest inst = ApiRequest();
  http.Client _client = http.Client();
  // dynamic postApiRequest({
  Future<ResponseMdl> postApiRequest({
    String url = '',
    Map payload = const {},
    Map<String, String> header = const {},
  }) async {
    try {
      logInfo(name: 'POST URL', msg: url);
      logInfo(name: 'Payload', msg: jsonEncode(payload));
      /*API REQUEST*/
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: header,
      );
      logInfo(name: "ResponseApi", msg: response.body.toString());
      logInfo(name: "ResponseUrl", msg: url);
      /*CHECK STATUS CODE*/
      if (response.statusCode == 200) {
        logInfo(name: "ResponseData", msg: response.body);
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );
        if (responseMdl.data['success']) {
          return responseMdl;
        } else {
          toastMsg('login failed! Invalid User Name and password..');
        }
        // return response.body.toString();
      }
      if (response.statusCode == 201) {
        logInfo(name: "ResponseData", msg: response.body);
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );
        if (responseMdl.data['success']) {
          return responseMdl;
        } else {
          toastMsg('login failed! Invalid User Name and password..');
        }
        // return response.body.toString();
      } else if (response.statusCode == 401) {
        debugPrint('responseMdl_UNAUTHORISED');
      }
    } on SocketException catch (ex) {
      // toastMsg(muSetText('ServerError', 'Server Error'));
      debugPrint('responseMdl_SocketException $ex');
    } on http.ClientException catch (ex) {
      // toastMsg(muSetText('network_not_available', 'network_not_available'));
      debugPrint('responseMdl_ClientException $ex');
    } catch (ex) {
      debugPrint('responseMdl_EXCEPTION $ex');
    }
    return ResponseMdl();
  }

  Future<ResponseMdl> getApiRequest({
    String url = '',
    Map<String, String> header = const {},
  }) async {
    try {
      logInfo(name: 'GET URL', msg: url);
      /*API REQUEST*/
      final response = await http.get(Uri.parse(url), headers: header);
      logSuccess(name: 'Response', msg: response.body);

      /*CHECK STATUS CODE*/
      if (response.statusCode == 200) {
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );

        if (responseMdl.data['success']) {
          return responseMdl;
        } else {
          toastMsg('Invalid');
        }
        // return response.body.toString();
      } else if (response.statusCode == 401) {
        debugPrint('responseMdl_UNAUTHORISED');
      }
    } on SocketException catch (ex) {
      // toastMsg(muSetText('ServerError', 'Server Error'));
      debugPrint('responseMdl_SocketException $ex');
    } on http.ClientException catch (ex) {
      // toastMsg(muSetText('network_not_available', 'network_not_available'));
      debugPrint('responseMdl_ClientException $ex');
    } catch (ex) {
      debugPrint('responseMdl_EXCEPTION $ex');
    }
    return ResponseMdl();
  }

  Future<ResponseMdl> post({
    required String url,
    required Map payload,
    bool isSuccessMsg = false,
    bool isImageUpload = false,
  }) async {
    logInfo(name: 'POST URL', msg: url);
    try {
      var response = await http.post(Uri.parse(url), body: payload);
      logSuccess(name: 'Response', msg: jsonEncode(response.body));

      // logSuccess(
      //   name: 'ApiRequest/post',
      //   msg: 'Status Code ${response.statusCode}',
      // );
      //  logSuccess(name: 'ApiRequest/post', msg: 'Response ${response.body}');
      if (response.statusCode == 200) {
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );
        if (responseMdl.data['success']) {
          return responseMdl;
        } else {
          toastMsg('login failed! Invalid User Name and password..');
        }
      }
    } on SocketException catch (ex) {
      logError(name: 'ApiRequest/post', msg: '$ex');
      toastMsg('Server error');
    } on http.ClientException catch (ex) {
      logError(name: 'ApiRequest/post', msg: '$ex');
      toastMsg('Network not available');
    } catch (ex) {
      logError(name: 'ApiRequest/post', msg: '$ex');
    }
    return ResponseMdl();
  }

  Future<ResponseMdl> multipart({
    required String url,
    required Map<String, String> payload,
  }) async {
    logInfo(name: 'POST URL', msg: url);
    logInfo(name: 'Payload', msg: jsonEncode(payload));
    var request = http.MultipartRequest('POST', Uri.parse(url));
    payload.forEach((key, value) {
      request.fields[key] = value;
    });
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logSuccess(
        name: 'ApiRequest/multipart',
        msg: 'Status Code ${response.statusCode}',
      );
      logSuccess(
        name: 'ApiRequest/multipart',
        msg: 'Response ${response.body}',
      );
      if (response.statusCode == 200) {
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );
        if (responseMdl.data['Status'].toString().toLowerCase() == 'success' ||
            responseMdl.data['Status'].toString().toLowerCase() == 'sucess') {
          return responseMdl;
        }
      }
    } on SocketException catch (ex) {
      logError(name: 'ApiRequest/multipart', msg: '$ex');
      toastMsg('Server error');
    } on http.ClientException catch (ex) {
      logError(name: 'ApiRequest/multipart', msg: '$ex');
      toastMsg('Network not available');
    } catch (ex) {
      logError(name: 'ApiRequest/multipart', msg: '$ex');
    }
    return ResponseMdl();
  }

  Future<ResponseMdl> postClient({
    required String url,
    Map payload = const {},
    bool isSuccessMsg = false,
  }) async {
    logInfo(name: 'POST URL', msg: url);
    logInfo(name: 'Payload', msg: jsonEncode(payload));
    try {
      _client.close();
    } catch (ex) {
      logError(name: 'ApiRequest/postClient', msg: '$ex');
    } finally {
      _client = http.Client();
    }
    try {
      var response = await _client.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: {"Content-Type": 'application/json'},
      );
      logSuccess(
        name: 'ApiRequest/postClient',
        msg: 'Status Code ${response.statusCode}',
      );
      logSuccess(
        name: 'ApiRequest/postClient',
        msg: 'Response ${response.body}',
      );
      if (response.statusCode == 200) {
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );
        if ((responseMdl.data['Status'] == 1)) {
          if (isSuccessMsg) {
            toastMsg(responseMdl.data['Message']);
          }
          return responseMdl;
        }
        if ((responseMdl.data['Status'] == 0)) {
          toastMsg(responseMdl.data['Message'].toString());
        }
        if ((responseMdl.data['Status'] == 2)) {
          //muOnLogout();
          toastMsg(responseMdl.data['Message'].toString());
        }
      }
    } on SocketException catch (ex) {
      logError(name: 'ApiRequest/postClient', msg: '$ex');
    } on http.ClientException catch (ex) {
      logError(name: 'ApiRequest/postClient', msg: '$ex');
    } catch (ex) {
      logError(name: 'ApiRequest/postClient', msg: '$ex');
    }
    return ResponseMdl();
  }

  Future<ResponseMdl> postWithTokan({
    required String url,
    required Map payload,
    required String tokenKey,
    bool isSuccessMsg = false,
    bool isImageUpload = false,
  }) async {
    logInfo(name: 'POST URL', msg: url);
    if (!isImageUpload) logInfo(name: 'Payload', msg: jsonEncode(payload));
    try {
      var response = await http.post(
        Uri.parse(url),
        body: payload,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenKey',
        },
      );
      logSuccess(
        name: 'ApiRequest/post',
        msg: 'Status Code ${response.statusCode}',
      );
      logSuccess(name: 'ApiRequest/post', msg: 'Response ${response.body}');
      if (response.statusCode == 200) {
        ResponseMdl responseMdl = ResponseMdl(
          isSuccess: true,
          data: jsonDecode(response.body),
        );
        if (responseMdl.data['status'].toString().toLowerCase() == 'success') {
          return responseMdl;
        } else {
          toastMsg('login fail..');
        }
      }
    } on SocketException catch (ex) {
      logError(name: 'ApiRequest/post', msg: '$ex');
      toastMsg('Server error');
    } on http.ClientException catch (ex) {
      logError(name: 'ApiRequest/post', msg: '$ex');
      toastMsg('Network not available');
    } catch (ex) {
      logError(name: 'ApiRequest/post', msg: '$ex');
    }
    return ResponseMdl();
  }
}
