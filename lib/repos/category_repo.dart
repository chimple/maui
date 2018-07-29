import 'dart:async';

import 'package:maui/db/entity/category.dart';
import 'package:maui/db/dao/category_dao.dart';

class CategoryRepo {
  static final CategoryDao categoryDao = CategoryDao();

  const CategoryRepo();

  Future<Category> getCategory(String id) async {
    return await categoryDao.getCategory(id);
  }
   Future<List<Category>> getAllCategories() async {
    return await categoryDao.getAllCategories();
  }
}