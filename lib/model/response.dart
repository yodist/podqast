class Response {
  final dynamic? data;
  final bool success;
  final Object? error;
  final String message;

  Response({this.data, required this.success, this.error, this.message = ''});

  Response.fromData(Map<String, dynamic> data)
      : data = data['data'],
        success = data['success'],
        error = data['error'],
        message = data['message'];

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'success': success,
      'error': error,
      'message': message,
    };
  }
}
