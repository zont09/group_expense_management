import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/repository/user_repository.dart';

class UserService {
  UserService._privateConstructor();

  static UserService instance = UserService._privateConstructor();

  final UserRepository _userRepository = UserRepository.instance;

  Future<List<UserModel>> getAllUsers() async {
    final response = await _userRepository.getAllUsers();
    return response;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final response = await _userRepository.getUserByEmail(email);
    return response;
  }

  Future<void> addUser(UserModel model) async {
    await _userRepository.addUser(model);
  }

  Future<void> updateUser(UserModel model) async {
    await _userRepository.updateUser(model);
  }
}
