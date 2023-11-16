class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.success({required String message, T? data}) {
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.failure({required String error}) {
    return ApiResponse(success: false, message: error);
  }
}

extension ApiResponseEx on ApiResponse {
  bool get isSuccess => success == true;
  bool get isFailure => success == false;
  String get error => _getError();

  String _getError() {
    if (isFailure) {
      return message;
    }
    return '';
  }
}
