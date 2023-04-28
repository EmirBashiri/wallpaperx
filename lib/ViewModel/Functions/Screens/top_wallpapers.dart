import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/TopWallpapers/bloc/top_wallpapers_bloc.dart';

class TopWallpapersFunctions {
  int pageNumber = 1;
  bool isInlineLoading = false;

  void getMoreWallpapers(
      {required TopWallpapersBloc topWallpapersBloc,
      required List<WallpaperEntity> wallpaperList}) {
    isInlineLoading = true;
    pageNumber++;
    topWallpapersBloc.add(TopWallpapersItem(
        wallpaperList: wallpaperList, pageNumber: pageNumber));
  }

  void scrollControllerListeners(
      {required ScrollController scrollController,
      required InitialController initialController,
      required TopWallpapersBloc topWallpapersBloc,
      required List<WallpaperEntity> wallpaperList}) {
    scrollController.addListener(
      () async {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          if (pageNumber <= topWallpaperMaxPage) {
            if (!isInlineLoading) {
              getMoreWallpapers(
                  wallpaperList: wallpaperList,
                  topWallpapersBloc: topWallpapersBloc);
            }
          }
        }
      },
    );
  }
}
