import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
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
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
  }

  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(GetProductById(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Producto'),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
            bloc: productBloc,
            builder: (context, state) => productBloc.state.product != null
                ? _ProductView(
                    product: productBloc.state.product!, id: widget.productId)
                : Text('Cargando..')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            /*ref
                .read(productFormBlocProvider(productState.state.product!)
                    .notifier)
                .onFormSubmit()
                .then((value) {
              if (!value) return;
              showSnackbar(context);
            });*/
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
    final productFormBloc = context.read<ProductFormBloc>();

    //final productFormBloc = ref.watch(productFormBlocProvider(product));

    return //BlocProvider<ProductFormBloc>(
        //create: (context) => ProductFormBloc(product: product),
        ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: product.images),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(productFormBloc.state.title.value,
                style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        _ProductInformation(product: product, id: id),
        // Aquí puedes mostrar los detalles del producto obtenidos de snapshot.data
        Text('Detalle: '),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  final String id;

  const _ProductInformation({required this.id, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productFormBloc = context.read<ProductFormBloc>();

    return //BlocProvider<ProductFormBloc>(
        //create: (context) => ProductFormBloc(product: product),
        Padding(
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
            errorMessage: productFormBloc.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productFormBloc.slug.value,
            onChanged: ref
                .read(productFormBlocProvider(product).notifier)
                .onSlugChanged,
            errorMessage: productFormBloc.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => ref
                .read(productFormBlocProvider(product).notifier)
                .onPriceChanged(double.tryParse(value) ?? -1),
            /*(value) =>
                context.read<ProductFormBloc>().onPriceChanged(
                      double.tryParse(value) ?? -1,
                    )*/
            errorMessage: productFormBloc.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productFormBloc.sizes,
            onSizesChanged: ref
                .read(productFormBlocProvider(product).notifier)
                .onSizeChanged,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productFormBloc.gender,
            onGendersChanged: ref
                .read(productFormBlocProvider(product).notifier)
                .onGenderChanged,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormBloc.inStock.value.toString(),
            onChanged: (value) => ref
                .read(productFormBlocProvider(product).notifier)
                .onStockChanged,
            /*(value) => context
                .read<ProductFormBloc>()
                .onStockChanged(int.tryParse(value) ?? -1),*/
            errorMessage: productFormBloc.inStock.errorMessage,
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: ref
                .read(productFormBlocProvider(product).notifier)
                .onDescriptionChanged,
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged: ref
                .read(productFormBlocProvider(product).notifier)
                .onTagsChanged,
          ),
          const SizedBox(height: 100),
          /*ElevatedButton(
            onPressed: () {
              
              productFormBloc.onFormSubmit();
            },
            child: Text('actualizadar'),
          )*/
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final void Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector(
      {required this.selectedSizes, required this.onSizesChanged});

  @override
  Widget build(BuildContext context) {
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
