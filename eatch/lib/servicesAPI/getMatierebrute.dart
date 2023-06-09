import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataMatiereBruteFuture =
    ChangeNotifierProvider<GetDataMatiereBruteFuture>(
        (ref) => GetDataMatiereBruteFuture());

class GetDataMatiereBruteFuture extends ChangeNotifier {
  List<MatiereBrute> listMatiereBrute = [];

  GetDataMatiereBruteFuture() {
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
            'http://192.168.1.26:4015/api/raws/fetch/all'), //192.168.1.26 //192.168.1.26:4008
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
            listMatiereBrute.add(MatiereBrute.fromJson(data[i]));
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

class MatiereBrute {
  String? sId;
  String? title;
  int? available;
  String? unit;
  String? image;
  String? laboratory;
  String? provider;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MatiereBrute(
      {this.sId,
      this.title,
      this.available,
      this.unit,
      this.image,
      this.laboratory,
      this.provider,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MatiereBrute.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    available = json['available'];
    unit = json['unit'];
    image = json['image'];
    laboratory = json['laboratory'];
    provider = json['provider'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['available'] = this.available;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['laboratory'] = this.laboratory;
    data['provider'] = this.provider;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
