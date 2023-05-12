import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      backgroundColor: Palette.yellowColor, //Palette.fourthColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.center,
        child: Card(
          color: Palette.primaryColor,
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width / 2,
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: viewModel.listRsetaurant.length,
              itemBuilder: ((context, index) {
                return InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4 - 50,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15.0),
                          //color: Colors.white,

                          image: DecorationImage(
                              image: NetworkImage(
                                  'http://13.39.81.126:4002${viewModel.listRsetaurant[index].info!.logo.toString()}'),
                              //image: AssetImage('Logo_Eatch_png.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      /*CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(
                              'http://13.39.81.126:4002${viewModel.listRsetaurant[index].info!.logo.toString()}'),
                          //image: AssetImage('eatch.jpg'),
                        ),*/
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        child: Text(
                          viewModel.listRsetaurant[index].restaurantName!,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Palette.yellowColor),
                        ),
                      ),
                    ]),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('idRestaurant',
                        viewModel.listRsetaurant[index].sId.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardManager()));
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
