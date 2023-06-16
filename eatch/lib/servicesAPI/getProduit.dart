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
            'http://192.168.1.105:4005/api/products/fetch/restaurant/$restaurantId'),
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
  Restaurant? restaurant;
  Category? category;
  double? price;
  List<String>? idsMP;
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
  List<Materials>? materials;

  Produit(
      {this.sId,
      this.restaurant,
      this.category,
      this.price,
      this.idsMP,
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
      this.iV,
      this.materials});

  Produit.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    price = json['price'];
    idsMP = json['ids_MP'].cast<String>();
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
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(Materials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['price'] = price;
    data['ids_MP'] = idsMP;
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
    if (materials != null) {
      data['materials'] = materials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  Infos? infos;
  String? sId;
  String? restaurantName;

  Restaurant({this.infos, this.sId, this.restaurantName});

  Restaurant.fromJson(Map<String, dynamic> json) {
    infos = json['infos'] != null ? Infos.fromJson(json['infos']) : null;
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (infos != null) {
      data['infos'] = infos!.toJson();
    }
    data['_id'] = sId;
    data['restaurant_name'] = restaurantName;
    return data;
  }
}

class Infos {
  String? town;
  String? address;
  String? sId;
  String? logo;

  Infos({this.town, this.address, this.sId, this.logo});

  Infos.fromJson(Map<String, dynamic> json) {
    town = json['town'];
    address = json['address'];
    sId = json['_id'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['town'] = town;
    data['address'] = address;
    data['_id'] = sId;
    data['logo'] = logo;
    return data;
  }
}

class Category {
  String? sId;
  String? title;

  Category({this.sId, this.title});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
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

class Materials {
  String? image;
  int? consumerQuantity;
  int? currentQuantity;
  String? unity;
  String? sId;
  Restaurant? restaurant;
  String? sCreator;
  String? mpName;
  int? quantity;
  int? minQuantity;
  String? deletedAt;
  String? lifetime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Materials(
      {this.image,
      this.consumerQuantity,
      this.currentQuantity,
      this.unity,
      this.sId,
      this.restaurant,
      this.sCreator,
      this.mpName,
      this.quantity,
      this.minQuantity,
      this.deletedAt,
      this.lifetime,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Materials.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    consumerQuantity = json['consumer_quantity'];
    currentQuantity = json['current_quantity'];
    unity = json['unity'];
    sId = json['_id'];
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    sCreator = json['_creator'];
    mpName = json['mp_name'];
    quantity = json['quantity'];
    minQuantity = json['min_quantity'];
    deletedAt = json['deletedAt'];
    lifetime = json['lifetime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['consumer_quantity'] = consumerQuantity;
    data['current_quantity'] = currentQuantity;
    data['unity'] = unity;
    data['_id'] = sId;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['_creator'] = sCreator;
    data['mp_name'] = mpName;
    data['quantity'] = quantity;
    data['min_quantity'] = minQuantity;
    data['deletedAt'] = deletedAt;
    data['lifetime'] = lifetime;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
