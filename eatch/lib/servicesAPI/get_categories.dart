import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataCategoriesFuture = ChangeNotifierProvider<GetDataCategoriesFuture>(
    (ref) => GetDataCategoriesFuture());

class GetDataCategoriesFuture extends ChangeNotifier {
  List<Categorie> listCategories = [];
  List<Categorie> listValides = [];

  GetDataCategoriesFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();
    //String adressUrl = prefs.getString('ipport').toString();

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.11.110:4003/api/products/fetch/categories/$restaurantId'), //4002 //products/fetch/categories/$restaurantId
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );

      print(response.statusCode);
      print('Produit get produit');
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null && data[i]['title'] != "menus") {
            listValides.add(Categorie.fromJson(data[i]));
          }
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
  String? id;
  String? title;
  Creator? cCreator;
  Restaurant? restaurant;
  List<Products>? products;

  Categorie(
      {this.id, this.title, this.cCreator, this.restaurant, this.products});

  Categorie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cCreator =
        json['_creator'] != null ? Creator.fromJson(json['_creator']) : null;
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (cCreator != null) {
      data['_creator'] = cCreator!.toJson();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Creator {
  String? sId;
  String? role;
  String? email;
  String? firstName;
  String? lastName;

  Creator({this.sId, this.role, this.email, this.firstName, this.lastName});

  Creator.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['role'] = role;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
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

class Products {
  String? sId;
  List<Materials>? materials;
  Restaurant? restaurant;
  Category? category;
  double? price;
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
        materials!.add(Materials.fromJson(v));
      });
    }
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
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
        comments!.add(Comments.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (materials != null) {
      data['materials'] = materials!.map((v) => v.toJson()).toList();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['price'] = price;
    data['_creator'] = sCreator;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['promotion'] = promotion;
    data['devise'] = devise;
    data['image'] = image;
    data['liked'] = liked;
    data['likedPersonCount'] = likedPersonCount;
    data['deletedAt'] = deletedAt;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mp_name'] = mpName;
    data['quantity'] = quantity;
    data['lifetime'] = lifetime;
    return data;
  }
}

class Restaurants {
  String? sId;
  String? restaurantName;
  Infos? infos;

  Restaurants({this.sId, this.restaurantName, this.infos});

  Restaurants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
    infos = json['infos'] != null ? Infos.fromJson(json['infos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['restaurant_name'] = restaurantName;
    if (infos != null) {
      data['infos'] = infos!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['town'] = town;
    data['address'] = address;
    return data;
  }
}

class Category {
  String? sId;
  String? title;
  String? image;
  Creator? cCreator;
  Restaurant? restaurant;

  Category({this.sId, this.title, this.image, this.cCreator, this.restaurant});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    cCreator =
        json['_creator'] != null ? Creator.fromJson(json['_creator']) : null;
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['image'] = image;
    if (cCreator != null) {
      data['_creator'] = cCreator!.toJson();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
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
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    message = json['message'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    sCreator = json['_creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (client != null) {
      data['client'] = client!.toJson();
    }
    data['message'] = message;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['_creator'] = sCreator;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fisrtName'] = fisrtName;
    data['lastName'] = lastName;
    data['isOnline'] = isOnline;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
