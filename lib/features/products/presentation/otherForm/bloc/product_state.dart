part of 'product_bloc.dart';

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}

class DataLoading extends ProductState {
  DataLoading({required super.id});
}

class DataLoaded extends ProductState {
  final List<Product> products;
  final bool isLastPage;

  DataLoaded(this.products, this.isLastPage) : super(id: '');
}

class ProductLoaded extends ProductState {
  final Product product;

  ProductLoaded(this.product) : super(id: '');
}

class DataError extends ProductState {
  final String error;

  DataError(this.error) : super(id: '');
}

/*class DataInitial extends ProductState {
  final int limit;
  final int offset;
  final bool isLoading;

  DataInitial(this.limit, this.offset, this.isLoading) : super(id: '');
}*/
