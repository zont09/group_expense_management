import 'package:flutter/material.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/budget_summary.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/header_view.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/recent_transaction.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/wallet_summary.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key, required this.group, required this.tabController});
  
  final GroupModel group;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final wallets = [
      WalletModel(id: '1', name: 'Tiền ăn', amount: 1500000, note: 'Để ăn uống hằng ngày', currency: 'VND', user: 'user1', enable: true),
      WalletModel(id: '2', name: 'Tiền mua sắm', amount: 3000000, note: 'Để mua quà lưu niệm, quà tặng cho gia đình', currency: 'VND', user: 'user2', enable: true),
    ];
    //_tabController.animateTo(1)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(group: group),
          const SizedBox(height: 24),
          WalletSummary(wallets: wallets, actionSeeAll: (){
            tabController.animateTo(1);
          }),
          const SizedBox(height: 24),
          RecentTransaction(transactions: [], actionSeeAll: (){
            tabController.animateTo(1);
          }),
          const SizedBox(height: 24),
          BudgetSummary(actionSeeAll: (){
            tabController.animateTo(2);
          }),
        ],
      ),
    );
  }
}
