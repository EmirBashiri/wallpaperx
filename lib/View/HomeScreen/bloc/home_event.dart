part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeSuccess extends HomeEvent {
  final List<WallpaperCollectionEntity> collectionList;
  final List<WallpaperEntity> wallpaperList;

  HomeSuccess({required this.collectionList, required this.wallpaperList});
}

class HomeApiError extends HomeEvent {}

class HomeTryAgain extends HomeEvent{}

class HomeUpdateState extends HomeEvent {}