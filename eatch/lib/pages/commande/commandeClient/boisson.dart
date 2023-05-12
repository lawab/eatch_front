import 'package:eatch/pages/commande/commandeClient/detail.dart';
import 'package:eatch/servicesAPI/getCommande.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

class Boisson extends StatefulWidget {
  final List<Produits> produits;
  const Boisson({Key? key, required this.produits}) : super(key: key);

  @override
  BoissonState createState() => BoissonState();
}

class BoissonState extends State<Boisson> {
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
    return Scaffold(
      backgroundColor: Palette.yellowColor,
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                mainAxisExtent: 200),
            itemCount: widget.produits.length,
            itemBuilder: (BuildContext ctx, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(
                                produit: widget.produits[index],
                                page: 0,
                              )));
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        width: 200,
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                              image:
                                  AssetImage(widget.produits[index].imageUrl!),
                              fit: BoxFit.cover),
                        ),
                        child: const Icon(
                          Icons.add_box,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                      Container(
                          height: 30,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Text(
                                widget.produits[index].title!,
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(child: Container()),
                              Text(
                                widget.produits[index].price.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
