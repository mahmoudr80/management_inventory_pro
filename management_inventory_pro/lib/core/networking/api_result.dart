import 'api_error_model.dart';

sealed class ApiResult<T> {
  const ApiResult();
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiErrorModel errorModel) = Failure<T>;
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final ApiErrorModel errorModel;
  const Failure(this.errorModel);
}
