import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDataRecettesFuture = ChangeNotifierProvider<GetDataRecettesFuture>(
    (ref) => GetDataRecettesFuture());

class GetDataRecettesFuture extends ChangeNotifier {
  List<Recette> listRecettes = [];

  GetDataRecettesFuture() {
    getRecettesData();
  }

  Future getRecettesData() async {
    listRecettes = [];

    try {
      final String response =
          await rootBundle.loadString('assets/recette.json');
      final data = await json.decode(response);

      for (int i = 0; i < data.length; i++) {
        listRecettes.add(Recette.fromJson(data[i]));
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

class Recette {
  String? id;
  String? titreRecette;
  String? tempsPreparation;
  String? tempsCuisson;
  String? tempsTotal;
  String? imageUrl;
  String? imageName;
  List<Ingredients>? ingredients;

  Recette(
      {this.id,
      this.titreRecette,
      this.tempsPreparation,
      this.tempsCuisson,
      this.tempsTotal,
      this.imageUrl,
      this.imageName,
      this.ingredients});

  Recette.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titreRecette = json['titreRecette'];
    tempsPreparation = json['tempsPreparation'];
    tempsCuisson = json['tempsCuisson'];
    tempsTotal = json['tempsTotal'];
    imageUrl = json['imageUrl'];
    imageName = json['imageName'];
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titreRecette'] = titreRecette;
    data['tempsPreparation'] = tempsPreparation;
    data['tempsCuisson'] = tempsCuisson;
    data['tempsTotal'] = tempsTotal;
    data['imageUrl'] = imageUrl;
    data['imageName'] = imageName;
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ingredients {
  String? matiere;
  String? quantite;
  String? unite;

  Ingredients({this.matiere, this.quantite, this.unite});

  Ingredients.fromJson(Map<String, dynamic> json) {
    matiere = json['matiere'];
    quantite = json['quantite'];
    unite = json['unite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matiere'] = matiere;
    data['quantite'] = quantite;
    data['unite'] = unite;
    return data;
  }
}
