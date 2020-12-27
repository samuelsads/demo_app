import 'package:flutter/material.dart';


class PhotoService with ChangeNotifier{
  String _fotoUrl;

  String get getPhoto => this._fotoUrl;

  set getPhoto(String foto){
    this._fotoUrl  = foto;
    notifyListeners();
  }

}