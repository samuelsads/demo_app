import 'package:app_example/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoreInformationPage extends StatefulWidget {
  @override
  _MoreInformationPageState createState() => _MoreInformationPageState();
}

class _MoreInformationPageState extends State<MoreInformationPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final Usuario userData = ModalRoute.of(context).settings.arguments;
    if (userData != null) {
      usuario = userData;
    }
    
    return Scaffold(
        appBar: AppBar(
          title: Text("Procesos"),
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
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuario.proceso[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuario.proceso.length);
  }

  ListTile _usuarioListTile(Proceso proceso) {
    return ListTile(
      title: Text(proceso.nombre),
      subtitle: Text(proceso.nombre),
      leading: CircleAvatar(
        child: Text(proceso.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[200],
      ),
      onTap: () {},
    );
  }

  _loadInformation() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
