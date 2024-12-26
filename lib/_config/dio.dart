// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:synchronized/synchronized.dart';

String SERVER_URL =
    kReleaseMode ? 'https://api.pimsclub.id' : 'http://127.0.0.1:4000';

class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio dio;
  final Lock _lock = Lock();

  TokenRefreshInterceptor(this.dio);

  @override
  void onRequest(options, handler) async {
    // Add the current access token to the request
    final box = GetStorage();
    final token = box.read('token');
    options.headers['Authorization'] = 'Bearer ${token.toString()}';
    return handler.next(options);
  }

  @override
  void onError(err, handler) async {
    // Token has expired, refresh it
    final box = GetStorage();
    final token = box.read('token');
    final refresh_token = box.read('refresh_token');
    final code = err.response?.statusCode;
    if (box.hasData('refresh_token') && code == 401) {
      try {
        await _lock.synchronized(() async {
          final dioRefresh = Dio(
            BaseOptions(
              baseUrl: '$SERVER_URL/api/v1/',
              headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${refresh_token.toString()}'
              },
            ),
          );

          if (err.requestOptions.headers['Authorization'] != 'Bearer $token') {
            // Token has already been refreshed by another request
            return handler.resolve(await dioRefresh.fetch(err.requestOptions
              ..headers['Authorization'] = 'Bearer $token'));
          }

          // Perform token refresh
          // dioRefresh.options.headers['Authorization'] =
          //     'Bearer ${refresh_token.toString()}';
          final api = await dioRefresh.post('auth/token/refresh');
          await box.write('token', api.data['token']);
          await box.write('refresh_token', api.data['refresh_token']);
          await box.write('user', api.data['user']);

          // Retry the original request with the new token
          err.requestOptions.headers['Authorization'] =
              'Bearer ${api.data['refresh_token']}';
          return handler.resolve(await dioRefresh.fetch(err.requestOptions));
        });
      } catch (e) {
        // If refresh fails, propagate the error
        return handler.next(err);
      }
    } else {
      return handler.reject(err);
    }
  }
}

class API {
  final dio = Dio(
    BaseOptions(
      baseUrl: '$SERVER_URL/api/v1/',
      // contentType: Headers.formUrlEncodedContentType,
      // headers: {'Access-Control-Allow-Origin': '*', 'Accept': '*'}
      // headers: {HttpHeaders.authorizationHeader: 'Bearer abc'},
    ),
  );

  Future<Response> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    dio.interceptors.add(TokenRefreshInterceptor(dio));
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
    dio.interceptors.add(TokenRefreshInterceptor(dio));
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
    dio.interceptors.add(TokenRefreshInterceptor(dio));
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
    dio.interceptors.add(TokenRefreshInterceptor(dio));
    try {
      return dio.delete(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw Exception(e);
    }
  }
}
