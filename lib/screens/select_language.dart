import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageView extends StatelessWidget {
  final english ='English';
  final russian = 'Русский';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                LocalizationKeys.chooseLanguage,
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            _Divider(),
            _SwitchListTileMenuItem(
                title: english,
                subtitle: english,
                locale: context.supportedLocales[0]),
            _Divider(),
            _SwitchListTileMenuItem(
                title: russian,
                subtitle: russian,
                locale: context.supportedLocales[1]),
            _Divider(),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
}

class _SwitchListTileMenuItem extends StatelessWidget {
  const _SwitchListTileMenuItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.locale,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Locale locale;

  bool isSelected(BuildContext context) => locale == context.locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        border:
            isSelected(context) ? Border.all(color: Colors.blueAccent) : null,
      ),
      child: ListTile(
        dense: true,
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        onTap: () async {
          await context.setLocale(locale);
          Navigator.pop(context);
        },
      ),
    );
  }
}
