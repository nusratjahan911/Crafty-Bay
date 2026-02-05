import 'package:crafty_bay/app/extentions/localization_extention.dart';
import 'package:crafty_bay/features/common/presentation/provider/main_nav_holder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_colors.dart';
import '../common/presentation/widgets/language_selector.dart';
import '../common/presentation/widgets/theme_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<MainNavHolderProvider>().backToHome();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 3,
              color: Colors.white,
              shadowColor: AppColours.themeColor.withAlpha(50),
              child: Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Language',style: textTheme.bodyLarge,),
                    SizedBox(width: 100),
                    LanguageSelector(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 3,
              color: Colors.white,
              shadowColor: AppColours.themeColor.withAlpha(50),
              child: Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Theme',style: textTheme.bodyLarge,),
                    SizedBox(width: 180),
                    ThemeSelector()
                  ],
                ),
              ),
            ),
            Text(context.localizations.hello),

          ],
        ),
      ),
    );
  }

}
