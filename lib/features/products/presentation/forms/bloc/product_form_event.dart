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
  final int inStock;

  StockChanged(this.inStock);
}

class SizeChanged extends ProductFormEvent {
  final List<String> sizes;

  SizeChanged(this.sizes);
}

class GenderChanged extends ProductFormEvent {
  final String gender;

  GenderChanged(this.gender);
}

class DescriptionChanged extends ProductFormEvent {
  final String description;

  DescriptionChanged(this.description);
}

class TagsChanged extends ProductFormEvent {
  final String tags;

  TagsChanged(this.tags);
}
