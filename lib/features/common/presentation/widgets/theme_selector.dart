
import 'package:crafty_bay/app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    //final themeProvider = context.watch<ThemeProvider>();
    return ToggleButtons(
      isSelected: [
        context.read<ThemeProvider>().currentThemeMode == ThemeMode.light,
        context.read<ThemeProvider>().currentThemeMode == ThemeMode.dark,
      ],
      onPressed: (index) {
        switch (index) {
          case 0:
            context.read<ThemeProvider>().changeThemeMode(ThemeMode.light);
            break;
          case 1:
            context.read<ThemeProvider>().changeThemeMode(ThemeMode.dark);
            break;
        }
      },
      borderRadius: BorderRadius.circular(12),
      selectedColor: Colors.white,
      fillColor: Colors.blue,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.light_mode),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.dark_mode),
        ),
      ],
    );
  }
}
