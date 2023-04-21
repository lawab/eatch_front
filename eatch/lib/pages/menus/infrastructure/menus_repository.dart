import '../domain/menu.dart';
import 'menus_data.dart';

class MenusRepository {
  MenusRepository._();
  static MenusRepository instance = MenusRepository._();

  final List<Menu> _menus = menusData;

  List<Menu> getMenusList() {
    return _menus;
  }
}

final menusList = MenusRepository.instance.getMenusList();
