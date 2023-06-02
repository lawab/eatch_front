import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataMenuFuture =
    ChangeNotifierProvider<GetDataMenuFuture>((ref) => GetDataMenuFuture());

class GetDataMenuFuture extends ChangeNotifier {
  List<Menu> listMenu = [];

  GetDataMenuFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();

    listMenu = [];

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.1.34:4008/api/menus/fetch/restaurant/$restaurantId'), //192.168.1.34 //192.168.1.34:4008
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
            listMenu.add(Menu.fromJson(data[i]));
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    print(listMenu.length);
    notifyListeners();
  }
}

class Menu {
  String? menuTitle;
  String? image;
  String? restaurant;
  String? sCreator;
  String? products;

  Menu(
      {this.menuTitle,
      this.image,
      this.restaurant,
      this.sCreator,
      this.products});

  Menu.fromJson(Map<String, dynamic> json) {
    menuTitle = json['menu_title'];
    image = json['image'];
    restaurant = json['restaurant'];
    sCreator = json['_creator'];
    products = json['products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_title'] = this.menuTitle;
    data['image'] = this.image;
    data['restaurant'] = this.restaurant;
    data['_creator'] = this.sCreator;
    data['products'] = this.products;
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
