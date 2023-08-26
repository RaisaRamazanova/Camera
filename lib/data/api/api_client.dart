import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  ApiClient({ required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    _mainHeaders = {
      'Content-Type': 'application/javascript'
    };
  }

  Future<Response> sendData(String uri, FormData body) async {
    try {
      Response response = await post(
          uri,
          body,
          headers: _mainHeaders
      );
      return response;
    } catch(error) {
      return Response(statusCode: 1, statusText: error.toString());
    }
  }
}