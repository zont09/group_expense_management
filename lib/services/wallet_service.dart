import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/repository/wallet_repository.dart';

class WalletService {
  WalletService._privateConstructor();

  static WalletService instance = WalletService._privateConstructor();

  final WalletRepository _walletRepository = WalletRepository.instance;

  Future<List<WalletModel>> getAllWalletByGroup(String gid) async {
    final response = await _walletRepository.getAllWalletByGroup(gid);
    return response;
  }

  Future<WalletModel?> getWalletById(String id) async {
    final response = await _walletRepository.getWalletById(id);
    return response;
  }

  Future<void> addWallet(WalletModel model) async {
    await _walletRepository.addWalletModel(model);
  }

  Future<void> updateWallet(WalletModel model) async {
    await _walletRepository.updateWalletModel(model);
  }
}
