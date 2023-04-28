part of 'top_wallpapers_bloc.dart';

@immutable
abstract class TopWallpapersState {}

class TopWallpapersInitial extends TopWallpapersState {}

class TopWallpaperStateLoading extends TopWallpapersState {}

class TopWallpapersSuccess extends TopWallpapersState {
  final List<WallpaperEntity> wallpaperList;


  TopWallpapersSuccess({
    required this.wallpaperList,

  });
}

class TopWallpaperStateError extends TopWallpapersState {}

class TopWallpaperInlineError extends TopWallpapersState {
  final bool isInlineError;

  TopWallpaperInlineError(this.isInlineError);
}

class TopWallpaperInlineLoading extends TopWallpapersState {
  final bool isInlineLoading;

  TopWallpaperInlineLoading(this.isInlineLoading);
}
