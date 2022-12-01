import 'package:exptrak/models/category.dart';
import 'package:exptrak/models/expense.dart';
import 'package:realm/realm.dart';

var _config = Configuration.local([Expense.schema, Category.schema]);

var realm = Realm(_config);