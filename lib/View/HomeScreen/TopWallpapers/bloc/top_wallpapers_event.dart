part of 'top_wallpapers_bloc.dart';

@immutable
abstract class TopWallpapersEvent {}

class TopWallpapersStart extends TopWallpapersEvent {}

class TopWallpapersItem extends TopWallpapersEvent {
  final List<WallpaperEntity> wallpaperList;
  final int pageNumber;

  TopWallpapersItem({required this.wallpaperList, required this.pageNumber});
}
