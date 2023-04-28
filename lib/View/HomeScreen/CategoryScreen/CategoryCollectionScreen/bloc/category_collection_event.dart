part of 'category_collection_bloc.dart';

@immutable
abstract class CategoryCollectionEvent {}

class CategoryCollectionStart extends CategoryCollectionEvent {
  final String collectionName;
  final String category;

  CategoryCollectionStart(
      {required this.collectionName, required this.category});
}
