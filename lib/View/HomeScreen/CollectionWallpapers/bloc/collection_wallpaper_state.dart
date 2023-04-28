part of 'collection_wallpaper_bloc.dart';

@immutable
abstract class CollectionWallpaperState {}

class CollectionWallpaperInitial extends CollectionWallpaperState {}

class CollectionWallpapersLoading extends CollectionWallpaperState {}

class CollectionWallpapersSuccess extends CollectionWallpaperState {
  final List<WallpaperEntity> wallpaperList;

  CollectionWallpapersSuccess(this.wallpaperList);
}

class CollectionWallpapersError extends CollectionWallpaperState {}
