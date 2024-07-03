import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/bloc/products_bloc.dart';
import 'package:teslo_shop/features/shared/shared.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final ProductsRepository productsRepository;
  final ProductsBloc productsBloc;
  ProductFormBloc(
      {required this.productsRepository, required this.productsBloc})
      : super(ProductFormState()) {
    on<SubmitForm>((event, emit) async {
      _touchedEverything();
      print('state ${event}');
      if (!state.isFormValid) return Future.value(false);

      //if (onSubmitCallback == null) return Future.value(false);

      final productLike = {
        'id': (state.id == 'new') ? null : state.id,
        'title': state.title.value,
        'price': state.price.value,
        'description': state.description,
        'slug': state.slug.value,
        'stock': state.inStock.value,
        'sizes': state.sizes,
        'gender': state.gender,
        'tags': state.tags.split(',').toList(),
        'images': state.images.map((e) => e.split('/').last).toList(),
      };
      print('STATE ${state.images}');

      print('STATE ${productLike}');

      try {
        //return
        print('state ${event}');

        //productsBloc.add(CreateOrUpdateProduct(productLike));
        //return await Future.value(
        //productsBloc.createOrUpdateProduct(productLike));
        //return await Future.value(
        //  productsRepository.createUpdateProduct(productLike));
        //return productsRepository.createUpdateProduct(productLike);
      } catch (e) {
        return Future.value(false);
      }
    });
    on<LoadedProduct>((event, emit) {
      emit(state.copyWith(
        id: event.product.id,
        title: Title.dirty(event.product.title),
        slug: Slug.dirty(event.product.slug),
        price: Price.dirty(event.product.price),
        inStock: Stock.dirty(event.product.stock),
        sizes: event.product.sizes,
        gender: event.product.gender,
        description: event.product.description,
        tags: '${event.product.tags.join(', ')}',
        images: event.product.images,
      ));
    });
    on<TitleChanged>((event, emit) {
      final newTitle = Title.dirty(event.title);

      emit(
        state.copyWith(
          title: newTitle,
          isFormValid: Formz.validate(
            [
              newTitle,
              Slug.dirty(state.slug.value),
              Price.dirty(state.price.value),
              Stock.dirty(state.inStock.value),
            ],
          ),
        ),
      );
      print('STATE ${state}');
    });
    on<PriceChanged>((event, emit) {
      final newPrice = Price.dirty(event.price);
      emit(
        state.copyWith(
          price: newPrice,
          isFormValid: Formz.validate([
            Title.dirty(state.title.value),
            Slug.dirty(state.slug.value),
            newPrice,
            Stock.dirty(state.inStock.value),
          ]),
        ),
      );
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
      isFormPosted: true,
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    ));
    print('STATE _touchedEverything ${state}');
  }
}
