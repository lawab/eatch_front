import '../domain/menu.dart';
import 'menus_data.dart';

class MenusRepository {
  MenusRepository._();
  static MenusRepository instance = MenusRepository._();

  final List<Menu> _menus = menusData;

  List<Menu> getMenusList() {
    return _menus;
  }

  Menu? getMenu(String id) {
    return _menus.firstWhere((menu) => menu.id == id);
  }

  Future<List<Menu>> fetchMenusList() {
    return Future.value(_menus);
  }

  Stream<List<Menu>> watchMenusList() {
    return Stream.value(_menus);
  }

  Stream<Menu?> watchMenu(String id) {
    return watchMenusList()
        .map((menus) => menus.firstWhere((menu) => menu.id == id));
  }
}
