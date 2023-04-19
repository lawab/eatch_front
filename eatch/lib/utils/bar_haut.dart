import 'package:flutter/material.dart';

import 'couleurs/couleurs.dart';
import 'responsive/responsive_center.dart';
import 'search.dart';

class BarHaut extends StatelessWidget {
  const BarHaut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
        ),
      ),
      margin: const EdgeInsets.only(top: 20.0),
      height: 70,
      child: CustomScrollView(
        slivers: [
          ResponsiveSliverCenter(
            maxContentWidth: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 08.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                const Expanded(flex: 1, child: SearchTextField()),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: eatchJauneSecond),
                          child: const Icon(
                            Icons.shopping_bag_rounded,
                            size: 20,
                            color: eatchJaune,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: eatchJauneSecond),
                          child: const Icon(
                            Icons.notifications,
                            size: 20,
                            color: eatchJaune,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: eatchJauneSecond),
                          child: const Icon(
                            Icons.message_rounded,
                            size: 20,
                            color: eatchJaune,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(20),
                                child: Image.asset('assets/tete.jpg',
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const Text(
                            "Nom Connecté",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: eatchTextBleu,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                            color: eatchJaune,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
