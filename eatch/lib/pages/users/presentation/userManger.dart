import 'package:eatch/pages/users/application/search_users_text_field.dart';
import 'package:eatch/pages/users/domain/user.dart';
import 'package:eatch/pages/users/infrastructure/users_data.dart';
import 'package:eatch/servicesAPI/getUser.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modification_user.dart';

class ManagerUsers extends ConsumerStatefulWidget {
  const ManagerUsers({
    super.key,
  });

  @override
  ManagerUsersState createState() => ManagerUsersState();
}

class ManagerUsersState extends ConsumerState<ManagerUsers> {
  bool search = false;
  List<User> UserSearch = [];
  void filterSearchResults(String query) {
    final viewModel = ref.watch(getDataUserFuture);
    List<User> dummySearchList = [];
    dummySearchList.addAll(viewModel.listManager);
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
            padding: EdgeInsets.symmetric(
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
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(Icons.search, color: Palette.primaryColor),
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
                      itemCount: viewModel.listManager.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: Container(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Center(
                                child:
                                    Text(viewModel.listManager[index].userNom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listManager[index].userPrenom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listManager[index].userUserNom!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listManager[index].userEmail!),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                    viewModel.listManager[index].userRole!),
                              )),
                              Container(
                                width: 100,
                                child: Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ModificationUser(
                                                userEmail: viewModel
                                                    .listManager[index]
                                                    .userEmail!,
                                                userNom: viewModel
                                                    .listManager[index]
                                                    .userNom!,
                                                userPrenom: viewModel
                                                    .listManager[index]
                                                    .userEmail!,
                                                userRole: viewModel
                                                    .listManager[index]
                                                    .userRole!,
                                                userUserNom: viewModel
                                                    .listManager[index]
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
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          dialogDelete(viewModel
                                              .listManager[index].userNom!);
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
                                          color: Colors.red,
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
