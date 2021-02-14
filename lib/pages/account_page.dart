import 'dart:convert';
import 'dart:io';

import 'package:app_example/models/usuario.dart';
import 'package:app_example/services/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File foto;
  Proceso proceso;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    proceso  = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(proceso.nombre),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[_viewPhotos(),Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       _buttonPhoto(),_buttonSendPhoto()
                    ],
                  )],
                ))),
      ),
    );
  }
  Widget _buttonSendPhoto(){
    return RaisedButton.icon(
        onPressed: () => _sendPhoto(),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        icon: Icon(Icons.send),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Enviar foto'));

  }

  _sendPhoto() async{
    await subirImagen(foto, proceso.uuidProceso);
      final photoService = Provider.of<PhotoService>(context, listen: false);
      photoService.getUid = proceso.uuidProceso;
      photoService.getUid;
      Navigator.of(context).pop();
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
  }

  _processImage(ImageSource type) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: type,
    );

    if (pickedFile != null && pickedFile.path != null) {
      foto = File(pickedFile.path);
      Directory dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      final String path = dir.path;
      final File newImage = await foto.copy('$path/image1.png');
      foto = newImage;
    }

    setState(() {});
  }



  Future<String> subirImagen(File imagen, String uid) async {
    //final url = Uri.parse(
    //    'http://192.168.1.77:3000');

  DateTime now = DateTime.now();
  final currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
  //current time
  print(currentTime);
    final url = Uri.parse(
        'http://gfhjk-env.eba-mpvxbqa4.us-east-1.elasticbeanstalk.com/file');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    imageUploadRequest.fields['data'] =uid;

    final file = await http.MultipartFile.fromPath('photo', imagen.path,
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
