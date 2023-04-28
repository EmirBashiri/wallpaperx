import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/CollectionWallpapers/bloc/collection_wallpaper_bloc.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CollectionWallpapers extends StatefulWidget {
  const CollectionWallpapers({super.key, required this.collectionWParguments});
  final CollectionWParameters collectionWParguments;
  @override
  State<CollectionWallpapers> createState() => _CollectionWallpapersState();
}

class _CollectionWallpapersState extends State<CollectionWallpapers> {
  late final CollectionWParameters collectionWParguments =
      widget.collectionWParguments;
  CollectionWallpaperBloc? collectionWPBloc;

  Future<void> customDispose() async {
    await collectionWPBloc?.close();
  }

  void emitCollectionWallpaperStart(
      {required CollectionWallpaperBloc collectionWallpaperBloc}) {
    collectionWallpaperBloc.add(
      CollectionWallpapersStart(
          collectionName: collectionWParguments.collectionName,
          category: collectionWParguments.category,
          pageNumber: collectionWParguments.pageNumber),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await customDispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) {
        final bloc = CollectionWallpaperBloc();
        emitCollectionWallpaperStart(collectionWallpaperBloc: bloc);
        collectionWPBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<CollectionWallpaperBloc, CollectionWallpaperState>(
        builder: (context, state) {
          if (state is CollectionWallpapersLoading) {
            return const SimpleLoadingScreen();
          } else if (state is CollectionWallpapersSuccess) {
            return CollectionWallpapersScreen(
                colorScheme: colorScheme,
                appBarTitle: collectionWParguments.title,
                appLocalizations: appLocalizations,
                wallpaperList: state.wallpaperList,
                textTheme: textTheme);
          } else if (state is CollectionWallpapersError) {
            return DuplicateErrorScreen(
              callback: () => emitCollectionWallpaperStart(
                  collectionWallpaperBloc: collectionWPBloc!),
            );
          }
          return const SimpleLoadingScreen();
        },
      ),
    );
  }
}

class CollectionWallpapersScreen extends StatelessWidget {
  const CollectionWallpapersScreen({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.wallpaperList,
    required this.appLocalizations,
    required this.appBarTitle,
  });
  final String appBarTitle;
  final ColorScheme colorScheme;
  final AppLocalizations appLocalizations;
  final TextTheme textTheme;
  final List<WallpaperEntity> wallpaperList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: wallpapersScreensAppBar(
          title: appBarTitle, colorScheme: colorScheme, textTheme: textTheme),
      body: Padding(
        padding: defaultEdgeInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WallpapersScreensTitle(
                title: appLocalizations.homeFeaturedWallpapers),
            WallpapersGridView(wallpaperList: wallpaperList),
          ],
        ),
      ),
    );
  }
}

class CollectionWParameters {
  final int pageNumber;
  final String category;
  final String collectionName;
  final String title;

  CollectionWParameters(
      {required this.category,
      required this.collectionName,
      required this.pageNumber,
      required this.title});
}
