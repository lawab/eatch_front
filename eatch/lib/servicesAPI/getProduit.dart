import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataProduitFuture = ChangeNotifierProvider<GetDataProduitFuture>(
    (ref) => GetDataProduitFuture());

class GetDataProduitFuture extends ChangeNotifier {
  List<Produit> listProduit = [];

  GetDataProduitFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();

    //String adressUrl = prefs.getString('ipport').toString();
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:4003/api/products/fetch/restaurant/$restaurantId'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get produit');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listProduit.add(Produit.fromJson(data[i]));
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

class Produit {
  String? sId;
  Recette? recette;
  Restaurant? restaurant;
  Category? category;
  int? price;
  String? sCreator;
  int? quantity;
  String? productName;
  bool? promotion;
  String? devise;
  String? image;
  int? liked;
  int? likedPersonCount;
  Null? deletedAt;
  List<Null>? comments;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Produit(
      {this.sId,
      this.recette,
      this.restaurant,
      this.category,
      this.price,
      this.sCreator,
      this.quantity,
      this.productName,
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

  Produit.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    recette =
        json['recette'] != null ? new Recette.fromJson(json['recette']) : null;
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    price = json['price'];
    sCreator = json['_creator'];
    quantity = json['quantity'];
    productName = json['productName'];
    promotion = json['promotion'];
    devise = json['devise'];
    image = json['image'];
    liked = json['liked'];
    likedPersonCount = json['likedPersonCount'];
    deletedAt = json['deletedAt'];
    /*if (json['comments'] != null) {
      comments = <Null>[];
      json['comments'].forEach((v) {
        comments!.add(new Null.fromJson(v));
      });
    }*/
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.recette != null) {
      data['recette'] = this.recette!.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['price'] = this.price;
    data['_creator'] = this.sCreator;
    data['quantity'] = this.quantity;
    data['productName'] = this.productName;
    data['promotion'] = this.promotion;
    data['devise'] = this.devise;
    data['image'] = this.image;
    data['liked'] = this.liked;
    data['likedPersonCount'] = this.likedPersonCount;
    data['deletedAt'] = this.deletedAt;
    /*if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }*/
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Recette {
  String? sId;
  String? title;
  String? image;
  String? description;
  List<Engredients>? engredients;
  String? sCreator;
  Null? deletedAt;

  Recette(
      {this.sId,
      this.title,
      this.image,
      this.description,
      this.engredients,
      this.sCreator,
      this.deletedAt});

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
    return data;
  }
}

class Engredients {
  String? material;
  int? grammage;
  String? sId;

  Engredients({this.material, this.grammage, this.sId});

  Engredients.fromJson(Map<String, dynamic> json) {
    material = json['material'];
    grammage = json['grammage'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['material'] = this.material;
    data['grammage'] = this.grammage;
    data['_id'] = this.sId;
    return data;
  }
}

class Restaurant {
  Infos? infos;
  String? sId;
  String? restaurantName;

  Restaurant({this.infos, this.sId, this.restaurantName});

  Restaurant.fromJson(Map<String, dynamic> json) {
    infos = json['infos'] != null ? new Infos.fromJson(json['infos']) : null;
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.infos != null) {
      data['infos'] = this.infos!.toJson();
    }
    data['_id'] = this.sId;
    data['restaurant_name'] = this.restaurantName;
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

class Category {
  Creator? cCreator;
  Restaurant? restaurant;
  String? sId;
  String? title;
  String? image;
  Null? deletedAt;

  Category(
      {this.cCreator,
      this.restaurant,
      this.sId,
      this.title,
      this.image,
      this.deletedAt});

  Category.fromJson(Map<String, dynamic> json) {
    cCreator = json['_creator'] != null
        ? new Creator.fromJson(json['_creator'])
        : null;
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cCreator != null) {
      data['_creator'] = this.cCreator!.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['deletedAt'] = this.deletedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['role'] = this.role;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}

/*class Restaurants {
  String? sId;
  String? restaurantName;

  Restaurant({this.sId, this.restaurantName});

  Restaurant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}*/