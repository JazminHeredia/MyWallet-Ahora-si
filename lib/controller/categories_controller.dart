import '../model/categories_model.dart';

class CategoriesController {
  List<Category> categories = [];

  void addCategory(Category category) {
    categories.add(category);
    // Add logic to persist the category if needed
  }
}
