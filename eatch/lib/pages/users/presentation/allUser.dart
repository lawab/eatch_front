// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:eatch/servicesAPI/getUser.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modification_user.dart';

class AllUsers extends ConsumerStatefulWidget {
  const AllUsers({
    super.key,
  });

  @override
  AllUsersState createState() => AllUsersState();
}

class AllUsersState extends ConsumerState<AllUsers> {
  bool search = false;
  List<User> UserSearch = [];
  void filterSearchResults(String query) {
    final viewModel = ref.watch(getDataUserFuture);
    List<User> dummySearchList = [];
    dummySearchList.addAll(viewModel.listDataModel);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.userNom!.contains(query) ||
            item.userPrenom!.contains(query) ||
            item.userUserNom!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      });
      setState(() {
        search = true;
        UserSearch.clear();
        UserSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: SizedBox(
              width: 300,
              child: TextField(
                // onChanged: (value) => onSearch(value.toLowerCase()),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.fourthColor,
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon:
                      const Icon(Icons.search, color: Palette.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  hintText: "Rechercher d'utilisateurs ...",
                ),
              ),
            ),
          ),
          Card(
            child: Container(
              height: 50,
              child: Row(children: [
                const Expanded(
                    child: Center(
                  child: Text(
                    'Nom',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                const Expanded(
                    child: Center(
                  child: Text(
                    'Prénom',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                const Expanded(
                    child: Center(
                  child: Text(
                    "Nom d'utilisateur",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                const Expanded(
                    child: Center(
                  child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                const Expanded(
                    child: Center(
                  child: Text(
                    'Role',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                Container(
                  width: 100,
                  child: const Center(
                    child: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          search == false
              ? Container(
                  height: MediaQuery.of(context).size.height - 403,
                  child: ListView.builder(
                      itemCount: viewModel.listDataModel.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: Container(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listDataModel[index].userNom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listDataModel[index].userPrenom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(viewModel
                                    .listDataModel[index].userUserNom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listDataModel[index].userEmail!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listDataModel[index].userRole!),
                              )),
                              Container(
                                width: 100,
                                child: Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ModificationUser(
                                                userEmail: viewModel
                                                    .listDataModel[index]
                                                    .userEmail!,
                                                userNom: viewModel
                                                    .listDataModel[index]
                                                    .userNom!,
                                                userPrenom: viewModel
                                                    .listDataModel[index]
                                                    .userEmail!,
                                                userRole: viewModel
                                                    .listDataModel[index]
                                                    .userRole!,
                                                userUserNom: viewModel
                                                    .listDataModel[index]
                                                    .userUserNom!,
                                              );
                                            }),
                                          );
                                        },
                                      )),
                                      Expanded(
                                          child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Palette.deleteColors,
                                        ),
                                        onPressed: () {
                                          dialogDelete(viewModel
                                              .listDataModel[index].userNom!);
                                        },
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      })),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 403,
                  child: ListView.builder(
                      itemCount: UserSearch.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: Container(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Center(
                                child: Text(UserSearch[index].userNom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(UserSearch[index].userPrenom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(UserSearch[index].userUserNom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(UserSearch[index].userEmail!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(UserSearch[index].userRole!),
                              )),
                              Container(
                                width: 100,
                                child: Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ModificationUser(
                                                userEmail: UserSearch[index]
                                                    .userEmail!,
                                                userNom:
                                                    UserSearch[index].userNom!,
                                                userPrenom: UserSearch[index]
                                                    .userEmail!,
                                                userRole:
                                                    UserSearch[index].userRole!,
                                                userUserNom: UserSearch[index]
                                                    .userUserNom!,
                                              );
                                            }),
                                          );
                                        },
                                      )),
                                      Expanded(
                                          child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Palette.deleteColors,
                                        ),
                                        onPressed: () {
                                          dialogDelete(
                                              UserSearch[index].userNom!);
                                        },
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      })),
                ),
        ],
      ),
    );
  }

  Future dialogDelete(String userName) {
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                    "Voulez vous supprimer l'utilisateur $userName?",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )));
        });
  }
}
