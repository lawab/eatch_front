import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDataCommandeFuture = ChangeNotifierProvider<GetDataCommandeFuture>(
    (ref) => GetDataCommandeFuture());

class GetDataCommandeFuture extends ChangeNotifier {
  List<Commande> listCommande = [];

  GetDataCommandeFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    listCommande = [];

    try {
      /*http.Response response = await http.get(
        Uri.parse('URL'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          //'Authorization': 'Bearer $token ',
        },
      );*/
      final String response = await rootBundle.loadString('commande.json');
      print('get');
      final data = await json.decode(response);
      print(data);
      for (int i = 0; i < data.length; i++) {
        listCommande.add(Commande.fromJson(data[i]));
      }
      /*if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //print(data);
        for (int i = 0; i < data.length; i++) {
          listDataModel.add(User.fromJson(data[i]));
        }
      } else {
        return Future.error(" server erreur");
      }*/
    } catch (e) {
      print(e.toString());
    }

    //print(listDataModel.length);
    notifyListeners();
  }
}

class Commande {
  String? id;
  String? imageUrl;
  String? title;
  int? nombreproduits;
  List<Produits>? produits;

  Commande(
      {this.id, this.imageUrl, this.title, this.nombreproduits, this.produits});

  Commande.fromJson(Map<String, dynamic> json) {
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
  int? price;

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
