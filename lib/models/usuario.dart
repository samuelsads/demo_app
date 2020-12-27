import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        this.uuidSeccion,
        this.nombre,
        this.estatus,
        this.proceso,
    });

    String uuidSeccion;
    String nombre;
    int estatus;
    List<Proceso> proceso;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        uuidSeccion: json["uuid_seccion"],
        nombre: json["nombre"],
        estatus: json["estatus"],
        proceso: List<Proceso>.from(json["proceso"].map((x) => Proceso.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "uuid_seccion": uuidSeccion,
        "nombre": nombre,
        "estatus": estatus,
        "proceso": List<dynamic>.from(proceso.map((x) => x.toJson())),
    };
}

class Proceso {
    Proceso({
        this.uuidProceso,
        this.nombre,
        this.estatus,
    });

    String uuidProceso;
    String nombre;
    int estatus;

    factory Proceso.fromJson(Map<String, dynamic> json) => Proceso(
        uuidProceso: json["uuid_proceso"],
        nombre: json["nombre"],
        estatus: json["estatus"],
    );

    Map<String, dynamic> toJson() => {
        "uuid_proceso": uuidProceso,
        "nombre": nombre,
        "estatus": estatus,
    };
}
