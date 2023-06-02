import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataRoleFuture =
    ChangeNotifierProvider<GetDataRoleFuture>((ref) => GetDataRoleFuture());

class GetDataRoleFuture extends ChangeNotifier {
  List<Role> listRole = [];

  GetDataRoleFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String adressUrl = prefs.getString('ipport').toString();
    try {
      http.Response response = await http.get(
        Uri.parse('http://192.168.1.26:4001/api/users/fetch/all/roles'), //4002
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('get role');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listRole.add(Role.fromJson(data[i]));
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

class Role {
  String? value;
  String? sCreator;

  Role({this.value, this.sCreator});

  Role.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    sCreator = json['_creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['_creator'] = sCreator;
    return data;
  }
}
