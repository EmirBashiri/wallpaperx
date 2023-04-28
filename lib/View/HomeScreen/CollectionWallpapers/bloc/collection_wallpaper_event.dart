part of 'collection_wallpaper_bloc.dart';

@immutable
abstract class CollectionWallpaperEvent {}

class CollectionWallpapersStart extends CollectionWallpaperEvent {
  final int pageNumber;
  final String category;
  final String collectionName;
  CollectionWallpapersStart({
    required this.category,
    required this.collectionName,
    required this.pageNumber,
  });
}
