import 'package:dio/dio.dart';
import '../../models/models.dart';
import 'network_exceptions.dart';
import 'urls.dart';

///
/// Make all network calls using this class
///
class ApiClient {
  final Dio dio;
  // final GlobalKey<NavigatorState>? navigatorKey;

  ApiClient({
    required this.dio,
  }) {
    dio.options.baseUrl = Urls.baseUrl;
  }

  /// Handle all `Post` requests using this method
  Future<ApiResponse<T>> post<T>(String url, {data = const {}}) async {
    try {
      final res = await dio.post(
        url,
        data: data,
      );
      return ApiResponse<T>.success(message: '', data: res.data);
    } catch (e) {
      return ApiResponse<T>(
        message: NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e),
        ),
        success: false,
      );
    }
  }

  /// Handle all `Get` requests using this method
  Future<ApiResponse<T>> get<T, K>(String url,
      {Map<String, dynamic> data = const {}}) async {
    try {
      final res = await dio.get(url);
      return ApiResponse<T>.success(message: '', data: res.data);
    } catch (ex) {
      return ApiResponse<T>(
        message: NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(ex),
        ),
        success: false,
      );
    }
  }
}
