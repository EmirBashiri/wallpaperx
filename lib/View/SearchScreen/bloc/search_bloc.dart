import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:get/get.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is SearchScreenStart) {
        emit(SearchMainScreen());
      } else if (event is SearchScreenGetWallpapers) {
        try {
          emit(SearchScreenLoading());
          final DuplicateController duplicateController = Get.find();
          final Repository repository = duplicateController.repository;
          final List<WallpaperEntity> searchResult = await repository
              .searchWallpapers(searchKeyWord: event.seachKeyword);
          if (searchResult.isNotEmpty) {
            emit(SearchScreenSuccess(searchResult));
          } else {
            emit(SearchScreenEmpty());
          }
        } catch (e) {
          emit(SearchScreenError());
        }
      }
    });
  }
}
