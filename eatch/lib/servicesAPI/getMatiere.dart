import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataMatiereFuture = ChangeNotifierProvider<GetDataMatiereFuture>(
    (ref) => GetDataMatiereFuture());

class GetDataMatiereFuture extends ChangeNotifier {
  List<Matiere> listMatiere = [];

  GetDataMatiereFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    listMatiere = [];

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:5000/api/materials/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]["deletedAt"] == null) {
            listMatiere.add(Matiere.fromJson(data[i]));
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    print(listMatiere.length);
    notifyListeners();
  }
}

class Matiere {
  String? sId;
  Restaurant? restaurant;
  String? sCreator;
  String? lifetime;
  String? image;
  String? mpName;
  int? quantity;
  int? consumerQuantity;
  int? currentQuantity;
  Null? deletedAt;
  String? unity;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Matiere(
      {this.sId,
      this.restaurant,
      this.sCreator,
      this.lifetime,
      this.image,
      this.mpName,
      this.quantity,
      this.consumerQuantity,
      this.currentQuantity,
      this.deletedAt,
      this.unity,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Matiere.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    sCreator = json['_creator'];
    lifetime = json['lifetime'];
    image = json['image'];
    mpName = json['mp_name'];
    quantity = json['quantity'];
    consumerQuantity = json['consumer_quantity'];
    currentQuantity = json['current_quantity'];
    deletedAt = json['deletedAt'];
    unity = json['unity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['_creator'] = this.sCreator;
    data['lifetime'] = this.lifetime;
    data['image'] = this.image;
    data['mp_name'] = this.mpName;
    data['quantity'] = this.quantity;
    data['consumer_quantity'] = this.consumerQuantity;
    data['current_quantity'] = this.currentQuantity;
    data['deletedAt'] = this.deletedAt;
    data['unity'] = this.unity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Restaurant {
  String? sId;

  Restaurant({this.sId});

  Restaurant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}
