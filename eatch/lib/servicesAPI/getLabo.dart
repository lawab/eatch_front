import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataLaboratoriesFuture =
    ChangeNotifierProvider<GetDataLaboratoriesFuture>(
        (ref) => GetDataLaboratoriesFuture());

class GetDataLaboratoriesFuture extends ChangeNotifier {
  List<Labo> listLabo = [];
  List<Materials> listFINI = [];

  GetDataLaboratoriesFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    //var restaurantId = prefs.getString('idRestaurant').toString();

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.1.105:4015/api/laboratories/fetch/all'), //192.168.1.105 //192.168.1.105:4008
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '******************************************************************');
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //le pref a suprimmer prochainement
        prefs.setString('idLabo', data[0]['_id']);
        for (int i = 0; i < data.length; i++) {
          if (data[i]["deletedAt"] == null) {
            listLabo.add(Labo.fromJson(data[i]));

            for (int j = 0; j < data[i]["materials"].length; j++) {
              if (data[i]["materials"][j]["deletedAt"] == null) {
                listFINI.add(Materials.fromJson(data[i]["materials"][j]));
              }
            }
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
}

class Labo {
  String? sId;
  String? laboName;
  String? adress;
  String? image;
  String? email;
  List<Raws>? raws;
  List<Providers>? providers;
  String? sCreator;
  Null? deletedAt;
  List<Materials>? materials;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Providings>? providings;
  List<Manufacturings>? manufacturings;

  Labo(
      {this.sId,
      this.laboName,
      this.adress,
      this.image,
      this.email,
      this.raws,
      this.providers,
      this.sCreator,
      this.deletedAt,
      this.materials,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.providings,
      this.manufacturings});

  Labo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    laboName = json['labo_name'];
    adress = json['adress'];
    image = json['image'];
    email = json['email'];
    if (json['raws'] != null) {
      raws = <Raws>[];
      json['raws'].forEach((v) {
        raws!.add(new Raws.fromJson(v));
      });
    }
    if (json['providers'] != null) {
      providers = <Providers>[];
      json['providers'].forEach((v) {
        providers!.add(new Providers.fromJson(v));
      });
    }
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(new Materials.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['providings'] != null) {
      providings = <Providings>[];
      json['providings'].forEach((v) {
        providings!.add(new Providings.fromJson(v));
      });
    }
    if (json['manufacturings'] != null) {
      manufacturings = <Manufacturings>[];
      json['manufacturings'].forEach((v) {
        manufacturings!.add(new Manufacturings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['labo_name'] = this.laboName;
    data['adress'] = this.adress;
    data['image'] = this.image;
    data['email'] = this.email;
    if (this.raws != null) {
      data['raws'] = this.raws!.map((v) => v.toJson()).toList();
    }
    if (this.providers != null) {
      data['providers'] = this.providers!.map((v) => v.toJson()).toList();
    }
    data['_creator'] = this.sCreator;
    data['deletedAt'] = this.deletedAt;
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.providings != null) {
      data['providings'] = this.providings!.map((v) => v.toJson()).toList();
    }
    if (this.manufacturings != null) {
      data['manufacturings'] =
          this.manufacturings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Raws {
  String? sId;
  String? title;
  int? available;
  String? unit;
  String? image;
  String? laboratory;
  String? provider;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Raws(
      {this.sId,
      this.title,
      this.available,
      this.unit,
      this.image,
      this.laboratory,
      this.provider,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Raws.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    available = json['available'];
    unit = json['unit'];
    image = json['image'];
    laboratory = json['laboratory'];
    provider = json['provider'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['available'] = this.available;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['laboratory'] = this.laboratory;
    data['provider'] = this.provider;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Providers {
  Creator? cCreator;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? adresse;
  String? image;
  String? laboratory;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Providers(
      {this.cCreator,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.adresse,
      this.image,
      this.laboratory,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Providers.fromJson(Map<String, dynamic> json) {
    cCreator = json['_creator'] != null
        ? new Creator.fromJson(json['_creator'])
        : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    adresse = json['adresse'];
    image = json['image'];
    laboratory = json['laboratory'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cCreator != null) {
      data['_creator'] = this.cCreator!.toJson();
    }
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['adresse'] = this.adresse;
    data['image'] = this.image;
    data['laboratory'] = this.laboratory;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Creator {
  String? sId;
  String? role;
  String? email;
  String? firstName;
  String? lastName;

  Creator({this.sId, this.role, this.email, this.firstName, this.lastName});

  Creator.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['role'] = this.role;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}

class Materials {
  String? sId;
  String? title;
  int? quantity;
  String? lifetime;
  String? image;
  String? unit;
  String? laboratory;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Materials(
      {this.sId,
      this.title,
      this.quantity,
      this.lifetime,
      this.image,
      this.unit,
      this.laboratory,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Materials.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    quantity = json['quantity'];
    lifetime = json['lifetime'];
    image = json['image'];
    unit = json['unit'];
    laboratory = json['laboratory'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['quantity'] = this.quantity;
    data['lifetime'] = this.lifetime;
    data['image'] = this.image;
    data['unit'] = this.unit;
    data['laboratory'] = this.laboratory;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Providings {
  String? provider;
  String? raw;
  int? grammage;
  String? dateProvider;
  String? sId;

  Providings(
      {this.provider, this.raw, this.grammage, this.dateProvider, this.sId});

  Providings.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    raw = json['raw'];
    grammage = json['grammage'];
    dateProvider = json['date_provider'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['raw'] = this.raw;
    data['grammage'] = this.grammage;
    data['date_provider'] = this.dateProvider;
    data['_id'] = this.sId;
    return data;
  }
}

class Manufacturings {
  String? material;
  int? qte;
  String? sId;
  String? dateManufactured;

  Manufacturings({this.material, this.qte, this.sId, this.dateManufactured});

  Manufacturings.fromJson(Map<String, dynamic> json) {
    material = json['material'];
    qte = json['qte'];
    sId = json['_id'];
    dateManufactured = json['date_manufactured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['material'] = this.material;
    data['qte'] = this.qte;
    data['_id'] = this.sId;
    data['date_manufactured'] = this.dateManufactured;
    return data;
  }
}
