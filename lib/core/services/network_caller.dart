import 'dart:convert';
import 'dart:ui';
import 'package:crafty_bay/features/auth/presentation/providers/auth_controller.dart';
import 'package:http/http.dart';
import 'package:logger/web.dart';
part '../models/network_response.dart';

class NetworkCaller {

  final Logger _logger = Logger();


  final VoidCallback onUnauthorize;
  final Map<String, String>? headers;


  NetworkCaller({this.headers, required this.onUnauthorize});

  Future<NetworkResponse> getRequest({required String url,required String errMsg}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url);

      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        if (AuthController.accessToken != null &&
            AuthController.accessToken!.isNotEmpty)
          'token': '${AuthController.accessToken}',
      };

      print(AuthController.accessToken);
      Response response = await get(
        uri,
        headers: requestHeaders,
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      // Response response = await get(uri, headers: headers);

      _logResponse(url, response);

      // final int statusCode = response.statusCode;

      if (statusCode == 200) {
        //success
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData[errMsg],
        );
      } else if (statusCode == 401) {
        onUnauthorize();
        return NetworkResponse(
            isSuccess: false,
            responseCode: statusCode,
            responseData: null,
            errorMessage: 'Un-authorize'
        );
      }
      else {
        //failed
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['msg'],//TODO: Propose a solution to make this component independent
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }


  Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body, required String errMsg}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body: body);

      Response response = await post(uri,headers:headers ??{
        'content-type': 'application/json',
      },
        body: jsonEncode(body),
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        //success
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else if (statusCode == 401) {
        onUnauthorize();
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: false,
            responseCode: statusCode,
            responseData: null,
          errorMessage: decodedData[errMsg],
        );
      }
      else {
        //failed
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['msg'],
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }


  Future<NetworkResponse> patchRequest({required String url, Map<String, dynamic>? body, required String errMsg}) async{
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body: body);

      Response response = await patch(uri,headers:headers ??{
        'content-type': 'application/json',
        'token': AuthController.accessToken ?? '',
      },
        body: jsonEncode(body),
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        //success
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else if (statusCode == 401) {
        onUnauthorize();
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: null,
          errorMessage: decodedData[errMsg],
        );
      }
      else {
        //failed
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['msg'],
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }




  Future<NetworkResponse> deleteRequest({required String url})async{
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url);
      Response response = await delete(uri, headers: headers);

      _logResponse(url, response);

      final int statusCode = response.statusCode;
      if(response.statusCode == 200){
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(isSuccess: true, responseCode: statusCode, responseData: decodedData);
      }else if(response.statusCode == 401){
        onUnauthorize();
        return NetworkResponse(isSuccess: false, responseCode: statusCode, responseData: null, errorMessage: 'Un-Authorized');
      }else{
        // Failed
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(isSuccess: false, responseCode: statusCode, responseData: decodedData, errorMessage: decodedData['data']);
      }
    } on Exception catch (e) {
      return NetworkResponse(isSuccess: false, responseCode: -1, responseData: null, errorMessage: e.toString());
    }

  }


  void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i('URL => $url\n'
        'Request Body: $body'
    );
  }

  void _logResponse(String url, Response response) {
    _logger.i('URL => $url\n'
        'Status Code: ${response.statusCode}\n'
        'Body: ${response.body}'
    );
  }

}

