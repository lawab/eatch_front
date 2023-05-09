import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:eatch/pages/restaurant/detailRestaurant.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:eatch/pages/restaurant/modificationRestaurant.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as h;
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class RestaurantAccueil extends ConsumerStatefulWidget {
  const RestaurantAccueil({Key? key}) : super(key: key);

  @override
  RestaurantAccueilState createState() => RestaurantAccueilState();
}

class RestaurantAccueilState extends ConsumerState<RestaurantAccueil> {
  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext buildContext) {
    return mediaQueryData(buildContext).size;
  }

  double width(BuildContext buildContext) {
    return size(buildContext).width;
  }

  double height(BuildContext buildContext) {
    return size(buildContext).height;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataRsetaurantFuture);

    return Scaffold(
      backgroundColor: Palette.fourthColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.center,
        child: Container(
          child: ListView.builder(
            itemCount: viewModel.listRsetaurant.length,
            itemBuilder: ((context, index) {
              return InkWell(
                child: Card(
                  color: Palette.primaryColor,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          viewModel.listRsetaurant[index].restaurantName!,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(120.0),
                          color: Palette.secondaryColor,
                        ),
                        child: CircleAvatar(
                          radius: (MediaQuery.of(context).size.height / 3) - 50,
                          backgroundImage: NetworkImage(
                              'http://13.39.81.126:4002${viewModel.listRsetaurant[index].info!.logo.toString()}'),
                          //image: AssetImage('eatch.jpg'),
                        ),
                      ),
                    ]),
                  ),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  prefs.setString('idRestaurant',
                      viewModel.listRsetaurant[index].sId.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardManager()));
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
