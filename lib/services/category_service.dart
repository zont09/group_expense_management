import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/repository/category_repository.dart';

class CategoryService {
  CategoryService._privateConstructor();

  static CategoryService instance = CategoryService._privateConstructor();

  final CategoryRepository _categoryRepository = CategoryRepository.instance;

  Future<List<CategoryModel>> getAllCategory() async {
    final response = await _categoryRepository.getAllCategory();
    return response;
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    final response = await _categoryRepository.getCategoryById(id);
    return response;
  }

  Future<void> addCategory(CategoryModel model) async {
    await _categoryRepository.addCategory(model);
  }

  Future<void> updateCategory(CategoryModel model) async {
    await _categoryRepository.updateCategory(model);
  }
}
