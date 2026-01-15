import 'package:dio/dio.dart';
import 'package:recepies_app/consts.dart';

class HttpService {
  static final HttpService _singleton = HttpService._internal();

  final _dio = Dio();

  factory HttpService() {
    return _singleton;
  }

  HttpService._internal() {
    setup();
  }

  Future<void> setup({String? bearerToken}) async {
    final headers = {"Content-Type": "application/json"};
    final options = BaseOptions(
      baseUrl: API_BASE_URL,
      headers: headers,
      validateStatus: (status) {
        if (status == null) return false;
        return status < 500;
      },
    );
    _dio.options = options;
  }

  Future<Response?> post(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      // Dio throws even when response exists
      print("Dio error status: ${e.response?.statusCode}");
      print("Dio error data: ${e.response?.data}");
      return e.response; // 🔑 THIS IS THE KEY
    }
  }
}
