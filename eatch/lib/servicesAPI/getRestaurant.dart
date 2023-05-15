import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    String adress_url = prefs.getString('ipport').toString();
    try {
      http.Response response = await http.get(
        Uri.parse('http://$adress_url/api/restaurants/fetch/all'), //4002
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get restaurant');
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print(data);
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
  Info? info;
  String? sId;
  String? restaurantName;
  String? sCreator;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Restaurant(
      {this.info,
      this.sId,
      this.restaurantName,
      this.sCreator,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Restaurant.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
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
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    data['_id'] = this.sId;
    data['restaurant_name'] = this.restaurantName;
    data['_creator'] = this.sCreator;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Info {
  String? town;
  String? address;
  String? logo;

  Info({this.town, this.address, this.logo});

  Info.fromJson(Map<String, dynamic> json) {
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
