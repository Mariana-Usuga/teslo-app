import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../bloc/products_bloc.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        //ref.read(productBlocProvider.notifier).loadNextPage();
      }
    });
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productsBloc = ref.read(productsBlocProvider);
    // await productsBloc.loadNextPage();

    /*setState(() {
      isLoading = false;
    });*/
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsBlocProvider);

    return BlocBuilder<ProductsBloc, ProductsState>(
        bloc: productsState,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MasonryGridView.count(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 35,
              itemCount: productsState.state.products.length,
              itemBuilder: (context, index) {
                final product = productsState.state.products[index];
                return GestureDetector(
                    onTap: () => context.push('/product/${product.id}'),
                    child: ProductCard(product: product));
              },
            ),
          );
        });
  }
}

  

/**
 * 
 * FutureBuilder(
          future: context.read<ProductsBlocBloc>().loadNextPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final state = context.read<ProductsBlocBloc>().state;

              return MasonryGridView.count(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 35,
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];

                  return GestureDetector(
                      onTap: () => context.push('/product/${product.id}'),
                      child: ProductCard(product: product));
                },
              );
            }
          }),
 */
/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../../domain/entities/product.dart';
import '../productsBloc/products_bloc_bloc.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _ProductsView extends StatelessWidget {
  _ProductsView();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FutureBuilder(
          future: context.read<ProductsBlocBloc>().loadNextPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final state = context.read<ProductsBlocBloc>().state;

              return MasonryGridView.count(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 35,
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];

                  return GestureDetector(
                      onTap: () => context.push('/product/${product.id}'),
                      child: ProductCard(product: product));
                },
              );
            }
          }),
    );
  }
}*/
