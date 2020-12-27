import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File foto;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //final photoService = Provider.of<PhotoService>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Cuenta'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[_viewPhotos(), _buttonPhoto()],
                ))),
      ),
    );
  }

  Widget _buttonPhoto() {
    return RaisedButton.icon(
        onPressed: () => _processImage(ImageSource.camera),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        icon: Icon(Icons.camera),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Tomar foto'));
  }

  Widget _viewPhotos() {
    if (foto != null) {
      return Center(child:Image.file(foto, height: MediaQuery.of(context).size.height * 0.8, fit: BoxFit.cover));
    }

    return Center(child:Image.asset('assets/no-image.png'));

    if (foto != null) {
      return new PinchZoomImage(
        image: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: new Image.asset(
            foto.path,
          ),
        ),
        zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
        hideStatusBarWhileZooming: true,
        onZoomStart: () {
          print('Zoom started');
        },
        onZoomEnd: () {
          print('Zoom finished');
        },
      );
    }
    return PinchZoomImage(
      image: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.asset(
          'assets/no-image.png',
        ),
      ),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      onZoomStart: () {
        print('Zoom started');
      },
      onZoomEnd: () {
        print('Zoom finished');
      },
    );
  }

  _processImage(ImageSource type) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: type,
    );

    if (pickedFile.path != null) {
      foto = File(pickedFile.path);
      //await subirImagen(foto);
    }

    setState(() {});
  }



  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'http://192.168.1.77:3000');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse  = await imageUploadRequest.send();

    final resp  = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode!= 201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    print(respData); 
    
    return respData['secure_url'];
  }
}