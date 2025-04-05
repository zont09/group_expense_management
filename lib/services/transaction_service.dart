import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/repository/transaction_repository.dart';
import 'package:group_expense_management/repository/user_repository.dart';

class TransactionService {
  TransactionService._privateConstructor();

  static TransactionService instance = TransactionService._privateConstructor();

  final TransactionRepository _userRepository = TransactionRepository.instance;

  Future<List<TransactionModel>> getAllTransactionByGroup(String gid) async {
    final response = await _userRepository.getAllTransactionsByGroup(gid);
    return response;
  }

  Future<List<TransactionModel>> getAllTransactionByWallet(String wid) async {
    final response = await _userRepository.getAllTransactionsByWallet(wid);
    return response;
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    final response = await _userRepository.getTransactionById(id);
    return response;
  }

  Future<void> addTransaction(TransactionModel model) async {
    await _userRepository.addTransaction(model);
  }

  Future<void> updateTransaction(TransactionModel model) async {
    await _userRepository.updateTransaction(model);
  }
}
