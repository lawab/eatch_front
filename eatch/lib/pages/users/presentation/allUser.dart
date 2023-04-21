import 'package:eatch/pages/users/application/search_users_text_field.dart';
import 'package:eatch/pages/users/domain/user.dart';
import 'package:eatch/pages/users/infrastructure/users_data.dart';
import 'package:eatch/servicesAPI/getUser.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      )),
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
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
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      )),
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
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
}
