import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/budget/budget_view.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/member/add_member_popup.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/member/member_main_view.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/overview/overview_view.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_budget_popup.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_saving_popup.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_transaction_popup.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_wallet_popup.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/saving/saving_view.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/transaction/transaction_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:intl/intl.dart';

class GroupDetailMobileView extends StatefulWidget {
  final GroupModel group;

  const GroupDetailMobileView({super.key, required this.group});

  @override
  _GroupDetailMobileViewState createState() => _GroupDetailMobileViewState();
}

class _GroupDetailMobileViewState extends State<GroupDetailMobileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'Tổng quan',
    'Giao dịch',
    'Ngân sách',
    'Tiết kiệm',
    'Thành viên'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      GroupDetailCubit(widget.group, MainCubit.fromContext(context),)
        ..initData(),
      child: BlocBuilder<GroupDetailCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<GroupDetailCubit>(c);

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(widget.group.name,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 24),
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor6,
                      shadows: const [ColorConfig.textShadow])),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showGroupSettings(context),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: ColorConfig.primary1,
                labelStyle: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w500),
                tabAlignment: TabAlignment.center,
                indicatorColor: ColorConfig.primary1,
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),
            body: s == 0
                ? Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircularProgressIndicator(
                      color: ColorConfig.primary2,
                    ),
                  )
                ],
              ),
            )
                : TabBarView(
              controller: _tabController,
              children: [
                OverviewView(
                    group: widget.group,
                    tabController: _tabController,
                    cubit: cubit),
                TransactionView(cubitDt: cubit),
                BudgetView(cubitDt: cubit),
                SavingView(
                  savings: cubit.savings ?? [],
                  cubitOv: cubit,
                ),
                MemberMainView(),
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(cubit),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(GroupDetailCubit cubit) {
    return FloatingActionButton(
      onPressed: () => _showAddActionSheet(context, cubit),
      child: const Icon(Icons.add),
    );
  }

  void _showAddActionSheet(BuildContext context, GroupDetailCubit cubit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text('Thêm giao dịch'),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showAlertDialog(context,
                      child: AddTransactionPopup(
                        group: widget.group,
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
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Thêm ví'),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showAlertDialog(context,
                      child: AddWalletPopup(
                          group: widget.group,
                          onAdd: (v) {
                            cubit.addWallet(v);
                          }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text('Thêm ngân sách'),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showAlertDialog(context,
                      child: AddBudgetPopup(
                          group: widget.group,
                          onAdd: (v) {
                            cubit.addBudgetDetail(v);
                          },
                          categories: cubit.categories ?? []));
                },
              ),
              ListTile(
                leading: const Icon(Icons.savings),
                title: const Text('Thêm khoản tiết kiệm'),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showAlertDialog(context,
                      child: AddSavingPopup(
                          group: widget.group,
                          wallets: cubit.wallets ?? [],
                          onAdd: (v) {
                            cubit.addSaving(v);
                          },
                          onUpdate: (v) {
                            cubit.updateSaving(v);
                          },
                          onUpdateWallet: (v) {
                            cubit.updateWallet(v);
                          }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Thêm thành viên'),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showAlertDialog(context, child: AddMemberPopup(
                      group: cubit.group, onUpdateGroup: (v){
                        cubit.updateGroup(v);
                  }));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Transactions Tab
  Widget _buildTransactionsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search transactions',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 20, // Mock data count
            itemBuilder: (context, index) {
              // Mock transaction data
              final bool isExpense = index % 3 != 0;
              final String title =
              isExpense ? 'Expense ${index + 1}' : 'Income ${index + 1}';
              final String amount = isExpense ? '- 150,000 đ' : '+ 300,000 đ';
              final Color amountColor = isExpense ? Colors.red : Colors.green;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                  isExpense ? Colors.red[100] : Colors.green[100],
                  child: Icon(
                    isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isExpense ? Colors.red : Colors.green,
                  ),
                ),
                title: Text(title),
                subtitle: Text(
                    '${DateTime
                        .now()
                        .day - (index % 30)}/${DateTime
                        .now()
                        .month}/2023'),
                trailing: Text(
                  amount,
                  style: TextStyle(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Show transaction details
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Budget Tab
  Widget _buildBudgetTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Budget',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Budget:'),
                      Text(
                        '5,000,000 đ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Spent:'),
                      Text(
                        '3,200,000 đ',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining:'),
                      Text(
                        '1,800,000 đ',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.64,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Budget Categories',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
          const SizedBox(height: 16),
          _buildBudgetCategory('Food', 1500000, 2000000, Colors.orange),
          const SizedBox(height: 16),
          _buildBudgetCategory('Transportation', 500000, 1000000, Colors.green),
          const SizedBox(height: 16),
          _buildBudgetCategory('Entertainment', 800000, 1000000, Colors.purple),
          const SizedBox(height: 16),
          _buildBudgetCategory('Utilities', 400000, 1000000, Colors.blue),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddBudgetCategoryDialog(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Add Budget Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCategory(String name, double spent, double total,
      Color color) {
    final percentage = spent / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    color: percentage > 0.9 ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                      .format(spent),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                      .format(total),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.9 ? Colors.red : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Savings Tab
  Widget _buildSavingsTab() {
    // Mock savings goals
    final savingsGoals = [
      {
        'title': 'Group Trip',
        'target': 10000000.0,
        'current': 5000000.0,
        'date': DateTime(2023, 12, 31),
      },
      {
        'title': 'New Equipment',
        'target': 5000000.0,
        'current': 2000000.0,
        'date': DateTime(2023, 10, 15),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saving Goals',
            style: Theme
                .of(context)
                .textTheme
                .titleLarge,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: savingsGoals.length,
            itemBuilder: (context, index) {
              final goal = savingsGoals[index];
              final percentage =
                  (goal['current']! as double) / (goal['target']! as double);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${(percentage * 100).toInt()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Target date: ${DateFormat('dd/MM/yyyy').format(
                            goal['date'] as DateTime)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                                .format(goal['current']),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                                .format(goal['target']),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showAddContributionDialog(
                                    context, goal['title'] as String),
                            icon: const Icon(Icons.add),
                            label: const Text('Contribute'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _showSavingDetails(goal['title'] as String),
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddSavingDialog(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Add New Saving Goal'),
          ),
        ],
      ),
    );
  }

  // Members Tab
  Widget _buildMembersTab() {
    // Mock members data
    final members = [
      {'name': 'John Doe', 'role': 'Owner', 'avatar': ''},
      {'name': 'Jane Smith', 'role': 'Editor', 'avatar': ''},
      {'name': 'Mike Johnson', 'role': 'Viewer', 'avatar': ''},
      {'name': 'Sarah Williams', 'role': 'Editor', 'avatar': ''},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group Members',
            style: Theme
                .of(context)
                .textTheme
                .titleLarge,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(member['name']!.substring(0, 1)),
                ),
                title: Text(member['name'] as String),
                subtitle: Text(member['role'] as String),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () =>
                      _showMemberOptions(context,
                          member['name'] as String, member['role'] as String),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddMemberDialog(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Add New Member'),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showGroupSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Group Settings'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Group Info'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit group screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Manage Categories'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to categories screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Currency Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to currency settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Leave Group'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLeaveGroupConfirmation(context);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLeaveGroupConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Group?'),
          content: const Text(
              'Are you sure you want to leave this group? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Leave'),
              onPressed: () {
                Navigator.of(context).pop();
                // Handle leaving group
                Navigator.of(context).pop(); // Return to groups list
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String amount = '';
    String category = 'Food';
    String wallet = 'Group Cash';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onSaved: (value) {
                      description = value ?? '';
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      amount = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    value: category,
                    items: [
                      'Food',
                      'Transportation',
                      'Entertainment',
                      'Utilities',
                      'Other'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        category = newValue;
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Wallet'),
                    value: wallet,
                    items: ['Group Cash', 'Event Fund'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        wallet = newValue;
                      }
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        selectedDate = picked;
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Save transaction logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Transaction added successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddWalletDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String amount = '';
    String note = '';
    String currency = 'VND';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Wallet'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Wallet Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Initial Amount'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      amount = value!;
                    },
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Note (Optional)'),
                    onSaved: (value) {
                      note = value ?? '';
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Currency'),
                    value: currency,
                    items: ['VND', 'USD', 'EUR'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        currency = newValue;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Save wallet logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Wallet added successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddSavingDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String targetAmount = '';
    DateTime targetDate = DateTime.now().add(const Duration(days: 30));
    String currency = 'VND';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Saving Goal'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onSaved: (value) {
                      description = value ?? '';
                    },
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Target Amount'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      targetAmount = value!;
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: targetDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != targetDate) {
                        targetDate = picked;
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Target Date',
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(targetDate),
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Currency'),
                    value: currency,
                    items: ['VND', 'USD', 'EUR'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        currency = newValue;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Save saving goal logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Saving goal added successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String email = '';
    int role = 1; // Editor by default

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Role'),
                    value: role,
                    items: [
                      const DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Editor'),
                      ),
                      const DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Viewer'),
                      ),
                    ],
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        role = newValue;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Invite'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Invite member logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Invitation sent successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddBudgetCategoryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String category = '';
    String amount = '';
    String currency = 'VND';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Budget Category'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      'Food',
                      'Transportation',
                      'Entertainment',
                      'Utilities',
                      'Other'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        category = newValue;
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Budget Amount'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      amount = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Currency'),
                    value: currency,
                    items: ['VND', 'USD', 'EUR'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        currency = newValue;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Save budget category logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Budget category added successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddContributionDialog(BuildContext context, String savingTitle) {
    final formKey = GlobalKey<FormState>();
    String amount = '';
    String wallet = 'Group Cash';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contribute to $savingTitle'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      amount = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'From Wallet'),
                    value: wallet,
                    items: ['Group Cash', 'Event Fund'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        wallet = newValue;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Contribute'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Contribute to saving logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Contributed $amount đ to $savingTitle')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSavingDetails(String savingTitle) {
    // Mock transactions for this saving goal
    final transactions = [
      {'date': '01/06/2023', 'amount': '1,000,000 đ', 'user': 'John Doe'},
      {'date': '15/06/2023', 'amount': '2,000,000 đ', 'user': 'Jane Smith'},
      {'date': '01/07/2023', 'amount': '2,000,000 đ', 'user': 'Mike Johnson'},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(savingTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contributions:'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text(transaction['amount']!),
                        subtitle: Text(
                            '${transaction['date']} by ${transaction['user']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Edit Goal'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to edit saving goal
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMemberOptions(BuildContext context, String memberName,
      String role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(memberName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Change Role'),
                onTap: () {
                  Navigator.pop(context);
                  _showChangeRoleDialog(context, memberName, role);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Remove from Group'),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveMemberConfirmation(context, memberName);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangeRoleDialog(BuildContext context, String memberName,
      String currentRole) {
    String newRole = currentRole;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Role for $memberName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Owner'),
                value: 'Owner',
                groupValue: newRole,
                onChanged: (String? value) {
                  if (value != null) {
                    newRole = value;
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Editor'),
                value: 'Editor',
                groupValue: newRole,
                onChanged: (String? value) {
                  if (value != null) {
                    newRole = value;
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Viewer'),
                value: 'Viewer',
                groupValue: newRole,
                onChanged: (String? value) {
                  if (value != null) {
                    newRole = value;
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Change role logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Changed $memberName\'s role to $newRole')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showRemoveMemberConfirmation(BuildContext context, String memberName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove $memberName?'),
          content: Text(
              'Are you sure you want to remove $memberName from this group?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                // Remove member logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Removed $memberName from the group')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
