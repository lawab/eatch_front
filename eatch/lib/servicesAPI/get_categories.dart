/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDataCategoriesFuture = ChangeNotifierProvider<GetDataCategoriesFuture>(
    (ref) => GetDataCategoriesFuture());

class GetDataCategoriesFuture extends ChangeNotifier {
  List<Categorie> listCategories = [];

  GetDataCategoriesFuture() {
    getCategoriesData();
  }
  //RÔLE_Manager

  Future getCategoriesData() async {
    listCategories = [];

    try {
      final String response =
          await rootBundle.loadString('assets/categories_data.json');
      final data = await json.decode(response);

      for (int i = 0; i < data.length; i++) {
        listCategories.add(Categorie.fromJson(data[i]));
      }
    } catch (e) {
      print(e.toString());
    }

    //print(listDataModel.length);
    notifyListeners();
  }
}

class Categorie {
  String? id;
  String? imageUrl;
  String? title;
  int? nombreproduits;
  List<Produits>? produits;

  Categorie(
      {this.id, this.imageUrl, this.title, this.nombreproduits, this.produits});

  Categorie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    nombreproduits = json['nombreproduits'];
    if (json['produits'] != null) {
      produits = <Produits>[];
      json['produits'].forEach((v) {
        produits!.add(Produits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['title'] = title;
    data['nombreproduits'] = nombreproduits;
    if (produits != null) {
      data['produits'] = produits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Produits {
  String? id;
  String? imageUrl;
  String? title;
  double? price;

  Produits({this.id, this.imageUrl, this.title, this.price});

  Produits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['title'] = title;
    data['price'] = price;
    return data;
  }
}
*/
/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataCategoriesFuture = ChangeNotifierProvider<GetDataCategoriesFuture>(
    (ref) => GetDataCategoriesFuture());

class GetDataCategoriesFuture extends ChangeNotifier {
  List<Categorie> listCategories = [];

  GetDataCategoriesFuture() {
    getCategoriesData();
  }
  //RÔLE_Manager

  Future getCategoriesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();

    listCategories = [];

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.11.110:4005/api/categories/fetch/restaurant/$restaurantId'), //13.39.81.126:5000 //192.168.11.110:4008 //restaurant/$restaurantId
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
            listCategories.add(Categorie.fromJson(data[i]));
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    print(listCategories.length);
    notifyListeners();
  }
}

class Categorie {
  String? id;
  String? imageUrl;
  String? title;
  int? nombreproduits;
  List<Produits>? produits;

  Categorie(
      {this.id, this.imageUrl, this.title, this.nombreproduits, this.produits});

  Categorie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    nombreproduits = json['nombreproduits'];
    if (json['produits'] != null) {
      produits = <Produits>[];
      json['produits'].forEach((v) {
        produits!.add(Produits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['title'] = title;
    data['nombreproduits'] = nombreproduits;
    if (produits != null) {
      data['produits'] = produits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Produits {
  String? id;
  String? imageUrl;
  String? title;
  double? price;

  Produits({this.id, this.imageUrl, this.title, this.price});

  Produits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['title'] = title;
    data['price'] = price;
    return data;
  }
}
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataCategoriesFuture = ChangeNotifierProvider<GetDataCategoriesFuture>(
    (ref) => GetDataCategoriesFuture());

class GetDataCategoriesFuture extends ChangeNotifier {
  List<Categorie> listCategories = [];

  GetDataCategoriesFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String adressUrl = prefs.getString('ipport').toString();
    try {
      http.Response response = await http.get(
        Uri.parse('http://192.168.11.110:4005/api/categories/fetch/all'), //4002
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get Categorie');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listCategories.add(Categorie.fromJson(data[i]));
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

class Categorie {
  String? image;
  String? sId;
  String? title;
  List<Products>? products;
  String? userId;
  String? restaurantId;

  Categorie(
      {this.image,
      this.sId,
      this.title,
      this.products,
      this.userId,
      this.restaurantId});

  Categorie.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    sId = json['_id'];
    title = json['title'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    userId = json['user_id'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['_id'] = sId;
    data['title'] = title;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['user_id'] = userId;
    data['restaurant_id'] = restaurantId;
    return data;
  }
}

class Products {
  String? quantity;
  String? image;
  String? price;
  String? productName;
  String? category;
  List<String>? materials;
  String? restaurant;
  String? sCreator;

  Products(
      {this.quantity,
      this.image,
      this.price,
      this.productName,
      this.category,
      this.materials,
      this.restaurant,
      this.sCreator});

  Products.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    image = json['image'];
    price = json['price'];
    productName = json['productName'];
    category = json['category'];
    materials = json['materials'].cast<String>();
    restaurant = json['restaurant'];
    sCreator = json['_creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['image'] = image;
    data['price'] = price;
    data['productName'] = productName;
    data['category'] = category;
    data['materials'] = materials;
    data['restaurant'] = restaurant;
    data['_creator'] = sCreator;
    return data;
  }
}
