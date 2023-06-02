import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataRsetaurantFuture = ChangeNotifierProvider<GetDataRsetaurantFuture>(
    (ref) => GetDataRsetaurantFuture());

class GetDataRsetaurantFuture extends ChangeNotifier {
  List<Restaurant> listRsetaurant = [];

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
        Uri.parse('http://192.168.1.34:4002/api/restaurants/fetch/all'), //4002
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get restaurant');
      print(response.statusCode);
      //print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        print(data[0]["infos"]["logo"]);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listRsetaurant.add(Restaurant.fromJson(data[i]));
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
  String? createdAt;
  String? updatedAt;
  int? iV;

  Restaurant({
    this.infos,
    this.sId,
    this.restaurantName,
    this.sCreator,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    infos = json['infos'] != null ? new Infos.fromJson(json['infos']) : null;
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.infos != null) {
      data['infos'] = this.infos!.toJson();
    }
    data['_id'] = sId;
    data['restaurant_name'] = restaurantName;
    data['_creator'] = sCreator;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['town'] = town;
    data['address'] = address;
    data['logo'] = logo;
    return data;
  }
}
