import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/Icons/icons.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading(
      {super.key, required this.color, this.size = loadingAnimationSize});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color,
      size: size,
    );
  }
}

class CahcedImage extends StatelessWidget {
  const CahcedImage(
      {super.key,
      required this.url,
      this.placeholder,
      this.errorWidget,
      this.cahceMaxAge,
      this.width,
      this.height,
      this.borderRadius});
  final String url;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool cache = true;
  final Duration? cahceMaxAge;
  final BoxFit fit = BoxFit.cover;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CustomIcons customIcons = Get.find<DuplicateController>().customIcons;
    return ExtendedImage.network(
      url,
      fit: fit,
      width: width,
      height: height,
      borderRadius: borderRadius,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholder ??
                SimpleContainer(
                  color: colorScheme.secondary.withOpacity(0.5),
                );
          case LoadState.failed:
            return GestureDetector(
              child: errorWidget ??
                  SimpleContainer(
                    color: colorScheme.secondary.withOpacity(0.5),
                    child: Icon(
                      customIcons.loadErrorIcon,
                      size: defaultIconSize,
                      color: colorScheme.secondary,
                    ),
                  ),
              onTap: () {
                state.reLoadImage();
              },
            );
          default:
            return state.completedWidget;
        }
      },
    );
  }
}

class GridViewCachedImage extends StatefulWidget {
  final double? width;
  final double? height;
  final String url;
  final BoxFit boxFit;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool cache;
  final Duration cacheMaxAge;
  const GridViewCachedImage(
      {super.key,
      this.width,
      this.height,
      required this.url,
      this.boxFit = BoxFit.cover,
      this.radius = 15,
      this.placeholder,
      this.errorWidget,
      this.cache = true,
      this.cacheMaxAge = defaultCacheMaxAge});

  @override
  State<GridViewCachedImage> createState() => _GridViewCachedImageState();
}

class _GridViewCachedImageState extends State<GridViewCachedImage>
    with AutomaticKeepAliveClientMixin {
  final DuplicateController duplicateController = Get.find();
  late final CustomIcons customIcons = duplicateController.customIcons;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: ExtendedImage.network(
        cache: widget.cache,
        cacheMaxAge: widget.cacheMaxAge,
        width: widget.width,
        height: widget.height,
        widget.url,
        fit: widget.boxFit,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return widget.placeholder ??
                  SimpleContainer(
                    color: colorScheme.secondary.withOpacity(0.5),
                  );
            case LoadState.failed:
              return GestureDetector(
                child: widget.errorWidget ??
                    SimpleContainer(
                      color: colorScheme.secondary.withOpacity(0.5),
                      child: Icon(
                        customIcons.loadErrorIcon,
                        size: defaultIconSize,
                        color: colorScheme.secondary,
                      ),
                    ),
                onTap: () {
                  state.reLoadImage();
                },
              );
            default:
              return state.completedWidget;
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class WallpapersGridView extends StatelessWidget {
  const WallpapersGridView({
    super.key,
    required this.wallpaperList,
  });

  final List<WallpaperEntity> wallpaperList;

  @override
  Widget build(BuildContext context) {
    final DuplicateController duplicateController = Get.find();
    return Expanded(
      flex: wallpaperGridFlex,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: MasonryGridView.builder(
          padding: defaultItemPadding,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          physics: defaultScrollPhysics,
          itemCount: wallpaperList.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount),
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          itemBuilder: (context, index) {
            final wallpaper = wallpaperList[index];
            return GestureDetector(
              onTap: () async {
                await duplicateController.wallpaperDetailNavigation
                    .goToWallpaperDetailScreen(
                  context: context,
                  wallpaperEntity: wallpaper,
                );
              },
              child: GridViewCachedImage(
                url: wallpaper.coverLink,
                width: wallpaperGridWith,
                boxFit: BoxFit.cover,
                height: wallpaperGridHeght(index: index),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SimpleContainer extends StatelessWidget {
  const SimpleContainer(
      {super.key, required this.color, this.child, this.width, this.height});
  final Color color;
  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width,
      height: height,
      child: child,
    );
  }
}

class CustomCupertinoButton extends StatelessWidget {
  const CustomCupertinoButton(
      {super.key,
      required this.color,
      required this.child,
      required this.callback,
      this.borderRadius,
      this.width = 50,
      this.height = 50});
  final Color color;
  final Widget child;
  final GestureTapCallback callback;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: callback,
        style: TextButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(25))),
        child: Center(child: child),
      ),
    );
  }
}

class CustomBlur extends StatelessWidget {
  const CustomBlur({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: SimpleContainer(
        color: color,
      ),
    );
  }
}

class SimpleLoadingScreen extends StatelessWidget {
  const SimpleLoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoading(color: colorScheme.secondary),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "${appLocalizations.homeLoading}...",
                style: textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WallpapersScreensTitle extends StatelessWidget {
  const WallpapersScreensTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Text(
        title,
        style: textTheme.titleLarge,
      ),
    );
  }
}

class CollectionItem extends StatelessWidget {
  const CollectionItem(
      {super.key,
      required this.callback,
      required this.collection,
      required this.title,
      required this.posterWidth,
      required this.posterHeight,
      this.cahceMaxAge});
  final GestureTapCallback callback;
  final WallpaperCollectionEntity collection;
  final String title;
  final double posterWidth;
  final double posterHeight;
  final Duration? cahceMaxAge;
  final EdgeInsets collectionMargin = const EdgeInsets.only(right: 5, left: 5);
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: collectionMargin,
      height: posterHeight,
      width: posterWidth,
      child: GestureDetector(
        onTap: callback,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GridViewCachedImage(
                cacheMaxAge: cahceMaxAge ?? collectionCahceMaxAge,
                url: collection.collectionCoverUrl,
                width: posterWidth,
                height: posterHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium!.copyWith(
                  backgroundColor: colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxShadow searchBoxShadow(ColorScheme colorScheme) {
  return BoxShadow(
    color: colorScheme.primary,
    blurRadius: 15,
    spreadRadius: 0.1,
    offset: const Offset(1, 1),
  );
}

class CustomLottie extends StatelessWidget {
  const CustomLottie(
      {super.key, required this.path, this.width, this.height, this.boxFit});
  final String path;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: LottieBuilder.asset(
          path,
          fit: boxFit,
        ));
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: defaultCircularRadius,
        color: colorScheme.secondary,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        style: textTheme.bodyMedium!.copyWith(color: colorScheme.background),
      ),
    );
  }
}

class CustomRadio extends StatelessWidget {
  const CustomRadio(
      {super.key,
      required this.callback,
      required this.title,
      required this.value,
      required this.valueNotifier});
  final GestureTapCallback callback;
  final String title;
  final CustomThemeMode value;

  final ValueNotifier<CustomThemeMode> valueNotifier;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: colorScheme.background,
        margin: const EdgeInsets.only(
            top: defaultPaddingValue, bottom: defaultPaddingValue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
                  textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, themeMode, child) {
                final bool isSelected = value == themeMode;
                return Container(
                  alignment: Alignment.center,
                  width: defaultIconSize,
                  height: defaultIconSize,
                  decoration: BoxDecoration(
                    border: !isSelected
                        ? Border.all(
                            color: colorScheme.secondary, width: boxBorderWidth)
                        : null,
                    shape: BoxShape.circle,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.background,
                  ),
                  child: isSelected
                      ? Icon(
                          FontAwesomeIcons.check,
                          color: colorScheme.secondary,
                          size: checkIconSize,
                        )
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

ElevatedButton customButton(
    {required GestureTapCallback callback,
    required ColorScheme colorScheme,
    TextStyle? textStyle,
    required String title}) {
  return ElevatedButton(
    onPressed: callback,
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: customButtonRadius,
      ),
    ),
    child: Text(
      title,
      style: textStyle,
    ),
  );
}

class DuplicateErrorScreen extends StatelessWidget {
  const DuplicateErrorScreen(
      {super.key,
      this.errorMessage,
      this.tryAgain,
      required this.callback,
      this.visibleCallbackButton = true,
      this.resizeToAvoidBottomInset = true,
      this.backgroundColor,
      this.messageColor});
  final String? errorMessage;
  final String? tryAgain;
  final Color? backgroundColor;
  final Color? messageColor;
  final GestureTapCallback callback;
  final bool visibleCallbackButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(defaultPaddingValue),
        child: Column(
          children: [
            const Expanded(
              child: CustomLottie(path: errorLottie, boxFit: BoxFit.contain),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: defaultPaddingValue),
                  child: Text(
                    errorMessage ?? appLocalizations.unknownError,
                    style: textTheme.bodyMedium!
                        .copyWith(color: messageColor ?? colorScheme.secondary),
                    overflow: TextOverflow.clip,
                  ),
                ),
                if (visibleCallbackButton)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: defaultPaddingValue, bottom: defaultPaddingValue),
                    child: customButton(
                        callback: callback,
                        colorScheme: colorScheme,
                        title: tryAgain ?? appLocalizations.tryAgain,
                        textStyle: textTheme.bodyMedium),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final DuplicateController duplicateController = Get.find();
    final CustomIcons customIcons = duplicateController.customIcons;
    return Tooltip(
      message: MaterialLocalizations.of(context).backButtonTooltip,
      child: CupertinoButton(
        child: Icon(
          customIcons.backIcon,
          color: colorScheme.secondary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

AppBar wallpapersScreensAppBar(
    {required String title,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool automaticallyImplementLeading = true,
    Widget? leading}) {
  return AppBar(
      automaticallyImplyLeading: automaticallyImplementLeading,
      backgroundColor: colorScheme.background,
      foregroundColor: colorScheme.secondary,
      elevation: defaultElevation,
      centerTitle: true,
      title: Text(
        title,
        style: textTheme.titleLarge,
      ),
      leading: automaticallyImplementLeading
          ? leading ?? const CustomBackButton()
          : null);
}

AppBar duplicateAppBar(
    {required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String title,
    bool automaticallyImplementLeading = true,
    bool primary = true,
    Widget? leading}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplementLeading,
    leading: automaticallyImplementLeading
        ? leading ?? const CustomBackButton()
        : null,
    primary: primary,
    backgroundColor: colorScheme.background,
    foregroundColor: colorScheme.secondary,
    centerTitle: true,
    title: Text(
      title,
      style: textTheme.bodyLarge,
    ),
    elevation: defaultElevation,
  );
}

AppBar emptyAppBar({required Color backgroundColor}) {
  return AppBar(
      elevation: defaultElevation,
      primary: false,
      backgroundColor: backgroundColor);
}
