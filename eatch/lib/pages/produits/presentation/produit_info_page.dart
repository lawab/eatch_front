import 'package:eatch/pages/produits/presentation/modification_produit.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Produitpage extends StatelessWidget {
  const Produitpage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });
  final String imageUrl;
  final String title;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 35, left: 15),
            child: RawMaterialButton(
              fillColor: Palette.primaryColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder(),
              child: const Icon(IconData(0xe16a, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(100),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Palette.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  NumberFormat.simpleCurrency(name: "MAD ").format(price),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 150,
                      child: DefaultButton(
                        color: Palette.primaryColor,
                        foreground: Colors.red,
                        text: 'SUPPRIMER',
                        textcolor: Palette.primaryBackgroundColor,
                        onPressed: () {
                          dialogDelete(
                            context,
                            title,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 150,
                      child: DefaultButton(
                        color: Palette.secondaryBackgroundColor,
                        foreground: Colors.red,
                        text: 'MODIFIER',
                        textcolor: Palette.textsecondaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ModificationProduit(
                                imageUrl: imageUrl,
                                price: price,
                                title: title,
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future dialogDelete(BuildContext context, String nomproduit) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Confirmez la suppression",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.delete,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.deleteColors),
                onPressed: () {},
                label: const Text("Supprimer."),
              )
            ],
            content: Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 150,
                child: Text(
                  "Voulez vous supprimer la catégorie $nomproduit?",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                )));
      },
    );
  }
}
