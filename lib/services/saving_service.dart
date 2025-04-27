import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/repository/saving_repository.dart';

class SavingService {
  SavingService._privateConstructor();

  static SavingService instance = SavingService._privateConstructor();

  final SavingRepository _savingRepository = SavingRepository.instance;

  Future<List<SavingModel>> getAllSavingsByGroup(String gid) async {
    final response = await _savingRepository.getSavingByGroup(gid);
    return response;
  }

  Future<SavingModel?> getSavingsById(String id) async {
    final response = await _savingRepository.getSavingById(id);
    return response;
  }

  Future<void> addSavings(SavingModel model) async {
    await _savingRepository.addSaving(model);
  }

  Future<void> updateSavings(SavingModel model) async {
    await _savingRepository.updateSaving(model);
  }
}
