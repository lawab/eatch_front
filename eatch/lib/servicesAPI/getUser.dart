import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataUserFuture =
    ChangeNotifierProvider<GetDataUserFuture>((ref) => GetDataUserFuture());

class GetDataUserFuture extends ChangeNotifier {
  List<User> listAllUsers = [];
  List<User> listManager = [];
  List<User> listEmploye = [];
  List<User> listComptable = [];

  GetDataUserFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    listAllUsers = [];

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:4001/api/users/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("les users $data");
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listAllUsers.add(User.fromJson(data[i]));

            if (data[i]['role'] == 'RH') {
              listManager.add(User.fromJson(data[i]));
            } else if (data[i]['role'] == 'EMPLOYEE') {
              listEmploye.add(User.fromJson(data[i]));
            } else if (data[i]['role'] == 'COMPTABLE') {
              listComptable.add(User.fromJson(data[i]));
            }
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

// class User {
//   String? sId;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? username;
//   String? password;
//   String? role;
//   String? avatar;
//   bool? isOnline;
//   String? deletedAt;
//   String? createdAt;
//   String? updatedAt;

//   int? iV;

//   User({
//     this.sId,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.username,
//     this.password,
//     this.role,
//     this.avatar,
//     this.isOnline,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.iV,
//   });

//   User.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     email = json['email'];
//     username = json['username'];
//     password = json['password'];
//     role = json['role'];
//     avatar = json['avatar'];
//     isOnline = json['isOnline'];
//     deletedAt = json['deletedAt'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];

//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['email'] = email;
//     data['username'] = username;
//     data['password'] = password;
//     data['role'] = role;
//     data['avatar'] = avatar;
//     data['isOnline'] = isOnline;
//     data['deletedAt'] = deletedAt;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = iV;
//     return data;
//   }
// }

class User {
  String? sId;
  Restaurant? restaurant;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;
  String? role;
  String? avatar;
  bool? isOnline;
  String? sCreator;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User(
      {this.sId,
      this.restaurant,
      this.firstName,
      this.lastName,
      this.email,
      this.username,
      this.password,
      this.role,
      this.avatar,
      this.isOnline,
      this.sCreator,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    role = json['role'];
    avatar = json['avatar'];
    isOnline = json['isOnline'];
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['password'] = password;
    data['role'] = role;
    data['avatar'] = avatar;
    data['isOnline'] = isOnline;
    data['_creator'] = sCreator;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Restaurant {
  String? sId;

  Restaurant({this.sId});

  Restaurant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    return data;
  }
}
