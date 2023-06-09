import 'dart:convert';

import 'package:flutter/material.dart';
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
    var restaurantId = prefs.getString('idRestaurant').toString();

    listMatiere = [];

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.1.26:4008/api/materials/fetch/restaurant/$restaurantId'), //192.168.1.26 //192.168.1.26:4008
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('response.statusCode');
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

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
  String? deletedAt;
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
        ? Restaurant.fromJson(json['restaurant'])
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['_creator'] = sCreator;
    data['lifetime'] = lifetime;
    data['image'] = image;
    data['mp_name'] = mpName;
    data['quantity'] = quantity;
    data['consumer_quantity'] = consumerQuantity;
    data['current_quantity'] = currentQuantity;
    data['deletedAt'] = deletedAt;
    data['unity'] = unity;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    return data;
  }
}
