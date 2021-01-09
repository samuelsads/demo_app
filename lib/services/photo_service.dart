import 'package:flutter/material.dart';


class PhotoService with ChangeNotifier{
  String _fotoUrl;
  String _uid;

  String get getUid => this._uid;


  set getUid(String uid){
    this._uid  = uid;
    notifyListeners();
  }

  String get getPhoto => this._fotoUrl;

  set getPhoto(String foto){
    this._fotoUrl  = foto;
    notifyListeners();
  }

}