import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/otherForm/bloc/product_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../infrastructure/infrastructure.dart';

final productRepositoryProvider = Provider<ProductsRepository>((ref) {
  // final accessToken = ref.watch(authBlocProvider).user?.token ?? '';
  final t = ref.watch(authBlocProvider).state.user!.token;
  print('TOKEN EN REPOSITORY PROVIDER $t');
  final accessToken = ref.watch(authBlocProvider).state.user!.token ?? '';

  final productRepository = ProductsRepositoryImpl(
    ProductsDatastoreImpl(accessToken: accessToken),
  );
  return productRepository;
});

/*final productBlocProvider = BlocProvider<ProductBloc>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductBloc(repository);
});*/
