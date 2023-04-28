import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/Icons/icons.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/setting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final double wallpaperLogoWidth = 250;
  final EdgeInsetsGeometry settingMainItemsPadding =
      defaultEdgeInsets.add(const EdgeInsets.only(top: 5));

  double wallpaperLogoHeight() {
    final height = Get.height;
    if (height.lessThan(750)) {
      return 120;
    } else if (height.lessThan(900)) {
      return 150;
    } else {
      return 170;
    }
  }

  final DuplicateController duplicateController = Get.find();

  late final CustomIcons customIcons = duplicateController.customIcons;
  late final settingAppBarBottomSize =
      Size.fromHeight(wallpaperLogoHeight() + 30);
  @override
  void initState() {
    duplicateController.customToast.initializeToast(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final DuplicateController duplicateController = Get.find();
    final SettingScreenFunctions settingFunctions =
        duplicateController.settingFunctions;
    final String errorMessage = appLocalizations.unknownError;

    return Padding(
      padding: Get.mediaQuery.padding,
      child: Scaffold(
        primary: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: colorScheme.background,
        appBar: settingAppBar(
            colorScheme: colorScheme,
            textTheme: textTheme,
            title: appLocalizations.settingSetting,
            appName: appLocalizations.appName),
        body: CustomScrollView(
          physics: defaultScrollPhysics,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: settingMainItemsPadding,
                child: Column(
                  children: [
                    SettingItem(
                      title: appLocalizations.settingLanguage,
                      iconData: customIcons.languageIcon,
                      callBack: () async {
                        await duplicateController.languageSelectionNavigation
                            .goToLanguageScreen(
                                context: context,
                                localizationFunctions:
                                    duplicateController.localizationFunctions);
                      },
                    ),
                    SettingItem(
                      title: appLocalizations.settingThemes,
                      iconData: customIcons.themeIcon,
                      callBack: () async {
                        await duplicateController.themeSelectionNavigation
                            .goToThemeSelectionScreen(
                                context: context,
                                themeFunctions:
                                    duplicateController.themeFunctions);
                      },
                    ),
                    SettingItem(
                      title: appLocalizations.settingShare,
                      iconData: customIcons.shareIcon,
                      callBack: () async {
                        await customLaunch(
                          callback: settingFunctions.shareApp(
                              title: appLocalizations.appName,
                              errorMessage: errorMessage),
                          duplicateController: duplicateController,
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        );
                      },
                    ),
                    SettingItem(
                      title: appLocalizations.settingPrivacyPolicy,
                      iconData: customIcons.privacyPolicy,
                      callBack: () async {
                        await customLaunch(
                          callback: settingFunctions.launchPrivacyPolicyPage(
                              errorMessage: errorMessage),
                          duplicateController: duplicateController,
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        );
                      },
                    ),
                    SettingItem(
                      title: appLocalizations.settingContactUs,
                      iconData: customIcons.contactUsIcon,
                      callBack: () async {
                        Get.bottomSheet(
                          BottomSheet(
                            constraints: BoxConstraints(
                              maxHeight: bottomSheetMaxHeight(
                                  screenHeight: Get.height),
                            ),
                            backgroundColor: colorScheme.shadow,
                            shape: bottomSheetShape,
                            onClosing: () {},
                            builder: (context) {
                              return SizedBox(
                                width: Get.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: defaultPaddingValue),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await customLaunch(
                                            callback: settingFunctions
                                                .saveEmailInClipboard(
                                              errorMessage: errorMessage,
                                              result: appLocalizations
                                                  .settingEmailSaveMessage,
                                            ),
                                            duplicateController:
                                                duplicateController,
                                            textTheme: textTheme,
                                            colorScheme: colorScheme,
                                          );
                                          Get.back();
                                        },
                                        child: Text(
                                          contactEmail,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: defaultPaddingValue,
                                          bottom: defaultPaddingValue),
                                      child: customButton(
                                        callback: () async {
                                          customLaunch(
                                            callback: settingFunctions
                                                .launchNativeEmail(
                                                    errorMessage: errorMessage),
                                            duplicateController:
                                                duplicateController,
                                            textTheme: textTheme,
                                            colorScheme: colorScheme,
                                          );
                                          Get.back();
                                        },
                                        colorScheme: colorScheme,
                                        textStyle: textTheme.bodyMedium,
                                        title:
                                            appLocalizations.settingSendEmail,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> customLaunch({
    required Future<String> callback,
    required DuplicateController duplicateController,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) async {
    final String message = await callback;
    if (message.isNotEmpty) {
      duplicateController.customToast.showToast(
        toastGravity: ToastGravity.CENTER,
        child: ToastWidget(title: message),
      );
    }
  }

  AppBar settingAppBar({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String title,
    required String appName,
    bool primary = true,
    Widget? leading,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      primary: primary,
      backgroundColor: colorScheme.background,
      foregroundColor: colorScheme.secondary,
      centerTitle: true,
      title: Text(
        title,
        style: textTheme.bodyLarge,
      ),
      elevation: defaultElevation,
      bottom: PreferredSize(
        preferredSize: settingAppBarBottomSize,
        child: Center(
          child: Column(
            children: [
              Image.asset(
                logoImage,
                width: wallpaperLogoWidth,
                height: wallpaperLogoHeight(),
                fit: BoxFit.cover,
              ),
              Text(
                appName,
                style:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem(
      {super.key,
      required this.title,
      required this.iconData,
      required this.callBack});
  final String title;
  final IconData iconData;
  final void Function() callBack;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: ListTile(
        shape: customOutlineBordr,
        leading: CircleAvatar(
            backgroundColor: colorScheme.primary,
            child: Icon(
              iconData,
              color: colorScheme.secondary,
              size: defaultIconSize,
            )),
        title: Text(
          title,
          style: textTheme.bodyMedium,
        ),
        onTap: callBack,
      ),
    );
  }
}
