import '../ui/components/components.dart';
import 'factories/factories.dart';

import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: "Greencity Team",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: makeSplashPage, transition: Transition.fade),
        GetPage(name: "/login", page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: "/surveys", page: () => Scaffold(body: Text("Enquetes"),), transition: Transition.fadeIn)
      ],
    );
  }
}