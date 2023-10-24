import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) => Product(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price'].toString()), // convertirlo en double
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes'].map((size) => size)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((tag) => tag)),
      images: List<String>.from(json['images'].map(
        (image) => 'http://10.0.2.2:3000/api/files/product/$image',
      )),
      /*images: List<String>.from(json['images'].map(
        (image) => image.startsWith('http')
            ? image
            : 'http://localhost:3000/api/files/product/$image',
      )),*/
      user: UserMapper.userJsonToEntity(json['user']));
}
// '${Environment.apiUrl}/files/product/$image'10.0.2.2