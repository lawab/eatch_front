import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataRsetaurantFuture = ChangeNotifierProvider<GetDataRsetaurantFuture>(
    (ref) => GetDataRsetaurantFuture());

class GetDataRsetaurantFuture extends ChangeNotifier {
  List<Restaurant> listRsetaurant = [];

  List<Providings> listApprovisionnement = [];

  GetDataRsetaurantFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String adressUrl = prefs.getString('ipport').toString();
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:4002/api/restaurants/fetch/all'), //4002 //13.39.81.126:4002
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get restaurant');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listRsetaurant.add(Restaurant.fromJson(data[i]));
            for (int j = 0; j < data[i]['providings'].length; j++) {
              listApprovisionnement
                  .add(Providings.fromJson(data[i]['providings'][j]));
            }
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    //print(listDataModel.length);
    notifyListeners();
  }
}

class Restaurant {
  Infos? infos;
  String? sId;
  String? restaurantName;
  String? sCreator;
  Null? deletedAt;
  List<Providings>? providings;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Restaurant(
      {this.infos,
      this.sId,
      this.restaurantName,
      this.sCreator,
      this.deletedAt,
      this.providings,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Restaurant.fromJson(Map<String, dynamic> json) {
    infos = json['infos'] != null ? new Infos.fromJson(json['infos']) : null;
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
    if (json['providings'] != null) {
      providings = <Providings>[];
      json['providings'].forEach((v) {
        providings!.add(new Providings.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.infos != null) {
      data['infos'] = this.infos!.toJson();
    }
    data['_id'] = this.sId;
    data['restaurant_name'] = this.restaurantName;
    data['_creator'] = this.sCreator;
    data['deletedAt'] = this.deletedAt;
    if (this.providings != null) {
      data['providings'] = this.providings!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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

class Providings {
  Material? material;
  Laboratory? laboratory;
  int? qte;
  String? dateProviding;
  bool? validated;
  String? dateValidated;
  String? sId;

  Providings(
      {this.material,
      this.laboratory,
      this.qte,
      this.dateProviding,
      this.validated,
      this.dateValidated,
      this.sId});

  Providings.fromJson(Map<String, dynamic> json) {
    material = json['material'] != null
        ? new Material.fromJson(json['material'])
        : null;
    laboratory = json['laboratory'] != null
        ? new Laboratory.fromJson(json['laboratory'])
        : null;
    qte = json['qte'];
    dateProviding = json['date_providing'];
    validated = json['validated'];
    dateValidated = json['date_validated'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.material != null) {
      data['material'] = this.material!.toJson();
    }
    if (this.laboratory != null) {
      data['laboratory'] = this.laboratory!.toJson();
    }
    data['qte'] = this.qte;
    data['date_providing'] = this.dateProviding;
    data['validated'] = this.validated;
    data['date_validated'] = this.dateValidated;
    data['_id'] = this.sId;
    return data;
  }
}

class Material {
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

  Material(
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

  Material.fromJson(Map<String, dynamic> json) {
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

class Laboratory {
  String? laboName;
  String? adress;
  String? image;
  String? email;

  Laboratory({this.laboName, this.adress, this.image, this.email});

  Laboratory.fromJson(Map<String, dynamic> json) {
    laboName = json['labo_name'];
    adress = json['adress'];
    image = json['image'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labo_name'] = this.laboName;
    data['adress'] = this.adress;
    data['image'] = this.image;
    data['email'] = this.email;
    return data;
  }
}
