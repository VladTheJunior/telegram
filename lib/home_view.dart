import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:telegram_app/common_widgets.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:telegram_app/main.dart';
import 'package:telegram_app/process_log_view.dart';

import 'widget/profile_image.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TelegramMainButton _mainButton = tg.MainButton;
  final TelegramBackButton _backButton = tg.BackButton;
  bool isStateStable = true;

  @override
  void initState() {
    onEvent(TelegramWebEventType.settingsButtonClicked, JsVoidCallback(() {
      print("settingsButtonClicked");
      setState(() {});
    }));

    _mainButton.onClick(JsVoidCallback(() {
      // we can also use onEvent(TelegramWebEventType.mainButtonClicked)
      tg.showConfirm("Main Button Clicked");
      setState(() {});
    }));

    _backButton.onClick(JsVoidCallback(() {
      // we can also use onEvent(TelegramWebEventType.backButtonClicked)
      Navigator.of(context).pop();
    }));

    TelegramWebEvent.setThemeChangeListener(
        (bool isDarkMode, ThemeParams themeParams) {
      setState(() {});
      updateThemeMode();
    });

    TelegramWebEvent.setViewPortChangeListener(
        (bool isStable, height, stableHeight) {
      setState(() {
        isStateStable = isStable;
      });
    });

    super.initState();
  }

  void onShowPopup() {
    TelegramPopup(
      title: "Title",
      message: "Message",
      buttons: [
        PopupButton(
          id: "delete",
          type: PopupButtonType.destructive,
          text: "Delete button test",
        ),
        PopupButton(
          id: "faq",
          text: "Open FAQ",
        ),
        PopupButton(
          id: "cancel",
          type: PopupButtonType.cancel,
        ),
      ],
      onTap: (String buttonId) {
        if (buttonId == "cancel") return null;
        if (buttonId == "faq") return tg.openLink("https://telegram.org/faq");
        showAlert("Button $buttonId clicked");
      },
    ).show();
  }

  int selectedIndex = 0;
  bool isExtended = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
       
      ),
       bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.admin_panel_settings_rounded)),
            Tab(icon: Icon(Icons.text_snippet)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
               ProcessLogView(),
       
              Icon(Icons.directions_bike),
            ],
          ),
    ),
  
    );
  }
}
