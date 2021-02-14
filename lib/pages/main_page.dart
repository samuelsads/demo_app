import 'dart:convert';
import 'dart:io';

import 'package:app_example/models/usuario.dart';
import 'package:app_example/preference/preferencias_usuario.dart';
import 'package:app_example/providers/db_providers.dart';
import 'package:app_example/services/db_information.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

Future<String> _loadAStudentAsset() async {
  return await rootBundle.loadString('assets/api.json');
}

Future<Usuario> loadStudent() async {
  String jsonString = await _loadAStudentAsset();
  final jsonResponse = json.decode(jsonString);
  Usuario usuario = new Usuario.fromJson(jsonResponse);
  return usuario;
}

class _MainPageState extends State<MainPage> {
  File foto;

  Usuario usuarios = new Usuario(success: true, content: [
    Content(
        uuidSeccion: 455,
        nombre: "4 C1",
        tipoCasilla: "CONTIGUA",
        proceso: [
          Proceso(
            uuidProceso: "1",
            nombre: "Gobernador",
            estatus: 1,
          ),
          Proceso(
            uuidProceso: "2",
            nombre: "Diputados MR",
            estatus: 1,
          ),
          Proceso(
            uuidProceso: "3",
            nombre: "Ayuntamientos",
            estatus: 1,
          ),
          Proceso(
            uuidProceso: "5",
            nombre: "Diputados RP",
            estatus: 1,
          ),
        ]),
  ]);
  /**
      uuidSeccion: "455", nombre: "Norte", estatus: 1, proceso: [
      Proceso(uuidProceso: "12", nombre: "Santa Ana Norte", estatus: 1),
      Proceso(uuidProceso: "13", nombre: "Belen 1 Norte", estatus: 1),
      Proceso(uuidProceso: "14", nombre: "Belen 2 Norte", estatus: 1),
      Proceso(uuidProceso: "15", nombre: "Belen 3 Norte", estatus: 1),
      Proceso(uuidProceso: "16", nombre: "San Juan Norte", estatus: 1)
    ] 
   */

  int currentIndex = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    //final db  = Provider.of<DbInformation>(context, listen: false);
    //db.fillDb();
    print("sam");
    //_checkAndInsertData();
    final usuario = loadStudent();
    final prefs = new PreferenciasUsuario();
    return Scaffold(
      appBar: AppBar(
        title: Text("PREP Casilla"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Usuario',
            onPressed: () {
              Navigator.pushNamed(context, 'account');
              //_processImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Cerrar sessión',
            onPressed: () {
              prefs.token = '';
              Navigator.pushNamed(context, 'login');
              //_processImage(ImageSource.camera);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: loadStudent(),
        builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
          
          if (snapshot.hasData) {
             
            this.usuarios = snapshot.data;
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _loadInformation,
              header: WaterDropHeader(
                complete: Icon(Icons.check, color: Colors.blue[400]),
                waterDropColor: Colors.blue[400],
              ),
              child: _listViewElements(),
            );
            /** 
            final element = snapshot.data;
            if(element.length ==0){ 
              return Center(child:Text('no hay informacion'));
            }
            return Center(child: Text('samuel'),);
            */
          } else {
            return Center(
              child: Text('Cargando...'),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _floatingActionButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),
      ),
    );
  }

  _scanQR(BuildContext context) async {
    dynamic futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }
  }

  _processImage(ImageSource type) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: type,
    );

    if (pickedFile.path != null) {
      foto = File(pickedFile.path);
    }

    setState(() {});
  }

  ListView _listViewElements() {
    loadStudent();
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios.content[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.content.length);
  }

  ListTile _usuarioListTile(Content usuario) {
    return ListTile(
      title: Text(
        usuario.nombre,
        style: TextStyle(fontSize: 20),
      ),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        Navigator.pushNamed(context, 'more', arguments: usuario);
      },
    );
  }

  _loadInformation() async {
    loadStudent();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  _checkAndInsertData() async {
    return DBProvider.db.getAllScans();
  }
}
