import 'package:app_example/models/usuario.dart';
import 'package:app_example/services/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoreInformationPage extends StatefulWidget {
  @override
  _MoreInformationPageState createState() => _MoreInformationPageState();
}

class _MoreInformationPageState extends State<MoreInformationPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Content usuario;

  @override
  Widget build(BuildContext context) {
    final Content userData = ModalRoute.of(context).settings.arguments;
    if (userData != null) {
      usuario = userData;
    }
    
    return Scaffold(
        appBar: AppBar(
          title: Text(usuario.nombre),
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
        ));
  }

  ListView _listViewElements() {
    final photoService  = Provider.of<PhotoService>(context, listen: true);
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuario.proceso[i], photoService),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuario.proceso.length);
  }

  ListTile _usuarioListTile(Proceso proceso, PhotoService photoService) {
    return ListTile(
      title: Text(proceso.nombre, style:TextStyle(fontSize: 20)),
      trailing: Icon(Icons.photo_camera, color: (proceso.uuidProceso != photoService.getUid)?Colors.red:Colors.green[300],),
      onTap: () {
        if(proceso.uuidProceso != photoService.getUid){
          Navigator.pushNamed(context, 'account', arguments: proceso);
        }
      },
    );
  }

  _loadInformation() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _listViewElements();
    _refreshController.refreshCompleted();
  }
}
