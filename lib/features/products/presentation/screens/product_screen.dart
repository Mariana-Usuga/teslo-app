import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/bloc/products_bloc.dart';
import 'package:teslo_shop/features/products/presentation/forms/bloc/product_form_bloc.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../otherForm/bloc/product_bloc.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<void> _loadProductFuture;
  late ProductFormBloc productFormBloc;
  late ProductsBloc productsBloc;
  late Product product;
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
  }

  @override
  void initState() {
    super.initState();

    _loadProductFuture = _loadProduct();
  }

  Future<void> _loadProduct() async {
    productsBloc = context.read<ProductsBloc>();
    print('entra en _loadProduct ${productsBloc}');

    productFormBloc = context.read<ProductFormBloc>();
    context.read<ProductBloc>().add(GetProductById(widget.productId));
    // Espera a que el estado del ProductBloc se actualice con el producto.
    await context.read<ProductBloc>().stream.firstWhere((state) {
      product = state.product!;
      productFormBloc.add(LoadedProduct(state.product!));

      return state.product != null;
    });
    //print('productFormBloc ${productFormBloc.state}');
    print('entra en _loadProduct ${productsBloc}');
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    final productFormBloc = context.read<ProductFormBloc>();
    final products = context.read<ProductsBloc>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Producto'),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () =>
                  //print('print en editar producto ${products.state}'),
                  GoRouter.of(context).pop()),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
            bloc: productBloc,
            builder: (context, state) {
              if (productBloc.state.product != null) {
                return _ProductView(
                    product: productBloc.state.product!, id: widget.productId);
              }
              return Text('Cargando..');
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            productFormBloc.add(SubmitForm(productsBloc));
            print('productFormBloc ${productFormBloc.state}');
          },
          child: const Icon(Icons.save_as_outlined),
        ));
  }
}

class _ProductView extends StatelessWidget {
  final Product product;
  final String id;

  const _ProductView({required this.product, required this.id});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: product.images),
        ),
        const SizedBox(height: 10),
        Center(child: Text(product.title, style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        _ProductInformation(product: product, id: id),
      ],
    );
  }
}

class _ProductInformation extends StatefulWidget {
  final Product product;
  final String id;

  const _ProductInformation({required this.id, required this.product});

  @override
  State<_ProductInformation> createState() => _ProductInformationState();
}

class _ProductInformationState extends State<_ProductInformation> {
  @override
  void initState() {
    super.initState();

    //context.read<ProductFormBloc>().add(LoadedProduct(widget.product));
  }

  @override
  Widget build(BuildContext context) {
    final productFormBloc = context.read<ProductFormBloc>();

    /* return BlocBuilder<ProductFormBloc, ProductFormState>(
        bloc: productFormBloc,
        builder: (context, state) {*/
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Titulo',
            initialValue: productFormBloc.state.title.value,
            onChanged: (value) => productFormBloc.add(TitleChanged(value)),
            errorMessage: productFormBloc.state.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productFormBloc.state.slug.value,
            onChanged: (value) => productFormBloc.add(SlugChanged(value)),
            errorMessage: productFormBloc.state.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormBloc.state.price.value.toString(),
            onChanged: (value) =>
                productFormBloc.add(PriceChanged(double.tryParse(value) ?? -1)),
            errorMessage: productFormBloc.state.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productFormBloc.state.sizes,
            onSizesChanged: (value) => productFormBloc.add(
              SizeChanged(value),
            ),
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productFormBloc.state.gender,
            onGendersChanged: (value) => productFormBloc.add(
              GenderChanged(value),
            ),
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormBloc.state.inStock.value.toString(),
            onChanged: (value) => productFormBloc.add(
              StockChanged(int.tryParse(value) ?? -1),
            ),
            errorMessage: productFormBloc.state.inStock.errorMessage,
          ),
          CustomProductField(
              maxLines: 6,
              label: 'Descripción',
              keyboardType: TextInputType.multiline,
              initialValue: widget.product.description,
              onChanged: (value) => productFormBloc.add(
                    DescriptionChanged(value),
                  )
              //.onDescriptionChanged,
              ),
          CustomProductField(
              isBottomField: true,
              maxLines: 2,
              label: 'Tags (Separados por coma)',
              keyboardType: TextInputType.multiline,
              initialValue: widget.product.tags.join(', '),
              onChanged: (value) => productFormBloc.add(
                    TagsChanged(productFormBloc.state.tags),
                  )
              //.onTagsChanged,
              ),
          const SizedBox(height: 100),
        ],
      ),
    );
    //});
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  //final Function(String)? onSizesChanged

  final void Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector(
      {required this.selectedSizes, required this.onSizesChanged});

  @override
  Widget build(BuildContext context) {
    final productFormBloc = context.read<ProductFormBloc>();

    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        print('newSelection $newSelection');
        //productFormBloc.add(SizesChanged(newSelection.toList()));
        FocusScope.of(context).unfocus();
        onSizesChanged(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  final void Function(String selectedGender) onGendersChanged;

  const _GenderSelector(
      {required this.selectedGender, required this.onGendersChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        //emptySelectionAllowed: false,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onGendersChanged(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset('assets/images/no-image.jpg',
                      fit: BoxFit.cover))
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  e,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
    );
  }
}
