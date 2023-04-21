import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final getDataUserFuture =
    ChangeNotifierProvider<GetDataUserFuture>((ref) => GetDataUserFuture());

class GetDataUserFuture extends ChangeNotifier {
  List<User> listDataModel = [];
  List<User> listManager = [];

  GetDataUserFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    listDataModel = [];

    try {
      /*http.Response response = await http.get(
        Uri.parse('URL'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          //'Authorization': 'Bearer $token ',
        },
      );*/
      final String response = await rootBundle.loadString('assets/user.json');
      final data = await json.decode(response);
      for (int i = 0; i < data.length; i++) {
        listDataModel.add(User.fromJson(data[i]));
        if (data[i]['userRole'] == 'RÔLE_Manager') {
          listManager.add(User.fromJson(data[i]));
        }
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

class User {
  String? userEmail;
  String? userNom;
  String? userPrenom;
  String? userRole;
  String? userUserNom;

  User(
      {this.userEmail,
      this.userNom,
      this.userPrenom,
      this.userRole,
      this.userUserNom});

  User.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    userNom = json['userNom'];
    userPrenom = json['userPrenom'];
    userRole = json['userRole'];
    userUserNom = json['userUserNom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['userNom'] = this.userNom;
    data['userPrenom'] = this.userPrenom;
    data['userRole'] = this.userRole;
    data['userUserNom'] = this.userUserNom;
    return data;
  }
}
