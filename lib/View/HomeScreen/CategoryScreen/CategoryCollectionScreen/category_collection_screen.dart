import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/CollectionWallpapers/collection_wp_screen.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'bloc/category_collection_bloc.dart';

class CategoryCollectionScreen extends StatefulWidget {
  const CategoryCollectionScreen({
    super.key,
    required this.collectionTerm,
    required this.collectionName,
  });
  final String collectionTerm;
  final String collectionName;

  @override
  State<CategoryCollectionScreen> createState() =>
      _CategoryCollectionScreenState();
}

class _CategoryCollectionScreenState extends State<CategoryCollectionScreen> {
  CategoryCollectionBloc? categoryCollectionBloc;

  Future<void> customDispose() async {
    await categoryCollectionBloc?.close();
  }

  void emitCategoryStart(
      {required CategoryCollectionBloc categoryCollectionBloc}) {
    categoryCollectionBloc.add(CategoryCollectionStart(
        collectionName: widget.collectionTerm,
        category: widget.collectionTerm));
  }

  @override
  void dispose() async {
    super.dispose();
    await customDispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CategoryCollectionBloc();
        emitCategoryStart(categoryCollectionBloc: bloc);
        categoryCollectionBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<CategoryCollectionBloc, CategoryCollectionState>(
        builder: (context, state) {
          final AppLocalizations appLocalization =
              AppLocalizations.of(context)!;
          final ColorScheme colorScheme = Theme.of(context).colorScheme;
          final TextTheme textTheme = Theme.of(context).textTheme;
          final double size = posterSize();
          if (state is CategoryCollectionLoading) {
            return const SimpleLoadingScreen();
          } else if (state is CategoryCollectionSuccess) {
            final List<WallpaperCollectionEntity> collectionList =
                state.collectonList;
            return CategoryCollectionMainScreen(
                colorScheme: colorScheme,
                widget: widget,
                textTheme: textTheme,
                appLocalization: appLocalization,
                posterSize: size,
                collectionList: collectionList);
          } else if (state is CategoryCollectionError) {
            return DuplicateErrorScreen(
              callback: () => emitCategoryStart(
                  categoryCollectionBloc: categoryCollectionBloc!),
            );
          }
          return const SimpleLoadingScreen();
        },
      ),
    );
  }
}

class CategoryCollectionMainScreen extends StatelessWidget {
  const CategoryCollectionMainScreen({
    super.key,
    required this.colorScheme,
    required this.widget,
    required this.textTheme,
    required this.appLocalization,
    required this.collectionList,
    required this.posterSize,
  });

  final ColorScheme colorScheme;
  final CategoryCollectionScreen widget;
  final TextTheme textTheme;
  final AppLocalizations appLocalization;
  final List<WallpaperCollectionEntity> collectionList;
  final double posterSize;
  @override
  Widget build(BuildContext context) {
    final DuplicateController duplicateController = Get.find();
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: wallpapersScreensAppBar(
          title: widget.collectionName,
          colorScheme: colorScheme,
          textTheme: textTheme),
      body: Padding(
        padding: defaultEdgeInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Text(appLocalization.homeCollection),
            ),
            Expanded(
              child: MasonryGridView.builder(
                padding: defaultItemPadding,
                physics: defaultScrollPhysics,
                itemCount: collectionList.length,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                ),
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                itemBuilder: (context, index) {
                  final WallpaperCollectionEntity collection =
                      collectionList[index];
                  return CollectionItem(
                    cahceMaxAge: defaultCacheMaxAge,
                    posterHeight: posterSize,
                    posterWidth: posterSize,
                    collection: collection,
                    title:
                        "${appLocalization.homeCollection} ${romanNumerals[index]}",
                    callback: () async {
                      await duplicateController.collectionWPsNavigation
                          .goToWallpapersScreen(
                        context: context,
                        parameters: CollectionWParameters(
                          category: widget.collectionTerm,
                          collectionName: widget.collectionTerm,
                          pageNumber: index,
                          title: topWallpapersTitle(
                              appLocalization: appLocalization, index: index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
