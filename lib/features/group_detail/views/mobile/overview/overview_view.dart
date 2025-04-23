import 'package:flutter/material.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/budget_summary.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/header_view.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/recent_transaction.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/wallet_summary.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_transaction_popup.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key,
    required this.group,
    required this.tabController,
    required this.cubit});

  final GroupModel group;
  final TabController tabController;
  final GroupDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    //_tabController.animateTo(1)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(group: group),
          const SizedBox(height: 24),
          WalletSummary(
              wallets: cubit.wallets ?? [],
              actionSeeAll: () {
                tabController.animateTo(1);
              }),
          const SizedBox(height: 24),
          RecentTransaction(
            transactions: cubit.transactions ?? [],
            actionSeeAll: () {
              tabController.animateTo(1);
            },
            seeDetail: (v) {
              DialogUtils.showAlertDialog(context, child: AddTransactionPopup(
                  group: group,
                  wallets: cubit.wallets ?? [],
                  categories: cubit.categories ?? [],
                  onAdd: (v) {
                    cubit.addTransaction(v);
                  },
                  onUpdateTrans: (v) {
                    cubit.updateTransaction(v);
                  },
                  onUpdateWallet: (v) {
                    cubit.updateWallet(v);
                  },
                isEdit: true,
                model: v,
              ),);
            },
          ),
          const SizedBox(height: 24),
          BudgetSummary(actionSeeAll: () {
            tabController.animateTo(2);
          },
          details: cubit.budgetDetails ?? [],
          mapBudgetValue: cubit.mapMoneyBudget,
          mapCate: cubit.mapCate,),
        ],
      ),
    );
  }
}
