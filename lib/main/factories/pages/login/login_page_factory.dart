import '../../../../ui/pages/pages.dart';
import '../../factories.dart';
import 'package:flutter/material.dart';

Widget makeLoginPage(){
  return LoginPage(makeGetxLoginPresenter());
}