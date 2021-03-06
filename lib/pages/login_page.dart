import 'package:app_example/helpers/mostrar_alerta.dart';
import 'package:app_example/preference/preferencias_usuario.dart';
import 'package:app_example/widgets/blue_botton.dart';
import 'package:app_example/widgets/custom_input.dart';
import 'package:app_example/widgets/custom_logo.dart';
import 'package:app_example/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomLogo(
                        image: AssetImage('assets/tag-logo.png'),
                        text: 'PREP Casilla'),
                    _FormState(),
                    Text(
                      'Términos y condiciones de uso',
                      style: TextStyle(),
                    )
                  ],
                ),
              )),
        ));
  }
}

class _FormState extends StatefulWidget {
  @override
  __FormStateState createState() => __FormStateState();
}

class __FormStateState extends State<_FormState> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: <Widget>[
        CustomInput(
          icon: Icons.person,
          placeHolder: 'Usuario',
          keyboardType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),
        CustomInput(
          icon: Icons.lock_outline,
          placeHolder: 'Contraseña',
          textController: passCtrl,
          isPassword: true,
        ),
        //TODO: CREAR BOTON
        BlueBotton(
          text: 'Ingrese',
          onPressed: () async {
            final user = emailCtrl.text.trim();
            final pass = passCtrl.text.trim();

            if (user == "admin" && pass == "123456") {
              // se obtiene el imei
              String imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
              prefs.token = '1';
              Navigator.pushReplacementNamed(context, 'main');
            } else {
              mostrarAlerta(context, "Credenciales incorrectas",
                  "Su usuario o su contraseña son incorrectos");
            }
          },
        ),
      ]),
    );
  }
}
