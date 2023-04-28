import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

final getDataCategorieFuture = ChangeNotifierProvider<GetDataCategorieFuture>(
    (ref) => GetDataCategorieFuture());

class GetDataCategorieFuture extends ChangeNotifier {
  List<Categorie> listCategorieModel = [];

  GetDataCategorieFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    listCategorieModel = [];

    try {
      final String response =
          await rootBundle.loadString('assets/categorie.json');
      final data = await json.decode(response);
      print('******************************');
      print(data);
      for (int i = 0; i < data.length; i++) {
        listCategorieModel.add(Categorie.fromJson(data[i]));
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

  Categorie({this.id, this.imageUrl, this.title, this.nombreproduits});

  Categorie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    nombreproduits = json['nombreproduits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    data['nombreproduits'] = this.nombreproduits;
    return data;
  }
}
