part of 'wallpaper_detail_bloc.dart';

@immutable
abstract class WallpaperDetailState {}

class WallpaperDetailInitial extends WallpaperDetailState {}

class WallpaperDetialLoading extends WallpaperDetailState {
  final bool isInFavoriteBox;

  WallpaperDetialLoading(this.isInFavoriteBox);
}

class WallpaperDetialMainScreen extends WallpaperDetailState {
  final bool isInFavoriteBox;

  WallpaperDetialMainScreen({
    required this.isInFavoriteBox,
  });
}

class WallpaperDetialShowResult extends WallpaperDetailState {
  final CustomToast customToast;
  final String messagetitle;
  WallpaperDetialShowResult(
      {required this.messagetitle, required this.customToast});
}

class SelecetWallpaperMode extends WallpaperDetailState {}

class LaunchNewWallpaper extends WallpaperDetailState {
  final WallpaperEntity newWallpaperEntity;
  final bool isInFavoriteBox;

  LaunchNewWallpaper(
      {required this.newWallpaperEntity, required this.isInFavoriteBox});
}
