part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSuccessScreen extends HomeState {
  final List<WallpaperCollectionEntity> collectionList;
  final List<WallpaperEntity> wallpaperList;

  HomeSuccessScreen({required this.collectionList, required this.wallpaperList});
}

class HomeApiLoadingScreen extends HomeState {}

class HomeApiErrorScreen extends HomeState {}
