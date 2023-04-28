import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final getDataMatiereFuture = ChangeNotifierProvider<GetDataMatiereFuture>(
    (ref) => GetDataMatiereFuture());

class GetDataMatiereFuture extends ChangeNotifier {
  List<Matiere> listMatiere = [];

  GetDataMatiereFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    listMatiere = [];

    try {
      /*http.Response response = await http.get(
        Uri.parse('URL'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          //'Authorization': 'Bearer $token ',
        },
      );*/
      final String response = await rootBundle.loadString('matiere.json');
      print('get');
      final data = await json.decode(response);
      print(data);
      for (int i = 0; i < data.length; i++) {
        listMatiere.add(Matiere.fromJson(data[i]));
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

class Matiere {
  String? type;
  int? initial;
  int? consommation;
  String? image;
  String? mesure;

  Matiere(
      {this.type, this.initial, this.consommation, this.image, this.mesure});

  Matiere.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    initial = json['initial'];
    consommation = json['consommation'];
    image = json['image'];
    mesure = json['mesure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['initial'] = this.initial;
    data['consommation'] = this.consommation;
    data['image'] = this.image;
    data['mesure'] = this.mesure;
    return data;
  }
}
