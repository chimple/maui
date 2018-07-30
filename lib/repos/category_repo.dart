import 'dart:async';

import 'package:maui/db/entity/category.dart';
import 'package:maui/db/dao/category_dao.dart';

class CategoryRepo {
  static final CategoryDao categoryDao = CategoryDao();

  const CategoryRepo();

  Future<List<Category>> getCategories() async {
    return await categoryDao.getCategories();
  }

  Future<List<Category>> getSubcategoriesByCategoryId(String categoryId) async {
    return await categoryDao.getSubcategoriesByCategoryId(categoryId);
  }
}
