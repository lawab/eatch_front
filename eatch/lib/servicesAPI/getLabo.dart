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
  List<RequestMaterials> listRequest = [];

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
            for (int j = 0; j < data[i]["requestMaterials"].length; j++) {
              if (data[i]["requestMaterials"][j]["deletedAt"] == null) {
                listRequest.add(
                    RequestMaterials.fromJson(data[i]["requestMaterials"][j]));
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
  List<Null>? providers;
  String? sCreator;
  Null? deletedAt;
  List<Materials>? materials;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Providings>? providings;
  List<Manufacturings>? manufacturings;
  List<RequestMaterials>? requestMaterials;

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
      this.manufacturings,
      this.requestMaterials});

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
    /*if (json['providers'] != null) {
      providers = <Null>[];
      json['providers'].forEach((v) {
        providers!.add(new Null.fromJson(v));
      });
    }*/
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
    if (json['requestMaterials'] != null) {
      requestMaterials = <RequestMaterials>[];
      json['requestMaterials'].forEach((v) {
        requestMaterials!.add(new RequestMaterials.fromJson(v));
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
    /*if (this.providers != null) {
      data['providers'] = this.providers!.map((v) => v.toJson()).toList();
    }*/
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
    if (this.requestMaterials != null) {
      data['requestMaterials'] =
          this.requestMaterials!.map((v) => v.toJson()).toList();
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

class Materials {
  String? sId;
  String? title;
  int? quantity;
  String? unit;
  String? lifetime;
  String? image;
  String? laboratory;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Materials(
      {this.sId,
      this.title,
      this.quantity,
      this.unit,
      this.lifetime,
      this.image,
      this.laboratory,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Materials.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    quantity = json['quantity'];
    unit = json['unit'];
    lifetime = json['lifetime'];
    image = json['image'];
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
    data['unit'] = this.unit;
    data['lifetime'] = this.lifetime;
    data['image'] = this.image;
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
  String? dateManufactured;
  String? sId;

  Manufacturings({this.material, this.qte, this.dateManufactured, this.sId});

  Manufacturings.fromJson(Map<String, dynamic> json) {
    material = json['material'];
    qte = json['qte'];
    dateManufactured = json['date_manufactured'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['material'] = this.material;
    data['qte'] = this.qte;
    data['date_manufactured'] = this.dateManufactured;
    data['_id'] = this.sId;
    return data;
  }
}

class RequestMaterials {
  String? requestId;
  Materials? material;
  Restaurant? restaurant;
  int? qte;
  String? dateProviding;
  bool? validated;
  String? dateValidated;
  String? sId;

  RequestMaterials(
      {this.requestId,
      this.material,
      this.restaurant,
      this.qte,
      this.dateProviding,
      this.validated,
      this.dateValidated,
      this.sId});

  RequestMaterials.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    material = json['material'] != null
        ? new Materials.fromJson(json['material'])
        : null;
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    qte = json['qte'];
    dateProviding = json['date_providing'];
    validated = json['validated'];
    dateValidated = json['date_validated'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    if (this.material != null) {
      data['material'] = this.material!.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['qte'] = this.qte;
    data['date_providing'] = this.dateProviding;
    data['validated'] = this.validated;
    data['date_validated'] = this.dateValidated;
    data['_id'] = this.sId;
    return data;
  }
}

class Restaurant {
  String? sId;
  String? restaurantName;
  Infos? infos;

  Restaurant({this.sId, this.restaurantName, this.infos});

  Restaurant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
    infos = json['infos'] != null ? new Infos.fromJson(json['infos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['restaurant_name'] = this.restaurantName;
    if (this.infos != null) {
      data['infos'] = this.infos!.toJson();
    }
    return data;
  }
}

class Infos {
  String? town;
  String? address;
  String? logo;

  Infos({this.town, this.address, this.logo});

  Infos.fromJson(Map<String, dynamic> json) {
    town = json['town'];
    address = json['address'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['town'] = this.town;
    data['address'] = this.address;
    data['logo'] = this.logo;
    return data;
  }
}
