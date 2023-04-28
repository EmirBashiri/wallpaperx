part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchMainScreen extends SearchState {}

class SearchScreenLoading extends SearchState {}

class SearchScreenSuccess extends SearchState {
  final List<WallpaperEntity> searchResult;

  SearchScreenSuccess(this.searchResult);
}

class SearchScreenEmpty extends SearchState{}

class SearchScreenError extends SearchState {}
