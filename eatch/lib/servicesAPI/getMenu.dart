import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataMenuFuture =
    ChangeNotifierProvider<GetDataMenuFuture>((ref) => GetDataMenuFuture());

class GetDataMenuFuture extends ChangeNotifier {
  List<Menus> listMenus = [];

  GetDataMenuFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    print("object");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();

    listMenus = [];

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:4009/api/menus/fetch/restaurant/$restaurantId'), //13.39.81.126 //13.39.81.126:4008
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
            listMenus.add(Menus.fromJson(data[i]));
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }

    print(listMenus.length);
    notifyListeners();
  }
}

class Menus {
  String? sId;
  Restaurant? restaurant;
  double? price;
  List<Products>? products;
  Category? category;
  String? menutype;
  Creator? cCreator;
  String? description;
  String? menuTitle;
  String? image;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Menus(
      {this.sId,
      this.restaurant,
      this.price,
      this.products,
      this.category,
      this.menutype,
      this.cCreator,
      this.description,
      this.menuTitle,
      this.image,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Menus.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    price = json['price'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    menutype = json['menutype'];
    cCreator = json['_creator'] != null
        ? new Creator.fromJson(json['_creator'])
        : null;
    description = json['description'];
    menuTitle = json['menu_title'];
    image = json['image'];
    deletedAt = json['deletedAt'];
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
    data['price'] = this.price;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['menutype'] = this.menutype;
    if (this.cCreator != null) {
      data['_creator'] = this.cCreator!.toJson();
    }
    data['description'] = this.description;
    data['menu_title'] = this.menuTitle;
    data['image'] = this.image;
    data['deletedAt'] = this.deletedAt;
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

class Products {
  String? sId;
  String? productName;
  int? price;
  Category? category;
  bool? promotion;
  String? devise;
  String? image;

  Products(
      {this.sId,
      this.productName,
      this.price,
      this.category,
      this.promotion,
      this.devise,
      this.image});

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productName = json['productName'];
    price = json['price'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    promotion = json['promotion'];
    devise = json['devise'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['productName'] = this.productName;
    data['price'] = this.price;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['promotion'] = this.promotion;
    data['devise'] = this.devise;
    data['image'] = this.image;
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

class Restaurants {
  String? sId;

  Restaurants({this.sId});

  Restaurants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class Restaurantss {
  String? sId;
  String? restaurantName;

  Restaurantss({this.sId, this.restaurantName});

  Restaurantss.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}

class Creators {
  String? sId;
  String? username;
  String? email;

  Creators({this.sId, this.username, this.email});

  Creators.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}
