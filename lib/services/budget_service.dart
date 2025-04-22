import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/budget_model.dart';
import 'package:group_expense_management/repository/budget_repository.dart';

class BudgetService {
  BudgetService._privateConstructor();

  static BudgetService instance = BudgetService._privateConstructor();

  final BudgetRepository _budgetRepository = BudgetRepository.instance;

  Future<List<BudgetModel>> getAllBudget() async {
    final response = await _budgetRepository.getAllBudgets();
    return response;
  }

  Future<List<BudgetModel>> getBudgetByGroup(String gid) async {
    final response = await _budgetRepository.getBudgetByGroup(gid);
    return response;
  }

  Future<BudgetModel?> getBudgetByGroupAndDate(String gid, DateTime date) async {
    final response = await _budgetRepository.getBudgetByGroupAndDate(gid, date);
    return response;
  }

  Future<BudgetModel?> getBudgetById(String id) async {
    final response = await _budgetRepository.getBudgetById(id);
    return response;
  }

  Future<void> addBudget(BudgetModel model) async {
    await _budgetRepository.addBudget(model);
  }

  Future<void> updateBudget(BudgetModel model) async {
    await _budgetRepository.updateBudget(model);
  }

  Future<List<BudgetDetailModel>> getAllBudgetDetail() async {
    final response = await _budgetRepository.getAllBudgetDetails();
    return response;
  }

  Future<BudgetDetailModel?> getBudgetDetailById(String id) async {
    final response = await _budgetRepository.getBudgetDetailById(id);
    return response;
  }

  Future<BudgetDetailModel?> getBudgetDetailByBudgetCateDate(String bid, String cid, DateTime date) async {
    final response = await _budgetRepository.getBudgetDetailByBudgetCateDate(bid, cid, date);
    return response;
  }

  Future<void> addBudgetDetail(BudgetDetailModel model) async {
    await _budgetRepository.addBudgetDetail(model);
  }

  Future<void> updateBudgetDetail(BudgetDetailModel model) async {
    await _budgetRepository.updateBudgetDetail(model);
  }
}
