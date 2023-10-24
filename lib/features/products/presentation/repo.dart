import 'package:dio/dio.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

import '../../auth/infrastructure/mappers/user_mapper.dart';
import '../infrastructure/infrastructure.dart';

class ProductModel {
  ProductModel({
    required this.setup,
    required this.delivery,
    required this.id,
  });

  String setup;
  String delivery;
  int id;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        setup: json["setup"] ?? json["joke"],
        delivery: json["delivery"] ?? "",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "setup": setup,
        "delivery": delivery,
        "id": id,
      };
}

class JokeRepository {
  final String _baseUrl = "https://v2.jokeapi.dev/joke/Any";
  final dio = Dio();

  Future<ProductModel> getProduct() async {
    final response = await dio.get(
      'http://10.0.2.2:3000/api/products/187b1f91-10f3-41da-9f71-e3bdf4d78381',
    );
    //final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
      //return jokeModelFromJson(response.body);
    } else {
      throw Exception("Failed to load joke");
    }
  }
}
