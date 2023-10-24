part of 'product_form_bloc.dart';

class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends ProductFormEvent {
  const SubmitForm();
}

class TitleChanged extends ProductFormEvent {
  final String title;

  TitleChanged(this.title);
}

class PriceChanged extends ProductFormEvent {
  final double price;

  PriceChanged(this.price);
}

class SlugChanged extends ProductFormEvent {
  final String slug;

  SlugChanged(this.slug);
}

class StockChanged extends ProductFormEvent {
  final int slug;

  StockChanged(this.slug);
}
