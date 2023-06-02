import 'package:eatch/pages/restaurant/afficheRestaurant.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

class RestaurantDetail extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetail({Key? key, required this.restaurant})
      : super(key: key);

  @override
  RestaurantDetailState createState() => RestaurantDetailState();
}

class RestaurantDetailState extends State<RestaurantDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    opacity: 100,
                    image: NetworkImage(
                        'http://192.168.1.26:4002${widget.restaurant.infos!.logo.toString()}'),
                    //image: AssetImage('eatch.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: IconButton(
                  color: Palette.primaryColor,
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RestaurantAffiche(),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}
