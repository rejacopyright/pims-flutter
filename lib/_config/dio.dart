import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class API {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.2.109:4000/api/v1/',
      contentType: Headers.formUrlEncodedContentType,
      // headers: {'Access-Control-Allow-Origin': '*', 'Accept': '*'}
      // headers: {HttpHeaders.authorizationHeader: 'Bearer abc'},
    ),
  );

  final interceptors = InterceptorsWrapper(
    onRequest: (options, handler) {
      final box = GetStorage();
      final token = box.read('token');
      options.headers['Authorization'] = 'Bearer ${token..toString()}';
      return handler.next(options);
    },
  );

  Future<Response> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    dio.interceptors.add(interceptors);
    try {
      return dio.get(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    dio.interceptors.add(interceptors);
    try {
      return dio.post(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    dio.interceptors.add(interceptors);
    try {
      return dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    dio.interceptors.add(interceptors);
    try {
      return dio.delete(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw Exception(e);
    }
  }
}
