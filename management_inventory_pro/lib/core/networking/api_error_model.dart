class ApiErrorModel {
  final int? code;
  final String message;

  ApiErrorModel({
    this.code,
    required this.message,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      code: json['code'] as int?,
      message: json['message'] as String? ?? 'Unknown error occurred',
    );
  }
}
