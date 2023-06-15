import 'dart:js_interop';

import 'package:eatch/servicesAPI/get_user.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modification_user.dart';

class ComptableUsers extends ConsumerStatefulWidget {
  const ComptableUsers({
    super.key,
  });
  @override
  ComptableUsersState createState() => ComptableUsersState();
}

class ComptableUsersState extends ConsumerState<ComptableUsers> {
  bool search = false;
  List<User> UserSearch = [];
  void filterSearchResults(String query) {
    final viewModel = ref.watch(getDataUserFuture);
    List<User> dummySearchList = [];
    dummySearchList.addAll(viewModel.listComptable);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.lastName!.contains(query) ||
            item.firstName!.contains(query) ||
            item.username!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      }
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
                  hintText: "Rechercher d'employés ...",
                ),
              ),
            ),
          ),
          Card(
            child: SizedBox(
              height: 50,
              child: Row(children: const [
                Expanded(
                    child: Center(
                  child: Text(
                    'Nom',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    'Prénom',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    "Nom d'utilisateur",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    'Role',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                SizedBox(
                  width: 100,
                  child: Center(
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
              ? SizedBox(
                  height: MediaQuery.of(context).size.height - 403,
                  child: ListView.builder(
                      itemCount: viewModel.listComptable.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  viewModel.listComptable[index].lastName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  viewModel.listComptable[index].firstName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  viewModel.listComptable[index].username!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  viewModel.listComptable[index].email!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  viewModel.listComptable[index].role!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              SizedBox(
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
                                                avatar: viewModel
                                                    .listComptable[index]
                                                    .avatar!,
                                                email: viewModel
                                                    .listComptable[index]
                                                    .email!,
                                                firstName: viewModel
                                                    .listComptable[index]
                                                    .firstName!,
                                                lastName: viewModel
                                                    .listComptable[index]
                                                    .lastName!,
                                                role: viewModel
                                                    .listComptable[index].role!,
                                                sId: viewModel
                                                    .listComptable[index].sId!,
                                                id: viewModel
                                                        .listComptable[index]
                                                        .restaurant
                                                        .isNull
                                                    ? viewModel
                                                            .listComptable[
                                                                index]
                                                            .laboratory
                                                            .isNull
                                                        ? viewModel
                                                            .listComptable[
                                                                index]
                                                            .laboratory!
                                                            .laboName!
                                                        : ''
                                                    : viewModel
                                                        .listComptable[index]
                                                        .restaurant!
                                                        .sId!,
                                                // username: viewModel
                                                //     .listComptable[index]
                                                //     .username!,
                                              );
                                            }),
                                          );
                                        },
                                      )),
                                      Expanded(
                                          child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Palette.deleteColors),
                                        onPressed: () {
                                          dialogDelete(viewModel
                                              .listComptable[index].lastName!);
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
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 403,
                  child: ListView.builder(
                      itemCount: UserSearch.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  UserSearch[index].lastName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  UserSearch[index].firstName!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  UserSearch[index].username!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  UserSearch[index].email!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(UserSearch[index].role!),
                              )),
                              SizedBox(
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
                                                avatar:
                                                    UserSearch[index].avatar!,
                                                email: UserSearch[index].email!,
                                                firstName: UserSearch[index]
                                                    .firstName!,
                                                lastName:
                                                    UserSearch[index].lastName!,
                                                role: UserSearch[index].role!,
                                                sId: UserSearch[index].sId!,
                                                id: UserSearch[index]
                                                        .restaurant
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
                                              UserSearch[index].lastName!);
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
