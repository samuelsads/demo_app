import 'package:app_example/router/routes.dart';
import 'package:app_example/services/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_)=> PhotoService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title:'Demo App',
        initialRoute: 'login',
        routes: appRoutes,
        theme:ThemeData(primaryColor: Color.fromRGBO(125, 64, 4,1) ),
      ),
      
    );
  }
}