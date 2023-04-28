import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: emptyAppBar(backgroundColor: colorScheme.background),
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          Expanded(child: Image.asset(logoImage)),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                height: Get.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLoading(
                        color: colorScheme.secondary,
                        size: loadingAnimationSize),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appLocalization.createdBy,
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Text(
                              creatorName,
                              style: textTheme.bodyMedium!
                                  .copyWith(color: colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
