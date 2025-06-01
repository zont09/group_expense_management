import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/app_configs.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/budget_model.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = AppConfigs.apiGeminiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> getChatResponse(String message) async {
    final uri = Uri.parse('$baseUrl?key=$apiKey');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': message}
          ]
        }
      ]
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List<dynamic>;
        if (candidates.isNotEmpty) {
          return candidates.first['content']['parts'][0]['text'];
        } else {
          return 'Không có phản hồi từ chatbot.';
        }
      } else {
        debugPrint('Lỗi API: ${response.statusCode} - ${response.body}');
        return 'Lỗi API: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Lỗi kết nối: $e';
    }
  }

  static String createPrompt(
      String userQuestion,
      List<TransactionModel> transactions,
      List<WalletModel> wallets,
      List<BudgetModel> budgets,
      List<BudgetDetailModel> budgetDetails,
      List<CategoryModel> categories,
      List<GroupModel> groups,
      List<SavingModel> savings,
      List<UserModel> users) {
    return '''
    Hãy đóng vai là 1 chuyên gia tư vấn trong lĩnh vực tài chính và quản lý chi tiêu, bạn đang tư vấn cho người hỏi về cách quản lý chi tiêu trong nhóm. Người dùng đang hỏi: "$userQuestion". 
    Hãy trả lời với các lời khuyên hoặc phân tích tài chính phù hợp, giúp người dùng quản lý chi tiêu của mình hiệu quả hơn.
    Đây là dữ liệu đính kèm, hãy sử dụng thông tin từ nó để trả lời câu hỏi trên:
    Giao dịch: ${getPromptTransaction(transactions)}
    Ví: ${getPromptWallet(wallets)}
    Chi tiêu: ${getPromptBudget(budgets)}
    Chi tiết chi tiêu: ${getPromptBudgetDetail(budgetDetails)}
    Danh mục: ${getPromptCategory(categories)}
    Nhóm: ${getPromptGroup(groups)}
    Tiền tiết kiệm: ${getPromptSaving(savings)}
    Người dùng: ${getPromptUser(users)}
  ''';
  }

  static String getPromptTransaction(List<TransactionModel> transactions) {
    String prompt = "";
    for (int i = 0; i < transactions.length; i++) {
      prompt += "${i + 1}, ${transactions[i].toString()}";
    }
    return prompt;
  }

  static String getPromptWallet(List<WalletModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }

  static String getPromptBudget(List<BudgetModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }

  static String getPromptBudgetDetail(List<BudgetDetailModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }

  static String getPromptCategory(List<CategoryModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }

  static String getPromptGroup(List<GroupModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }

  static String getPromptSaving(List<SavingModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }

  static String getPromptUser(List<UserModel> list) {
    String prompt = "";
    for (int i = 0; i < list.length; i++) {
      prompt += "${i + 1}, ${list[i].toString()}";
    }
    return prompt;
  }
}
