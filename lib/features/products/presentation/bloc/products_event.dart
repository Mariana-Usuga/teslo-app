part of 'products_bloc.dart';

class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadNextPage extends ProductsEvent {
  const LoadNextPage();
}

class CreateOrUpdateProduct extends ProductsEvent {
  Map<String, dynamic> productLike;
  CreateOrUpdateProduct(this.productLike);
}
