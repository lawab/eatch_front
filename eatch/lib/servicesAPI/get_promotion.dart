import 'dart:convert';

import 'package:eatch/servicesAPI/get_produits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataPromotionFuture = ChangeNotifierProvider<GetDataPromotionFuture>(
    (ref) => GetDataPromotionFuture());

class GetDataPromotionFuture extends ChangeNotifier {
  List<Promotion> listPromotion = [];

  GetDataPromotionFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();

    listPromotion = [];

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://192.168.1.34:5005/api/promotions/fetch/restaurant/$restaurantId'), //192.168.1.34 //192.168.1.34:4008
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]["deletedAt"] == null) {
            listPromotion.add(Promotion.fromJson(data[i]));
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    print(listPromotion.length);
    notifyListeners();
  }
}

class Promotion {
  String? sId;
  Restaurant? restaurant;
  String? promotionName;
  String? endDate;
  int? percent;
  String? description;
  Product? product;
  Menu? menu;
  String? image;
  String? sCreator;
  String? deletedAt;
  List<Clients>? clients;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Promotion(
      {this.sId,
      this.restaurant,
      this.promotionName,
      this.endDate,
      this.percent,
      this.description,
      this.product,
      this.menu,
      this.image,
      this.sCreator,
      this.deletedAt,
      this.clients,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Promotion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    promotionName = json['promotion_name'];
    endDate = json['end_date'];
    percent = json['percent'];
    description = json['description'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    menu = json['menu'] != null ? new Menu.fromJson(json['menu']) : null;
    image = json['image'];
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
    if (json['clients'] != null) {
      clients = <Clients>[];
      json['clients'].forEach((v) {
        clients!.add(new Clients.fromJson(v));
      });
    }
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
    data['promotion_name'] = this.promotionName;
    data['end_date'] = this.endDate;
    data['percent'] = this.percent;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.menu != null) {
      data['menu'] = this.menu!.toJson();
    }
    data['image'] = this.image;
    data['_creator'] = this.sCreator;
    data['deletedAt'] = this.deletedAt;
    if (this.clients != null) {
      data['clients'] = this.clients!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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

class Product {
  String? sId;
  String? productName;
  int? price;
  bool? promotion;
  String? devise;
  String? image;
  int? liked;
  int? likedPersonCount;

  Product(
      {this.sId,
      this.productName,
      this.price,
      this.promotion,
      this.devise,
      this.image,
      this.liked,
      this.likedPersonCount});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productName = json['productName'];
    price = json['price'];
    promotion = json['promotion'];
    devise = json['devise'];
    image = json['image'];
    liked = json['liked'];
    likedPersonCount = json['likedPersonCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['promotion'] = this.promotion;
    data['devise'] = this.devise;
    data['image'] = this.image;
    data['liked'] = this.liked;
    data['likedPersonCount'] = this.likedPersonCount;
    return data;
  }
}

class Menu {
  String? sId;
  int? price;
  String? devise;
  List<Products>? products;
  String? sCreator;
  String? description;
  String? menuTitle;
  String? image;
  String? deletedAt;

  Menu(
      {this.sId,
      this.price,
      this.devise,
      this.products,
      this.sCreator,
      this.description,
      this.menuTitle,
      this.image,
      this.deletedAt});

  Menu.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    price = json['price'];
    devise = json['devise'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    sCreator = json['_creator'];
    description = json['description'];
    menuTitle = json['menu_title'];
    image = json['image'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['price'] = this.price;
    data['devise'] = this.devise;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['_creator'] = this.sCreator;
    data['description'] = this.description;
    data['menu_title'] = this.menuTitle;
    data['image'] = this.image;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}

class Clients {
  String? sId;
  Null? fisrtName;
  Null? lastName;
  bool? isOnline;
  Null? phoneNumber;

  Clients(
      {this.sId,
      this.fisrtName,
      this.lastName,
      this.isOnline,
      this.phoneNumber});

  Clients.fromJson(Map<String, dynamic> json) {
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
