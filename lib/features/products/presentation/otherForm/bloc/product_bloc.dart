import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_impl.dart';
import 'package:teslo_shop/features/products/presentation/bloc/products_bloc.dart';
import 'package:teslo_shop/features/products/presentation/forms/bloc/product_form_bloc.dart';

import '../../provider/products_repositories_provider.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsRepository productsRepository;
  final ProductFormBloc productFormBloc;
  final ProductsBloc productsBloc;
  ProductBloc({
    required this.productsRepository,
    required this.productFormBloc,
    required this.productsBloc,
    /*required String productId*/
  }) : super(ProductState()) {
    on<GetProductById>((event, emit) async {
      try {
        final product =
            await productsRepository.getProductById(event.productId);
        emit(state.copyWith(product: product));
        print('entro en getbyid ${product}');
        print('produycts ${productsBloc.state.products}');
      } catch (e) {
        emit(DataError('Failed to fetch product: $e'));
      }
    });
  }
}
