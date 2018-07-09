import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/concept.dart';
import 'package:maui/db/dao/concept_dao.dart';

class ConceptRepo {
  static final ConceptDao conceptDao = new ConceptDao();

  const ConceptRepo();

  Future<Concept> getConcept(int id) async {
    return conceptDao.getConcept(id);
  }

  Future<List<Concept>> getConcepts() async {
    return conceptDao.getConcepts();
  }
}
