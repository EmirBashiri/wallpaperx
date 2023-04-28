part of 'wallpaper_detail_bloc.dart';

@immutable
abstract class WallpaperDetailEvent {}

class WallpaperDetialStart extends WallpaperDetailEvent {
  final WallpaperEntity wallpaperEntity;

  WallpaperDetialStart(this.wallpaperEntity);
}

class WallpaperDetialAddToFavorite extends WallpaperDetailEvent {
  final WallpaperEntity wallpaperEntity;
  final BuildContext context;

  WallpaperDetialAddToFavorite(
      {required this.wallpaperEntity, required this.context});
}

class WallpaperDetialSave extends WallpaperDetailEvent {
  final WallpaperEntity wallpaperEntity;

  WallpaperDetialSave(this.wallpaperEntity);
}

class WallpaperDetialSet extends WallpaperDetailEvent {
  final bool isInFavoriteBox;

  WallpaperDetialSet(this.isInFavoriteBox);
}

class SetImageAsWallpaper extends WallpaperDetailEvent {
  final WallpaperEntity wallpaperEntity;
  final WallpaperMode wallpaperMode;
  final AndroidUiSettings androidCropStyle;

  SetImageAsWallpaper(
      {required this.wallpaperMode,
      required this.wallpaperEntity,
      required this.androidCropStyle});
}

class WallpaperLaunchUrlLink extends WallpaperDetailEvent {
  final String urlLink;
  final bool isInFavoriteBox;

  WallpaperLaunchUrlLink(
      {required this.urlLink, required this.isInFavoriteBox});
}
