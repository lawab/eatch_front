// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:js_interop';

import 'package:eatch/servicesAPI/get_user.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modification_user.dart';

import 'package:http/http.dart' as http;

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
    dummySearchList.addAll(viewModel.listAllUsers);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.lastName!.contains(query) ||
            item.firstName!.contains(query) ||
            item.username!.contains(query)) {
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
                  height: MediaQuery.of(context).size.height - 437,
                  child: ListView.builder(
                    itemCount: viewModel.listAllUsers.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: Container(
                          height: 50,
                          child: Row(children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    viewModel.listAllUsers[index].lastName!,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  viewModel.listAllUsers[index].firstName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  viewModel.listAllUsers[index].username!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  viewModel.listAllUsers[index].email!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  viewModel.listAllUsers[index].role!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
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
                                        print("WWWWWWWWWOOOOOOOWWWWWWWWWWWW");
                                        print(viewModel
                                            .listAllUsers[index].email);
                                        print(viewModel
                                            .listAllUsers[index].firstName);
                                        print(viewModel
                                            .listAllUsers[index].lastName);
                                        print(
                                            viewModel.listAllUsers[index].role);
                                        print(
                                            viewModel.listAllUsers[index].sId);
                                        print(viewModel
                                            .listAllUsers[index].username);
                                        print(viewModel
                                            .listAllUsers[index].avatar!);
                                        /*print(viewModel.listAllUsers[index]
                                              .restaurant!.sId!);*/
                                        print('ppppppppppppppppppppppooo');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ModificationUser(
                                              avatar: viewModel
                                                  .listAllUsers[index].avatar!,
                                              email: viewModel
                                                  .listAllUsers[index].email!,
                                              firstName: viewModel
                                                  .listAllUsers[index]
                                                  .firstName!,
                                              lastName: viewModel
                                                  .listAllUsers[index]
                                                  .lastName!,
                                              role: viewModel
                                                  .listAllUsers[index].role!,
                                              sId: viewModel
                                                  .listAllUsers[index].sId!,
                                              id: viewModel.listAllUsers[index]
                                                      .restaurant.isNull
                                                  ? viewModel
                                                          .listAllUsers[index]
                                                          .laboratory
                                                          .isNull
                                                      ? ''
                                                      : viewModel
                                                          .listAllUsers[index]
                                                          .laboratory!
                                                          .sId!
                                                  : viewModel
                                                      .listAllUsers[index]
                                                      .restaurant!
                                                      .sId!,
                                            );
                                          }),
                                        );
                                        print('object');
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
                                          viewModel.listAllUsers[index].lastName
                                              .toString(),
                                          viewModel.listAllUsers[index].sId!,
                                        );
                                      },
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 437,
                  child: ListView.builder(
                    itemCount: UserSearch.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: Container(
                          height: 50,
                          child: Row(children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  UserSearch[index].lastName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  UserSearch[index].firstName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  UserSearch[index].username!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  UserSearch[index].email!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Text(
                                  UserSearch[index].role!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
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
                                          MaterialPageRoute(builder: (context) {
                                            return ModificationUser(
                                              avatar: UserSearch[index].avatar!,
                                              email: UserSearch[index].email!,
                                              firstName:
                                                  UserSearch[index].firstName!,
                                              lastName:
                                                  UserSearch[index].lastName!,
                                              role: UserSearch[index].role!,
                                              sId: UserSearch[index].sId!,
                                              id: UserSearch[index]
                                                      .restaurant!
                                                      .isNull
                                                  ? UserSearch[index]
                                                          .laboratory
                                                          .isNull
                                                      ? UserSearch[index]
                                                          .laboratory!
                                                          .laboName!
                                                      : ''
                                                  : UserSearch[index]
                                                      .restaurant!
                                                      .sId!,
                                              // username:
                                              //     UserSearch[index].username!,
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
                                          UserSearch[index].lastName!,
                                          UserSearch[index].sId!,
                                        );
                                      },
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }

  Future dialogDelete(String userName, id) {
    return showDialog(
        context: context,
        builder: (con) {
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
                  onPressed: () {
                    deleteUser(context, id);
                    Navigator.pop(con);
                  },
                  label: const Text("Supprimer."),
                )
              ],
              content: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 150,
                  child: Text(
                    "Voulez vous supprimer l'utilisateur $userName? et $id",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )));
        });
  }

  Future<http.Response> deleteUser(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var token = prefs.getString('token');
      String urlDelete = "http://192.168.1.105:4001/api/users/delete/$id";
      var json = {
        '_creator': userdelete,
      };
      var body = jsonEncode(json);

      final http.Response response = await http.delete(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
          'body': body,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        ref.refresh(getDataUserFuture);

        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
