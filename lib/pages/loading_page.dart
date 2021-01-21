import 'package:app_example/pages/login_page.dart';
import 'package:app_example/pages/main_page.dart';
import 'package:app_example/preference/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    //final prefs= new PreferenciasUsuario();
    //print("samuel is here");
    //print(prefs.token);
    if(true){
      Navigator.pushNamedAndRemoveUntil(context, "main", (Route<dynamic> route) => false);
    }else{
      Navigator.pushNamedAndRemoveUntil(context, "login", (Route<dynamic> route) => false);
    }

  }
}
