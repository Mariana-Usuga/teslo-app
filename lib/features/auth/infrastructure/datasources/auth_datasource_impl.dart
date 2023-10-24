import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
//import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
      //BaseOptions(baseUrl: 'http://192.168.20.42:3000/api' //Environment.apiUrl,
      //baseUrl: 'http://localhost:3000/api';
      );
  //final dio = Dio();

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
          'http://10.0.2.2:3000/api/auth/check-status',
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

      final response = await dio.post('http://10.0.2.2:3000/api/auth/login',
          data: {'email': email, 'password': password});
      //final d = response.data;
      //print('RESPONSE $response');
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
      print('entra en ERROR dio');

      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
