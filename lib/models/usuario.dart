// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        this.success,
        this.content,
        this.error,
        this.errorDescription,
    });

    bool success;
    List<Content> content;
    String error;
    dynamic errorDescription;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        success: json["Success"],
        content: List<Content>.from(json["Content"].map((x) => Content.fromJson(x))),
        error: json["Error"],
        errorDescription: json["ErrorDescription"],
    );

    Map<String, dynamic> toJson() => {
        "Success": success,
        "Content": List<dynamic>.from(content.map((x) => x.toJson())),
        "Error": error,
        "ErrorDescription": errorDescription,
    };
}

class Content {
    Content({
        this.uuidSeccion,
        this.tipoCasilla,
        this.nombre,
        this.proceso,
    });

    int uuidSeccion;
    String tipoCasilla;
    String nombre;
    List<Proceso> proceso;

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        uuidSeccion: json["uuid_seccion"],
        tipoCasilla: json["tipo_casilla"],
        nombre: json["nombre"],
        proceso: List<Proceso>.from(json["proceso"].map((x) => Proceso.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "uuid_seccion": uuidSeccion,
        "tipo_casilla": tipoCasilla,
        "nombre": nombre,
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
