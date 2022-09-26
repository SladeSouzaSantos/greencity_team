import '../../../../ui/pages/pages.dart';
import '../../factories.dart';
import 'package:flutter/material.dart';

Widget makeSplashPage(){
  return SplashPage(presenter: makeGetxSplashPresenter());
}