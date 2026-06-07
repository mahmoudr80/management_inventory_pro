import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is Exception) {
      // You can add specific Exception checking here later
      // e.g. if (error is PostgrestException) ...
      return ApiErrorModel(message: error.toString());
    } else {
      return ApiErrorModel(message: "An unknown error occurred");
    }
  }
}
