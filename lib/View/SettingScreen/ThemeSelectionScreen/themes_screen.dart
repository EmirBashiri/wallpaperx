import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/Themes/themes.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/ThemeFunctions/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key, required this.customThemeMode});
  final CustomThemeMode customThemeMode;

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  late final ValueNotifier<CustomThemeMode> valueNotifier =
      ValueNotifier(widget.customThemeMode);
  final DuplicateController duplicateController = Get.find();
  late ThemeFunctions themeFunctions = duplicateController.themeFunctions;
  final InitialController initialController = Get.find();
  late CustomThemes customThemes = initialController.customThemes;

  Future<void> changeTheme(
      {required CustomThemeMode themeMode,
      required ThemeData themeData,
      required ThemeFunctions themeFunctions,
      required InitialController initialController}) async {
    await themeFunctions.setTheme(
        themeMode: themeMode,
        themeData: themeData,
        initialController: initialController);

    valueNotifier.value = themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: duplicateAppBar(
          colorScheme: colorScheme,
          textTheme: textTheme,
          title: appLocalizations.themeSetTheme),
      body: Padding(
        padding: defaultEdgeInsets,
        child: Column(
          children: [
            CustomRadio(
              title: appLocalizations.themeLight,
              value: CustomThemeMode.defaultLight,
              valueNotifier: valueNotifier,
              callback: () async {
                await changeTheme(
                    themeMode: CustomThemeMode.defaultLight,
                    themeData: customThemes.defaultLightTheme,
                    themeFunctions: themeFunctions,
                    initialController: initialController);
              },
            ),
            CustomRadio(
              title: appLocalizations.themeDark,
              value: CustomThemeMode.defaultDark,
              valueNotifier: valueNotifier,
              callback: () async {
                await changeTheme(
                    themeMode: CustomThemeMode.defaultDark,
                    themeData: customThemes.defaultDarkTheme,
                    themeFunctions: themeFunctions,
                    initialController: initialController);
              },
            ),
            CustomRadio(
              title: appLocalizations.themeSystemDefault,
              value: CustomThemeMode.systemDefault,
              valueNotifier: valueNotifier,
              callback: () async {
                await changeTheme(
                    themeMode: CustomThemeMode.systemDefault,
                    themeData: initialController.initialTheme,
                    themeFunctions: themeFunctions,
                    initialController: initialController);
              },
            ),
          ],
        ),
      ),
    );
  }
}
