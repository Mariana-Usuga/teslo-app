import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;

  ProductsBloc({required this.productsRepository}) : super(ProductsState()) {
    //loadNextPage();
    on<LoadNextPage>((event, emit) async {
      if (state.isLoading || state.isLastPage) return;

      emit(state.copyWith(isLoading: true));

      final products = await productsRepository.getProductsByPage(
          limit: state.limit, offset: state.offset);

      if (products.isEmpty) {
        emit(state.copyWith(isLoading: false, isLastPage: true));
        return;
      }

      emit(state.copyWith(
          isLastPage: false,
          isLoading: false,
          offset: state.offset + 10,
          products: [...state.products, ...products]));
    });
  }

  //Future loadNextPage() async {}

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      print('entra en createOrUpdateProduct ${productLike}');
      final product = await productsRepository.createUpdateProduct(productLike);
      final isProductInList =
          state.products.any((element) => element.id == product.id);

      if (!isProductInList) {
        emit(state.copyWith(products: [...state.products, product]));
        return true;
      }

      emit(state.copyWith(
          products: state.products
              .map(
                (element) => (element.id == product.id) ? product : element,
              )
              .toList()));
      return true;
    } catch (e) {
      return false;
    }
  }
}
/*import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;

  ProductsBloc({required this.productsRepository}) : super(ProductsState()) {
    loadNextPage();
    on<ProductsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    emit(state.copyWith(isLoading: true));

    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      emit(state.copyWith(isLoading: false, isLastPage: true));
      return;
    }

    emit(state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]));
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      print('entra en createOrUpdateProduct ${productLike}');
      final product = await productsRepository.createUpdateProduct(productLike);
      final isProductInList =
          state.products.any((element) => element.id == product.id);

      if (!isProductInList) {
        emit(state.copyWith(products: [...state.products, product]));
        return true;
      }

      emit(state.copyWith(
          products: state.products
              .map(
                (element) => (element.id == product.id) ? product : element,
              )
              .toList()));
      return true;
    } catch (e) {
      return false;
    }
  }
}*/
