part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteEmptyScreen extends FavoriteState {}

class FavoriteSuccesScreen extends FavoriteState {
  final List<WallpaperEntity> wallpaperList;

  FavoriteSuccesScreen({required this.wallpaperList});
}

class FavoriteErrorScreen extends FavoriteState {}
