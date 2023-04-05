import '../domain/categorie.dart';
import 'categories_data.dart';

class CategoriesRepository {
  CategoriesRepository._();
  static CategoriesRepository instance = CategoriesRepository._();

  final List<Categorie> _categories = categoriesData;

  List<Categorie> getCategoriesList() {
    return _categories;
  }

  Categorie? getCategorie(String id) {
    return _categories.firstWhere((categorie) => categorie.id == id);
  }

  Future<List<Categorie>> fetchCategoriesList() {
    return Future.value(_categories);
  }

  Stream<List<Categorie>> watchCategoriesList() {
    return Stream.value(_categories);
  }

  Stream<Categorie?> watchCategorie(String id) {
    return watchCategoriesList().map((categories) =>
        categories.firstWhere((categorie) => categorie.id == id));
  }
}
