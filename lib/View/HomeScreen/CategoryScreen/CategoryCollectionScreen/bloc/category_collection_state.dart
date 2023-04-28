part of 'category_collection_bloc.dart';

@immutable
abstract class CategoryCollectionState {}

class CategoryCollectionInitial extends CategoryCollectionState {}

class CategoryCollectionLoading extends CategoryCollectionState {}

class CategoryCollectionSuccess extends CategoryCollectionState {
  final List<WallpaperCollectionEntity> collectonList;

  CategoryCollectionSuccess(this.collectonList);
}

class CategoryCollectionError extends CategoryCollectionState {}
