import 'dart:convert';
import 'dart:io';

import 'package:app_example/models/usuario.dart';
import 'package:app_example/pages/account_page.dart';
import 'package:app_example/pages/more_information_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File foto;

  List<Usuario> usuarios = [
    Usuario(uuidSeccion: "455", nombre: "Norte", estatus: 1, proceso: [
      Proceso(uuidProceso: "12", nombre: "Santa Ana Norte", estatus: 1),
      Proceso(uuidProceso: "13", nombre: "Belen 1 Norte", estatus: 1),
      Proceso(uuidProceso: "14", nombre: "Belen 2 Norte", estatus: 1),
      Proceso(uuidProceso: "14", nombre: "Belen 2 Norte", estatus: 1),
      Proceso(uuidProceso: "15", nombre: "San Juan Norte", estatus: 1)
    ])
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo App"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Usuario',
            onPressed: () {
              Navigator.pushNamed(context, 'account');
              //_processImage(ImageSource.camera);
            },
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadInformation,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewElements(),
      ),
    );
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
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.nombre),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[200],
      ),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        Navigator.pushNamed(context, 'more', arguments: usuario);
      },
    );
  }

  _loadInformation() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
