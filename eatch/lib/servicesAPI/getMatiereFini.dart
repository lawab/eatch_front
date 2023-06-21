import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataMatiereFiniFuture =
    ChangeNotifierProvider<GetDataMatiereFiniFuture>(
        (ref) => GetDataMatiereFiniFuture());

class GetDataMatiereFiniFuture extends ChangeNotifier {
  List<MatiereFini> listMatiereFini = [];

  GetDataMatiereFiniFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    //var restaurantId = prefs.getString('idRestaurant').toString();

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:4015/api/semiMaterials/fetch/all'), //13.39.81.126 //13.39.81.126:4008
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]["deletedAt"] == null) {
            listMatiereFini.add(MatiereFini.fromJson(data[i]));
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

class MatiereFini {
  String? sId;
  String? title;
  int? quantity;
  String? unit;
  String? lifetime;
  String? image;
  String? laboratory;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MatiereFini(
      {this.sId,
      this.title,
      this.quantity,
      this.unit,
      this.lifetime,
      this.image,
      this.laboratory,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MatiereFini.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    quantity = json['quantity'];
    unit = json['unit'];
    lifetime = json['lifetime'];
    image = json['image'];
    laboratory = json['laboratory'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['lifetime'] = this.lifetime;
    data['image'] = this.image;
    data['laboratory'] = this.laboratory;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
