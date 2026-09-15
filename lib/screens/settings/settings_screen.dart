import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../privacy_policy_screen.dart';
import '../terms_conditions_screen.dart';
import '../about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),


      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Theme"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Select Theme",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),

                            RadioListTile<ThemeMode>(
                              value: ThemeMode.light,
                              groupValue: themeProvider.themeMode,
                              title: const Text("Light"),
                              onChanged: (value) {
                                themeProvider.setTheme(value!);
                                Navigator.pop(context);
                              },
                            ),

                            RadioListTile<ThemeMode>(
                              value: ThemeMode.dark,
                              groupValue: themeProvider.themeMode,
                              title: const Text("Dark"),
                              onChanged: (value) {
                                themeProvider.setTheme(value!);
                                Navigator.pop(context);
                              },
                            ),

                            RadioListTile<ThemeMode>(
                              value: ThemeMode.system,
                              groupValue: themeProvider.themeMode,
                              title: const Text("System Default"),
                              onChanged: (value) {
                                themeProvider.setTheme(value!);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),



          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Terms & Conditions"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsScreen(),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutAppScreen(),
                ),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}