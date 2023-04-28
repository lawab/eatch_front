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
      print('******************************');
      print(data);
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
        produits!.add(new Produits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    data['nombreproduits'] = this.nombreproduits;
    if (this.produits != null) {
      data['produits'] = this.produits!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    data['price'] = this.price;
    return data;
  }
}
