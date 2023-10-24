import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_impl.dart';

import '../../provider/products_repositories_provider.dart';

part 'product_event.dart';
part 'product_state.dart';

final productBlocProvider =
    Provider.family<ProductBloc, String>((ref, productId) {
  final productRepository = ref.watch(productRepositoryProvider);

  return ProductBloc(
      productsRepository: productRepository, productId: productId);
});

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsRepository productsRepository;

  //List<Product> products = [];

  //bool isLastPage = false;
  //int limit = 10; // Establece el límite inicial
  //int offset = 0; // Establece el desplazamiento inicial

  ProductBloc({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    _onGetProductById();
    //on<PostData>(_onPostData);
    //on<PatchData>(_createOrUpdateProduct);
    //on<DeleteData>(_onDeleteData);
    //on<LoadMoreData>(_onLoadMoreData);
    //on<GetProductById>(_onGetProductById);
  }

  /*void _onLoadMoreData(LoadMoreData event, Emitter<ProductState> emit) async {
    if (!isLastPage) {
      offset += limit; // Incrementa el offset para cargar más datos
      // emit(DataInitial(limit, offset, true));
      final newProducts = await productsRepository.getProductsByPage(
          limit: limit, offset: offset);
      //if (response.statusCode == 200) {
      //final newProducts = Product.fromJson(response.body);
      products.addAll(newProducts);
      isLastPage = newProducts.isEmpty;
      emit(DataLoaded(products, isLastPage));
      //} else {
      //emit(DataError('Failed to fetch more data'));
      //}
    }
  }*/

  Future _onGetProductById() async {
    print('entro en getbyid');
    //emit(ProductLoading());
    //emit(DataLoading());

    try {
      final product = await productsRepository.getProductById(state.id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(DataError('Failed to fetch product: $e'));
    }
  }

  // Resto de la lógica para _onPostData, _onPatchData y _onDeleteData
}
