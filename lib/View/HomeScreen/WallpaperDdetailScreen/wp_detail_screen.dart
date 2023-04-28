import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/Icons/icons.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'bloc/wallpaper_detail_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WallpaperDetail extends StatefulWidget {
  const WallpaperDetail({super.key, required this.wallpaperEntity});
  final WallpaperEntity wallpaperEntity;

  @override
  State<WallpaperDetail> createState() => _WallpaperDetailState();
}

class _WallpaperDetailState extends State<WallpaperDetail> {
  WallpaperDetailBloc? detailBloc;
  StreamSubscription? subscription;
  final DuplicateController duplicateController = Get.find();
  late final WallpaperEntity wallpaperEntity = widget.wallpaperEntity;

  Future<void> customDispose() async {
    await subscription?.cancel();
    await detailBloc?.close();
  }

  @override
  void initState() {
    duplicateController.customToast.initializeToast(context);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await customDispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocProvider(
        create: (context) {
          final bloc = WallpaperDetailBloc();
          bloc.add(WallpaperDetialStart(widget.wallpaperEntity));
          detailBloc = bloc;
          subscription = bloc.stream.listen((state) {
            if (state is WallpaperDetialShowResult) {
              final CustomToast customToast = state.customToast;
              final String message = state.messagetitle;
              customToast.showToast(
                toastGravity: ToastGravity.CENTER,
                child: ToastWidget(title: message),
              );
            } else if (state is SelecetWallpaperMode) {
              Get.bottomSheet(
                BottomSheet(
                  constraints: BoxConstraints(
                    maxHeight: bottomSheetMaxHeight(screenHeight: Get.height),
                  ),
                  backgroundColor: colorScheme.shadow,
                  shape: bottomSheetShape,
                  onClosing: () {},
                  builder: (context) {
                    return Container(
                      padding: defaultEdgeInsets,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: defaultPaddingValue,
                            bottom: defaultPaddingValue),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SelecetWallpaperItem(
                              callback: () {
                                addSetWallpaperEvent(
                                    detailBloc: bloc,
                                    appLocalizations: appLocalizations,
                                    colorScheme: colorScheme,
                                    wallpaperMode: WallpaperMode.homeScreen);
                              },
                              title: appLocalizations.wallpaperSetHome,
                            ),
                            SelecetWallpaperItem(
                              callback: () {
                                addSetWallpaperEvent(
                                    detailBloc: bloc,
                                    appLocalizations: appLocalizations,
                                    colorScheme: colorScheme,
                                    wallpaperMode: WallpaperMode.lockScreen);
                              },
                              title: appLocalizations.wallpaperSetLock,
                            ),
                            SelecetWallpaperItem(
                              callback: () {
                                addSetWallpaperEvent(
                                    detailBloc: bloc,
                                    appLocalizations: appLocalizations,
                                    colorScheme: colorScheme,
                                    wallpaperMode: WallpaperMode.bothScreen);
                              },
                              title: appLocalizations.wallpaperSetBoth,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          });
          return bloc;
        },
        child: BlocBuilder<WallpaperDetailBloc, WallpaperDetailState>(
          builder: (context, state) {
            if (state is WallpaperDetialMainScreen) {
              return WallpaperView(
                wallpaperEntity: wallpaperEntity,
                detailBloc: detailBloc!,
                isInFavoriteBox: state.isInFavoriteBox,
                width: Get.width,
                height: Get.height,
                fit: BoxFit.contain,
                placeholder: wallpaperBlurLoading(
                    colorScheme: colorScheme,
                    isInFavoriteBox: state.isInFavoriteBox,
                    url: widget.wallpaperEntity.coverLink),
                imageUrl: wallpaperEntity.viewLink,
              );
            } else if (state is LaunchNewWallpaper) {
              final WallpaperEntity newWallpaperEntity =
                  state.newWallpaperEntity;
              return WallpaperView(
                wallpaperEntity: newWallpaperEntity,
                detailBloc: detailBloc!,
                isInFavoriteBox: state.isInFavoriteBox,
                width: Get.width,
                height: Get.height,
                fit: BoxFit.fill,
                placeholder: wallpaperBlurLoading(
                    colorScheme: colorScheme,
                    isInFavoriteBox: state.isInFavoriteBox,
                    url: newWallpaperEntity.coverLink),
                imageUrl: newWallpaperEntity.viewLink,
              );
            } else if (state is WallpaperDetialLoading) {
              return wallpaperBlurLoading(
                  colorScheme: colorScheme,
                  isInFavoriteBox: state.isInFavoriteBox,
                  url: widget.wallpaperEntity.viewLink);
            }
            return Container();
          },
        ),
      ),
    );
  }

  void addSetWallpaperEvent({
    required WallpaperDetailBloc detailBloc,
    required AppLocalizations appLocalizations,
    required ColorScheme colorScheme,
    required WallpaperMode wallpaperMode,
  }) {
    detailBloc.add(
      SetImageAsWallpaper(
        wallpaperMode: wallpaperMode,
        wallpaperEntity: widget.wallpaperEntity,
        androidCropStyle: AndroidUiSettings(
            backgroundColor: colorScheme.background,
            toolbarColor: colorScheme.background,
            toolbarTitle: appLocalizations.appName,
            statusBarColor: colorScheme.background,
            toolbarWidgetColor: colorScheme.secondary,
            activeControlsWidgetColor: colorScheme.primary,
            showCropGrid: false,
            hideBottomControls: true),
      ),
    );
    Get.back();
  }

  Stack wallpaperBlurLoading({
    required ColorScheme colorScheme,
    required bool isInFavoriteBox,
    required String url,
  }) {
    return Stack(
      children: [
        WallpaperView(
          wallpaperEntity: wallpaperEntity,
          detailBloc: detailBloc!,
          isInFavoriteBox: isInFavoriteBox,
          fit: BoxFit.fill,
          width: Get.width,
          height: Get.height,
          imageUrl: url,
        ),
        CustomBlur(
          color: colorScheme.background.withOpacity(0.5),
        ),
        Positioned(
          child: CustomLoading(color: colorScheme.secondary),
        )
      ],
    );
  }
}

class SelecetWallpaperItem extends StatelessWidget {
  const SelecetWallpaperItem(
      {super.key, required this.callback, required this.title});
  final GestureTapCallback callback;
  final String title;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
          top: defaultPaddingValue, bottom: defaultPaddingValue),
      child: ListTile(
        title: Text(
          title,
          style: textTheme.bodyMedium!.copyWith(color: colorScheme.background),
        ),
        onTap: callback,
      ),
    );
  }
}

class WallpaperView extends StatelessWidget {
  WallpaperView({
    super.key,
    required this.isInFavoriteBox,
    required this.detailBloc,
    this.placeholder,
    this.errorWidget,
    this.cache = true,
    this.cahceMaxAge = wallpaperDetailCacheMaxAge,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    required this.wallpaperEntity,
    required this.imageUrl,
  });
  final bool isInFavoriteBox;
  final WallpaperDetailBloc detailBloc;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool cache;
  final Duration cahceMaxAge;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final WallpaperEntity wallpaperEntity;
  final String imageUrl;
  final DuplicateController duplicateController = Get.find();
  late final CustomIcons customIcons = duplicateController.customIcons;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ExtendedImage.network(
      imageUrl,
      cacheMaxAge: cahceMaxAge,
      fit: fit,
      width: width,
      height: height,
      borderRadius: borderRadius,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return _imageLoadingState(colorScheme: colorScheme);
          case LoadState.failed:
            return _imageErrorState(
              callback: state.reLoadImage,
              colorScheme: colorScheme,
            );
          default:
            return Stack(
              children: [
                Positioned.fill(child: state.completedWidget),
                WallpaperItems(
                  wallpaperEntity: wallpaperEntity,
                  isInFavoriteBox: isInFavoriteBox,
                  detailBloc: detailBloc,
                ),
              ],
            );
        }
      },
    );
  }

  Widget _imageErrorState(
      {required GestureTapCallback callback,
      required ColorScheme colorScheme}) {
    return GestureDetector(
      onTap: callback,
      child: errorWidget ??
          SimpleContainer(
            color: colorScheme.secondary.withOpacity(0.5),
            child: Icon(
              customIcons.loadErrorIcon,
              size: defaultIconSize,
              color: colorScheme.secondary,
            ),
          ),
    );
  }

  Widget _imageLoadingState({required ColorScheme colorScheme}) {
    return placeholder ??
        SimpleContainer(color: colorScheme.secondary.withOpacity(0.5));
  }
}

class WallpaperItems extends StatelessWidget {
  final WallpaperEntity wallpaperEntity;
  final bool isInFavoriteBox;
  final WallpaperDetailBloc detailBloc;
  WallpaperItems(
      {super.key,
      required this.wallpaperEntity,
      required this.isInFavoriteBox,
      required this.detailBloc});

  final DuplicateController duplicateController = Get.find();
  late final CustomIcons customIcons = duplicateController.customIcons;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color buttonColor = colorScheme.secondary.withOpacity(0.7);
    const double buttonIconSize = 20;
    const double buttonSize = 50;
    const EdgeInsetsGeometry duplicateIinsets =
        EdgeInsets.all(defaultPaddingValue);
    return Positioned(
      child: SafeArea(
        child: Padding(
          padding: defaultEdgeInsets,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomCupertinoButton(
                      color: buttonColor,
                      child: Icon(
                        customIcons.backIcon,
                        size: buttonIconSize,
                        color: colorScheme.background,
                      ),
                      callback: () {
                        Get.back();
                      },
                    ),
                    customToolTip(
                        colorScheme,
                        duplicateIinsets,
                        appLocalizations,
                        textTheme,
                        buttonSize,
                        buttonColor,
                        buttonIconSize),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCupertinoButton(
                      color: buttonColor,
                      child: Icon(
                        customIcons.setWallpaperIcon,
                        size: buttonIconSize,
                        color: colorScheme.background,
                      ),
                      callback: () {
                        detailBloc.add(WallpaperDetialSet(isInFavoriteBox));
                      },
                    ),
                    CustomCupertinoButton(
                      color: buttonColor,
                      child: Icon(
                        customIcons.downloadIcon,
                        size: buttonIconSize,
                        color: colorScheme.background,
                      ),
                      callback: () async {
                        detailBloc.add(WallpaperDetialSave(wallpaperEntity));
                      },
                    ),
                    CustomCupertinoButton(
                      color: buttonColor,
                      child: isInFavoriteBox
                          ? Icon(
                              customIcons.favoriteIcon,
                              color: colorScheme.primary,
                              size: buttonIconSize,
                            )
                          : Icon(
                              customIcons.inFavoriteIcon,
                              color: colorScheme.background,
                              size: buttonIconSize,
                            ),
                      callback: () async {
                        detailBloc.add(WallpaperDetialAddToFavorite(
                            context: context,
                            wallpaperEntity: wallpaperEntity));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  JustTheTooltip customToolTip(
      ColorScheme colorScheme,
      EdgeInsetsGeometry duplicateIinsets,
      AppLocalizations appLocalizations,
      TextTheme textTheme,
      double buttonSize,
      Color buttonColor,
      double buttonIconSize) {
    return JustTheTooltip(
      backgroundColor: colorScheme.background,
      borderRadius: defaultCircularRadius,
      margin: duplicateIinsets,
      isModal: true,
      content: Container(
        decoration: BoxDecoration(
            color: colorScheme.background, borderRadius: defaultCircularRadius),
        padding: duplicateIinsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            duplicateRowItem(
              title: appLocalizations.wallpaperImageBy,
              colorScheme: colorScheme,
              textTheme: textTheme,
              link: wallpaperSourceLink,
            ),
            duplicateRowItem(
                title: appLocalizations.wallpaperImageLink,
                colorScheme: colorScheme,
                textTheme: textTheme,
                link: wallpaperEntity.photographerProfileLink)
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: defaultPaddingValue),
        width: buttonSize,
        height: buttonSize,
        child: CircleAvatar(
          backgroundColor: buttonColor,
          child: Icon(
            customIcons.informationIcon,
            size: buttonIconSize,
            color: colorScheme.background,
          ),
        ),
      ),
    );
  }

  Widget duplicateRowItem(
      {required String title,
      required TextTheme textTheme,
      required ColorScheme colorScheme,
      required String link}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            "$title : ",
            style: textTheme.bodyMedium,
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: GestureDetector(
              onTap: () {
                detailBloc.add(WallpaperLaunchUrlLink(
                    urlLink: link, isInFavoriteBox: isInFavoriteBox));
              },
              child: Text(
                link,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall!.copyWith(
                  decoration: TextDecoration.underline,
                  color: colorScheme.tertiary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
