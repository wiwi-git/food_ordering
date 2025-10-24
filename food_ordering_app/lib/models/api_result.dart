
class ApiResult<T> {
  final bool success;
  final int statusCode;
  final T? body;

  ApiResult({
    required this.success,
    required this.statusCode,
    this.body,
  });
}
