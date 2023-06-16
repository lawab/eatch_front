import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataProduitFuture = ChangeNotifierProvider<GetDataProduitFuture>(
    (ref) => GetDataProduitFuture());

class GetDataProduitFuture extends ChangeNotifier {
  List<Products> listProduit = [];

  GetDataProduitFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    //String adressUrl = prefs.getString('ipport').toString();
    var restaurantid = prefs.getString('idRestaurant');
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.1.34:4003/api/products/fetch/restaurant/$restaurantid'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );

      print(response.statusCode);
      print("Liste des produits ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listProduit.add(Products.fromJson(data[i]));
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

class Products {
  String? sId;
  List<Materials>? materials;
  Restaurant? restaurant;
  Category? category;
  int? price;
  String? sCreator;
  String? productName;
  int? quantity;
  bool? promotion;
  String? devise;
  String? image;
  int? liked;
  int? likedPersonCount;
  String? deletedAt;
  List<Comments>? comments;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Products(
      {this.sId,
      this.materials,
      this.restaurant,
      this.category,
      this.price,
      this.sCreator,
      this.productName,
      this.quantity,
      this.promotion,
      this.devise,
      this.image,
      this.liked,
      this.likedPersonCount,
      this.deletedAt,
      this.comments,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(new Materials.fromJson(v));
      });
    }
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    price = json['price'];
    sCreator = json['_creator'];
    productName = json['productName'];
    quantity = json['quantity'];
    promotion = json['promotion'];
    devise = json['devise'];
    image = json['image'];
    liked = json['liked'];
    likedPersonCount = json['likedPersonCount'];
    deletedAt = json['deletedAt'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['price'] = this.price;
    data['_creator'] = this.sCreator;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['promotion'] = this.promotion;
    data['devise'] = this.devise;
    data['image'] = this.image;
    data['liked'] = this.liked;
    data['likedPersonCount'] = this.likedPersonCount;
    data['deletedAt'] = this.deletedAt;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Materials {
  String? sId;
  String? mpName;
  int? quantity;
  String? lifetime;

  Materials({this.sId, this.mpName, this.quantity, this.lifetime});

  Materials.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mpName = json['mp_name'];
    quantity = json['quantity'];
    lifetime = json['lifetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mp_name'] = this.mpName;
    data['quantity'] = this.quantity;
    data['lifetime'] = this.lifetime;
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

  Infos({this.town, this.address});

  Infos.fromJson(Map<String, dynamic> json) {
    town = json['town'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['town'] = this.town;
    data['address'] = this.address;
    return data;
  }
}

class Category {
  String? sId;
  String? title;
  String? image;

  Category({this.sId, this.title, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['image'] = this.image;
    return data;
  }
}

class Comments {
  String? sId;
  Client? client;
  String? message;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? sCreator;

  Comments(
      {this.sId,
      this.client,
      this.message,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.sCreator});

  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    message = json['message'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    sCreator = json['_creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    data['message'] = this.message;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['_creator'] = this.sCreator;
    return data;
  }
}

class Client {
  String? sId;
  String? fisrtName;
  String? lastName;
  bool? isOnline;
  String? phoneNumber;

  Client(
      {this.sId,
      this.fisrtName,
      this.lastName,
      this.isOnline,
      this.phoneNumber});

  Client.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fisrtName = json['fisrtName'];
    lastName = json['lastName'];
    isOnline = json['isOnline'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fisrtName'] = this.fisrtName;
    data['lastName'] = this.lastName;
    data['isOnline'] = this.isOnline;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
