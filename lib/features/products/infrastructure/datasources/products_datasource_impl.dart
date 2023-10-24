import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../mappers/product_mapper.dart';
import 'errors/product_errors.dart';

class ProductsDatastoreImpl extends ProductsDatasource {
  late final Dio dio; //late para configurar despues
  final String accessToken;

  ProductsDatastoreImpl({required this.accessToken}) : dio = Dio();
  /*ProductsDatastoreImpl({required this.accessToken}) : dio = Dio(BaseOptions(
            baseUrl: 'http://10.0.2.2:3000/api', //Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));*/

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      print('entra en datasource ${accessToken}');
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null)
          ? 'http://10.0.2.2:3000/api/products'
          : 'http://10.0.2.2:3000/api/products/$productId';

      productLike.remove('id');

      final response = await dio.request(url,
          data: productLike,
          options: Options(
            method: method,
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      print('entra en getProductById');
      final response = await dio.get('http://10.0.2.2:3000/api/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioError catch (e) {
      print('entra en error dio');
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      print('entra en error');
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    print('entra en getProductsByPage');
    try {
      final response = await dio.get<List>(
        'http://10.0.2.2:3000/api/products?limit=$limit&offset=$offset',
      );
      //final data = response.data;
      //print('después de response $data'); // Agrega este mensaje

      final List<Product> products = [];
      //print('despues de response');

      for (final product in response.data ?? []) {
        products.add(ProductMapper.jsonToEntity(product));
      }
      //print('products $products[0]');
      print('despues de response');
      return products;
    } catch (e) {
      print('ERROR $e');
      return [];
    }
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
