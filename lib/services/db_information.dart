import 'dart:convert';

import 'package:app_example/models/usuario.dart';
import 'package:app_example/providers/db_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DbInformation with ChangeNotifier {
  Future<String> _loadJson() async {
    return await rootBundle.loadString('assets/api.json');
  }

  Future<Usuario> _readJson() async {
    String jsonString = await _loadJson();
    final jsonResponse = json.decode(jsonString);
    Usuario usuario = new Usuario.fromJson(jsonResponse);
    return usuario;
  }

  Future<bool> fillDb() async {
    Usuario usuario = await _readJson();
     List<Content> information = usuario.content;
     information.forEach((element) {
       Content result  = element;
       DBProvider.db.nuevaCasilla( result);
       List<Proceso> procesos  = result.proceso;
        procesos.forEach((proceso){
          proceso.uuidSeccion = element.uuidSeccion;
          //DBProvider.db.nuevoProceso(proceso); 
          });
       print("samuel, todo resuelto");
      });
    notifyListeners();
    return true;
  }
}
