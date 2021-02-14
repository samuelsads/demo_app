import 'dart:io';
import 'package:app_example/models/usuario.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database>get database async{
    if(_database != null) return  _database;

    _database = await initDB();

    return _database;
  }

  initDB()async{
    Directory documentsDirectory  = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,'prep.db');
    print("samuel");
    print(path);
    return await openDatabase(
      path,
      version: 14,
      onOpen: (db){},
      onCreate: (Database db, int version)async{
          await db.execute(
            'CREATE TABLE casillas ('
            'uuid_seccion INTEGER PRIMARY KEY,'
            'tipo_casilla TEXT,'
            'nombre TEXT'
            ')'
          );

          await db.execute(
            'CREATE TABLE procesos ('
            'uuid_proceso TEXT PRIMARY KEY,'
            'nombre TEXT,'
            'estatus INTEGER,'
            'uuid_seccion INTEGER,'
            'FOREIGN KEY(uuid_seccion) REFERENCES casillas(uuid_seccion)'
            ')'
          );

          await db.execute(
            'CREATE TABLE offline_process ('
            'id INTEGER PRIMARY KEY,'
            'uuid_proceso TEXT,'
            'date_time TEXT,'
            'path TEXT,'
            'imei TEXT,'
            'FOREIGN KEY(uuid_proceso) REFERENCES procesos(uuid_proceso)'
            ')'
          );
        }
      );
  }

  Future<List<Content>>getAllScans() async{
    final db  = await database;
    final res = await db.query('casillas');
    print(res[0]);
    res.map((e) {
      print("samuel is here");
      print(e);
    });
    List<Content> list  = res.isNotEmpty ? 
                              res.map((c) => Content.fromJson(c))
                                .toList():
                              [];
                              print(list);
    return list;
  }


  nuevaCasilla(Content content)async{
    print(content);
    final db  = await database;
    final  res = await db.rawInsert(
      "INSERT INTO casillas (uuid_seccion, tipo_casilla, nombre) "
      "VALUES (${ content.uuidSeccion }, '${content.tipoCasilla}', '${content.nombre}' )"
    );
    return res;
  }

  nuevoProceso(Proceso proceso)async{
    print(proceso);
    final db = await database;
    final res  = await db.insert('procesos', proceso.toJson());
    return res;
  }

}