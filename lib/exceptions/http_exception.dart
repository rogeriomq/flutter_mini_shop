// ignore_for_file: public_member_api_docs, sort_constructors_first
class HttpException implements Exception {
  final String msg;
  final int statusCode;

  HttpException({
    required this.msg,
    required this.statusCode,
  });

  @override
  String toString() {
    return msg;
  }
}
