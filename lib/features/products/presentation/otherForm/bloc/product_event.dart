part of 'product_bloc.dart';

// Eventos
abstract class ProductEvent {}

class GetData extends ProductEvent {}

class GetProductById extends ProductEvent {
  final String productId;

  GetProductById(this.productId);
}

class PostData extends ProductEvent {
  final Map<String, dynamic> data;

  PostData(this.data);
}

class PatchData extends ProductEvent {
  final int id;
  final Map<String, dynamic> data;

  PatchData(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class DeleteData extends ProductEvent {
  final int id;

  DeleteData(this.id);
}

class LoadMoreData extends ProductEvent {}
