import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  //final authRepository = ProductsRepositoryImpl(); //NO SE DONDE VA
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  ProductFormBloc({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(', '),
          images: product.images,
        )) {
    //on<ProductFormEvent>();
    //on<LoadMoreData>(onFormSubmit);
    on<SubmitForm>((event, emit) async {
      _touchedEverything();

      print('STATE ${state.title.value}');
      if (!state.isFormValid) return Future.value(false);

      if (onSubmitCallback == null) return Future.value(false);

      final productLike = {
        'id': (state.id == 'new') ? null : state.id,
        'title': state.title.value,
        'price': state.price.value,
        'description': state.description,
        'slug': state.slug.value,
        'stock': state.inStock.value,
        'sizes': state.sizes,
        'gender': state.gender,
        'tags': state.tags.split(','),
        'images': state.images
            .map((image) =>
                image.replaceAll('http://10.0.2.2:3000/api/files/product/', ''))
            .toList()
      };

      try {
        return Future.value(await onSubmitCallback!(productLike));
      } catch (e) {
        return Future.value(false);
      }
    });
    on<TitleChanged>((event, emit) {
      final newTitle = Title.dirty(event.title);
      emit(state.copyWith(
          title: newTitle,
          isFormValid: Formz.validate([
            newTitle,
            Slug.dirty(state.slug.value),
            Price.dirty(state.price.value),
            Stock.dirty(state.inStock.value),
          ])));
    });
    on<PriceChanged>((event, emit) {
      final newPrice = Price.dirty(event.price);
      emit(state.copyWith(
          price: newPrice,
          isFormValid: Formz.validate([
            Title.dirty(state.title.value),
            Slug.dirty(state.slug.value),
            newPrice,
            Stock.dirty(state.inStock.value),
          ])));
    });
    on<StockChanged>((event, emit) {
      final newStock = Stock.dirty(event.inStock);

      emit(state.copyWith(
          inStock: newStock,
          isFormValid: Formz.validate([
            Title.dirty(state.title.value),
            Slug.dirty(state.slug.value),
            Price.dirty(state.price.value),
            newStock,
          ])));
    });

    on<SlugChanged>((event, emit) {
      final newSlug = Slug.dirty(event.slug);

      emit(state.copyWith(
          slug: newSlug,
          isFormValid: Formz.validate([
            Title.dirty(state.title.value),
            Stock.dirty(state.inStock.value),
            Price.dirty(state.price.value),
            newSlug,
          ])));
    });

    on<SizeChanged>((event, emit) {
      emit(state.copyWith(sizes: event.sizes));
    });

    on<GenderChanged>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });

    on<DescriptionChanged>((event, emit) {
      emit(state.copyWith(description: event.description));
    });

    on<TagsChanged>((event, emit) {
      emit(state.copyWith(tags: event.tags));
    });
    //on<TitleChanged>(_onFormSubmit);
  }

  //Future<bool> onFormSubmit() async {}

  _touchedEverything() {
    emit(state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    ));
  }

  /*void _touchedEverything() {
    emit(state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    ));
  }*/

  /*void onTitleChanged(String value) {
    print('ENTRA EN TITLE $value');
    //add(TitleChanged(value));

    emit(state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ])));
  }

  void onSlugChanged(String value) {
    emit(state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ])));
  }

  void onPriceChanged(double value) {
    emit(state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ])));
  }

  void onStockChanged(int value) {
    emit(state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ])));
  }*/
}
