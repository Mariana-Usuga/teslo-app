import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_impl.dart';

import '../../provider/products_repositories_provider.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsRepository productsRepository;

  ProductBloc({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    on<GetProductById>((event, emit) async {
      print('entro en getbyid');
      //emit(ProductLoading());
      //emit(DataLoading());

      try {
        final product = await productsRepository.getProductById(state.id);
        emit(ProductLoaded(product));
      } catch (e) {
        emit(DataError('Failed to fetch product: $e'));
      }
    });
    //on<PatchData>(_createOrUpdateProduct);
    //on<DeleteData>(_onDeleteData);
    //on<LoadMoreData>(_onLoadMoreData);
    //on<GetProductById>(_onGetProductById);
  }
  // Resto de la lógica para _onPostData, _onPatchData y _onDeleteData
}
