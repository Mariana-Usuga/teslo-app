import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:http/http.dart' as http;

import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
//import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  //final client = http.Client();
  final dio = Dio();
  @override
  Future<User?> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('${Environment.apiUrl}/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      //print('USER $user');
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      //print('entra en login, try');
      final response = await dio.post('${Environment.apiUrl}/auth/login',
          data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      final u = e.response;
      print('entra en ERROR dio $u');
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      print('entra en ERROR dio');

      throw Exception();
    } catch (e) {
      print('e $e');
      throw CustomError('err ${e}');
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    throw Exception();
    /*try {
      print('entra en login, try');

      final response = await client.post(
        headers: {
          'Content-Type': 'application/json',
        },
        Uri.parse('${Environment.apiUrl}/auth/register'),
        body: jsonEncode(
            {'email': email, 'password': password, 'fullName': fullName}),
      );
      final responseJson = json.decode(response.body);
      //final d = response.data;
      print('RESPONSE $response');

      if (responseJson['data'] == null) {
        throw CustomError(responseJson['message']);
      }
      final user = UserMapper.userJsonToEntity(responseJson);

      return user;
    } catch (e) {
      throw CustomError('Credenciales incorrectas $e');
    } */
  }
}
