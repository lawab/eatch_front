import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final getDataRecettesFuture = ChangeNotifierProvider<GetDataRecettesFuture>(
    (ref) => GetDataRecettesFuture());

class GetDataRecettesFuture extends ChangeNotifier {
  List<Recette> listRecette = [];

  GetDataRecettesFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String adressUrl = prefs.getString('ipport').toString();
    try {
      http.Response response = await http.get(
        Uri.parse('http://192.168.1.34:4010/api/recettes/fetch/all'), //4002
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get Recette');
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("r10000000ecette data ${response.body}");
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listRecette.add(Recette.fromJson(data[i]));
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

class Recette {
  String? sId;
  String? title;
  String? image;
  String? description;
  List<Engredients>? engredients;
  String? sCreator;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Recette(
      {this.sId,
      this.title,
      this.image,
      this.description,
      this.engredients,
      this.sCreator,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Recette.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    if (json['engredients'] != null) {
      engredients = <Engredients>[];
      json['engredients'].forEach((v) {
        engredients!.add(new Engredients.fromJson(v));
      });
    }
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    if (this.engredients != null) {
      data['engredients'] = this.engredients!.map((v) => v.toJson()).toList();
    }
    data['_creator'] = this.sCreator;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Engredients {
  String? unity;
  Material? material;
  int? grammage;
  String? sId;

  Engredients(param0, {this.unity, this.material, this.grammage, this.sId});

  Engredients.fromJson(Map<String, dynamic> json) {
    unity = json['unity'];
    material = json['material'] != null
        ? new Material.fromJson(json['material'])
        : null;
    grammage = json['grammage'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unity'] = this.unity;
    if (this.material != null) {
      data['material'] = this.material!.toJson();
    }
    data['grammage'] = this.grammage;
    data['_id'] = this.sId;
    return data;
  }
}

class Material {
  Restaurant? restaurant;
  String? lifetime;
  String? mpName;
  int? quantity;
  int? minQuantity;
  String? deletedAt;
  String? sId;

  Material(
      {this.restaurant,
      this.lifetime,
      this.mpName,
      this.quantity,
      this.minQuantity,
      this.deletedAt,
      this.sId});

  Material.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    lifetime = json['lifetime'];
    mpName = json['mp_name'];
    quantity = json['quantity'];
    minQuantity = json['min_quantity'];
    deletedAt = json['deletedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['lifetime'] = this.lifetime;
    data['mp_name'] = this.mpName;
    data['quantity'] = this.quantity;
    data['min_quantity'] = this.minQuantity;
    data['deletedAt'] = this.deletedAt;
    data['_id'] = this.sId;
    return data;
  }
}

class Restaurant {
  Infos? infos;
  String? restaurantName;
  String? deletedAt;
  String? sId;

  Restaurant({this.infos, this.restaurantName, this.deletedAt, this.sId});

  Restaurant.fromJson(Map<String, dynamic> json) {
    infos = json['infos'] != null ? new Infos.fromJson(json['infos']) : null;
    restaurantName = json['restaurant_name'];
    deletedAt = json['deletedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.infos != null) {
      data['infos'] = this.infos!.toJson();
    }
    data['restaurant_name'] = this.restaurantName;
    data['deletedAt'] = this.deletedAt;
    data['_id'] = this.sId;
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
