part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchScreenStart extends SearchEvent {}

class SearchScreenGetWallpapers extends SearchEvent {
  final String seachKeyword;

  SearchScreenGetWallpapers(this.seachKeyword);
}
