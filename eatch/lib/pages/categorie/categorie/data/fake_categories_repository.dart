import '../domain/categorie.dart';
import 'test_categories.dart';

class FakeCategoriesRepository {
  FakeCategoriesRepository._();
  static FakeCategoriesRepository instance = FakeCategoriesRepository._();

  final List<Categorie> _products = kTestCategories;

  List<Categorie> getCategoriesList() {
    return _products;
  }

  Categorie? getCategorie(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Categorie>> fetchCategoriesList() {
    return Future.value(_products);
  }

  Stream<List<Categorie>> watchCategoriesList() {
    return Stream.value(_products);
  }

  Stream<Categorie?> watchProduct(String id) {
    return watchCategoriesList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}
