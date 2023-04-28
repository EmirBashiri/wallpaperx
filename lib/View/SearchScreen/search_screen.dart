import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/Icons/icons.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/SearchScreen/bloc/search_bloc.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc? searchBloc;
  final DuplicateController duplicateController = Get.find();
  late final GlobalKey<FormState> searchFormKey =
      duplicateController.searchFormKey;
  late final RestorableTextEditingController searchController =
      duplicateController.searchTextController;

  Future<void> customDispose() async {
    await searchBloc?.close();
  }

  void Function() emitSearchWallpapers(
      {required SearchBloc searchBloc,
      required GlobalKey<FormState> searchFormKey,
      required RestorableTextEditingController searchController}) {
    return () {
      if (searchFormKey.currentState!.validate()) {
        searchBloc.add(
          SearchScreenGetWallpapers(searchController.value.text),
        );
      }
    };
  }

  @override
  void dispose() async {
    super.dispose();
    await customDispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color bottomSheetBackground = colorScheme.shadow;
    return BlocProvider(
      create: (context) {
        final bloc = SearchBloc();
        bloc.add(SearchScreenStart());
        searchBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchScreenLoading) {
            return searchMainScreen(
                content: CustomLoading(color: colorScheme.background),
                backgroundColor: bottomSheetBackground);
          } else if (state is SearchScreenSuccess) {
            return searchMainScreen(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SearchBar(
                      callback: emitSearchWallpapers(
                          searchBloc: searchBloc!,
                          searchController: searchController,
                          searchFormKey: searchFormKey),
                      searchController: searchController,
                      searchFormKey: searchFormKey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: defaultPaddingValue,
                      ),
                      child: Text(
                        appLocalizations.homeWallpapers,
                        style: textTheme.bodyLarge!
                            .copyWith(color: colorScheme.background),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: defaultEdgeInsets,
                        child: MasonryGridView.builder(
                          padding: defaultItemPadding,
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,
                          physics: defaultScrollPhysics,
                          itemCount: state.searchResult.length,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount),
                          crossAxisSpacing: crossAxisSpacing,
                          mainAxisSpacing: mainAxisSpacing,
                          itemBuilder: (context, index) {
                            final WallpaperEntity wallpaper =
                                state.searchResult[index];
                            return GestureDetector(
                              onTap: () async {
                                await duplicateController
                                    .wallpaperDetailNavigation
                                    .goToWallpaperDetailScreen(
                                  context: context,
                                  wallpaperEntity: WallpaperEntity(
                                    id: wallpaper.id,
                                    coverLink: wallpaper.coverLink,
                                    viewLink: wallpaper.downloadLink,
                                    downloadLink: "",
                                    photographerProfileLink:
                                        wallpaper.photographerProfileLink,
                                  ),
                                );
                              },
                              child: GridViewCachedImage(
                                cacheMaxAge: searchCacheMaxAge,
                                url: wallpaper.coverLink,
                                width: wallpaperGridWith,
                                boxFit: BoxFit.cover,
                                height: wallpaperGridHeght(index: index),
                                placeholder: SimpleContainer(
                                  color: colorScheme.background,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: bottomSheetBackground);
          } else if (state is SearchScreenEmpty) {
            return searchMainScreen(
              backgroundColor: bottomSheetBackground,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchBar(
                    callback: emitSearchWallpapers(
                        searchBloc: searchBloc!,
                        searchController: searchController,
                        searchFormKey: searchFormKey),
                    searchController: searchController,
                    searchFormKey: searchFormKey,
                  ),
                  const Expanded(
                    child: Center(
                      child: CustomLottie(path: emptySearchLottie),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPaddingValue),
                    child: Text(
                      appLocalizations.exploreEmptySearch,
                      overflow: TextOverflow.clip,
                      style: textTheme.bodyMedium!
                          .copyWith(color: colorScheme.background),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SearchScreenError) {
            return searchMainScreen(
              backgroundColor: bottomSheetBackground,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchBar(
                    callback: emitSearchWallpapers(
                        searchBloc: searchBloc!,
                        searchController: searchController,
                        searchFormKey: searchFormKey),
                    searchController: searchController,
                    searchFormKey: searchFormKey,
                  ),
                  Expanded(
                    child: DuplicateErrorScreen(
                      backgroundColor: bottomSheetBackground,
                      messageColor: colorScheme.background,
                      callback: emitSearchWallpapers(
                          searchBloc: searchBloc!,
                          searchController: searchController,
                          searchFormKey: searchFormKey),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SearchMainScreen) {
            return searchMainScreen(
              backgroundColor: bottomSheetBackground,
              content: SearchBar(
                callback: emitSearchWallpapers(
                    searchBloc: searchBloc!,
                    searchController: searchController,
                    searchFormKey: searchFormKey),
                searchController: searchController,
                searchFormKey: searchFormKey,
              ),
            );
          }
          return searchMainScreen(
            backgroundColor: bottomSheetBackground,
            content: SearchBar(
              callback: emitSearchWallpapers(
                  searchBloc: searchBloc!,
                  searchController: searchController,
                  searchFormKey: searchFormKey),
              searchController: searchController,
              searchFormKey: searchFormKey,
            ),
          );
        },
      ),
    );
  }

  Widget searchMainScreen({Color? backgroundColor, required Widget content}) {
    return BottomSheet(
      backgroundColor: backgroundColor,
      constraints: BoxConstraints(
          maxHeight: bottomSheetMaxHeight(screenHeight: Get.height)),
      shape: bottomSheetShape,
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return content;
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  SearchBar(
      {super.key,
      required this.searchFormKey,
      required this.searchController,
      required this.callback});
  final GlobalKey<FormState> searchFormKey;
  final RestorableTextEditingController searchController;
  final GestureTapCallback callback;
  final DuplicateController duplicateController = Get.find();
  late final CustomIcons customIcons = duplicateController.customIcons;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
          top: defaultPaddingValue, bottom: defaultPaddingValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadiusValue),
                boxShadow: [
                  searchBoxShadow(colorScheme),
                ],
              ),
              width: searchBarWidth(),
              height: defaultSearchBoxHeght,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(defaultPaddingValue),
                ),
                child: Form(
                  key: searchFormKey,
                  child: TextFormField(
                    controller: searchController.value,
                    style: textTheme.bodySmall!
                        .copyWith(color: colorScheme.secondary),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return appLocalizations.exploreSearchTerm;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(
                          defaultPaddingValue,
                        ),
                      ),
                      labelText: appLocalizations.exploreSearch,
                      labelStyle: textTheme.bodyMedium!
                          .copyWith(color: colorScheme.secondary),
                      floatingLabelStyle: textTheme.bodySmall!.copyWith(
                          color: colorScheme.primary,
                          backgroundColor: colorScheme.background),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      prefixIcon: CupertinoButton(
                        onPressed: callback,
                        child: Icon(
                          customIcons.searchIcon,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
