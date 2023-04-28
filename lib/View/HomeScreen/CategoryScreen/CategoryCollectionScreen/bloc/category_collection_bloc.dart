import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:get/get.dart';

part 'category_collection_event.dart';
part 'category_collection_state.dart';

class CategoryCollectionBloc
    extends Bloc<CategoryCollectionEvent, CategoryCollectionState> {
  CategoryCollectionBloc() : super(CategoryCollectionInitial()) {
    on<CategoryCollectionEvent>((event, emit) async {
      if (event is CategoryCollectionStart) {
        try {
          emit(CategoryCollectionLoading());
          final DuplicateController duplicateController = Get.find();
          final Repository repository = duplicateController.repository;
          final List<WallpaperCollectionEntity> collectionList =
              await repository.getCollectionsCover(
                  perPage: categoryCollectionPerPage,
                  category: event.category,
                  query: event.collectionName,
                  cacheKey: event.collectionName);
          emit(CategoryCollectionSuccess(collectionList));
        } catch (e) {
          emit(CategoryCollectionError());
        }
      }
    });
  }
}
