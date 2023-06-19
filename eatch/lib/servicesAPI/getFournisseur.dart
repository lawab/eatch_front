import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ici , cela permet d'appler le GetDataMatiereFuture
final getDataFournisseurFuture =
    ChangeNotifierProvider<GetDataFournisseurFuture>(
        (ref) => GetDataFournisseurFuture());

class GetDataFournisseurFuture extends ChangeNotifier {
  List<Fournisseur> listFournisseur = [];

  GetDataFournisseurFuture() {
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
            'http://13.39.81.126:4015/api/providers/fetch/all'), //13.39.81.126 //13.39.81.126:4008
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]["deletedAt"] == null) {
            listFournisseur.add(Fournisseur.fromJson(data[i]));
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

class Fournisseur {
  Creator? cCreator;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? adresse;
  String? image;
  String? laboratory;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Fournisseur(
      {this.cCreator,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.adresse,
      this.image,
      this.laboratory,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Fournisseur.fromJson(Map<String, dynamic> json) {
    cCreator = json['_creator'] != null
        ? new Creator.fromJson(json['_creator'])
        : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    adresse = json['adresse'];
    image = json['image'];
    laboratory = json['laboratory'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cCreator != null) {
      data['_creator'] = this.cCreator!.toJson();
    }
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['adresse'] = this.adresse;
    data['image'] = this.image;
    data['laboratory'] = this.laboratory;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
