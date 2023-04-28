import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/LocalizationFunctions/localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key, required this.appLocalel});
  final Locale appLocalel;
  final InitialController initialController = Get.find();
  final DuplicateController duplicateController = Get.find();
  late final LocalizationFunctions localizationFunctions =
      duplicateController.localizationFunctions;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<String> appLanguagesTranslate = [
      appLocalizations.languageEnglish,
      appLocalizations.languageTurkish,
      appLocalizations.languagePersian
    ];
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: duplicateAppBar(
          colorScheme: colorScheme,
          textTheme: textTheme,
          title: appLocalizations.languageAppLanguage),
      body: SafeArea(
        child: ListView.builder(
          physics: rootScrollPhysics,
          padding: defaultEdgeInsets,
          itemCount: localizationFunctions.applicationLanguages.length,
          itemBuilder: (context, index) {
            final String language =
                localizationFunctions.applicationLanguages[index];
            Locale itemLocale = localizationFunctions.languageLocale[language]!;
            final bool isSlected = itemLocale == appLocalel;
            return ListTile(
              shape: customOutlineBordr,
              onTap: () async {
                await localizationFunctions.setLocale(
                    newLoclae: itemLocale,
                    initialController: initialController,
                    context: context);
              },
              title: Text(
                language,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                appLanguagesTranslate[index],
                style: textTheme.bodySmall,
              ),
              trailing: isSlected
                  ? Icon(
                      FontAwesomeIcons.check,
                      color: colorScheme.primary,
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
