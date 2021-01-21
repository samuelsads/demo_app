import 'package:app_example/preference/preferencias_usuario.dart';
import 'package:app_example/router/routes.dart';
import 'package:app_example/services/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhotoService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo App',
        initialRoute:(prefs.token!='')?'main': 'login',
        routes: appRoutes,
        theme: ThemeData(primaryColor: Color.fromRGBO(125, 64, 4, 1)),
      ),
    );
  }
}
