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
  int? tempsPreparation;
  int? tempsCuisson;
  int? tempsTotal;
  String? imageUrl;
  List<Ingrdients>? ingrdients;

  Recette(
      {this.id,
      this.titreRecette,
      this.tempsPreparation,
      this.tempsCuisson,
      this.tempsTotal,
      this.imageUrl,
      this.ingrdients});

  Recette.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titreRecette = json['titreRecette'];
    tempsPreparation = json['tempsPreparation'];
    tempsCuisson = json['tempsCuisson'];
    tempsTotal = json['tempsTotal'];
    imageUrl = json['imageUrl'];
    if (json['Ingrdients'] != null) {
      ingrdients = <Ingrdients>[];
      json['Ingrdients'].forEach((v) {
        ingrdients!.add(Ingrdients.fromJson(v));
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
    if (ingrdients != null) {
      data['Ingrdients'] = ingrdients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ingrdients {
  Matiere? matiere;
  int? quantit;
  String? unit;

  Ingrdients({this.matiere, this.quantit, this.unit});

  Ingrdients.fromJson(Map<String, dynamic> json) {
    matiere =
        json['matiere'] != null ? Matiere.fromJson(json['matiere']) : null;
    quantit = json['Quantité'];
    unit = json['Unité'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (matiere != null) {
      data['matiere'] = matiere!.toJson();
    }
    data['Quantité'] = quantit;
    data['Unité'] = unit;
    return data;
  }
}

class Matiere {
  String? sId;

  Matiere({this.sId});

  Matiere.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    return data;
  }
}
