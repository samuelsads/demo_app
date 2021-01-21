import 'package:app_example/pages/account_page.dart';
import 'package:app_example/pages/loading_page.dart';
import 'package:app_example/pages/login_page.dart';
import 'package:app_example/pages/main_page.dart';
import 'package:app_example/pages/more_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes  ={
  'login':(_)=>LoginPage(),
  'main':(_)=>MainPage(),
  'account':(_)=>AccountPage(),
  'more':(_)=>MoreInformationPage(),
  'loading':(_)=>LoadingPage(),
};