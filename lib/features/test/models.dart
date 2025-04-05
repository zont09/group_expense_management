class Transaction {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String wallet;
  final String user;
  final String group;
  final String category;
  final String isRepeat;
  final String enable;
  final DateTime createAt;
  final DateTime updateAt;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.wallet,
    required this.user,
    required this.group,
    required this.category,
    required this.isRepeat,
    required this.enable,
    required this.createAt,
    required this.updateAt,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final List<String> wallets;
  final List<String> groups;
  final bool enable;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.wallets,
    required this.groups,
    required this.enable,
  });
}

class Group {
  final String id;
  final String name;
  final String avatar;
  final List<String> members;
  final String owner;
  final bool enable;

  Group({
    required this.id,
    required this.name,
    required this.avatar,
    required this.members,
    required this.owner,
    required this.enable,
  });
}

class Wallet {
  final String id;
  final String name;
  final double amount;
  final String note;
  final String currency;
  final String user;
  final bool enable;

  Wallet({
    required this.id,
    required this.name,
    required this.amount,
    required this.note,
    required this.currency,
    required this.user,
    required this.enable,
  });
}

class Budget {
  final String id;
  final DateTime date;
  final List<String> detail;
  final String group;
  final bool enable;

  Budget({
    required this.id,
    required this.date,
    required this.detail,
    required this.group,
    required this.enable,
  });
}

class BudgetDetail {
  final String id;
  final String category;
  final String group;
  final double amount;
  final String currency;
  final bool enable;

  BudgetDetail({
    required this.id,
    required this.category,
    required this.group,
    required this.amount,
    required this.currency,
    required this.enable,
  });
}

class Category {
  final String id;
  final String title;
  final String type;
  final bool enable;

  Category({
    required this.id,
    required this.title,
    required this.type,
    required this.enable,
  });
}

class Currency {
  final String id;
  final String name;
  final double value;
  final bool enable;

  Currency({
    required this.id,
    required this.name,
    required this.value,
    required this.enable,
  });
}

class Saving {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final DateTime targetDate;
  final double currentAmount;
  final String currency;
  final List<String> details;
  final String group;
  final bool enable;

  Saving({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.targetDate,
    required this.currentAmount,
    required this.currency,
    required this.details,
    required this.group,
    required this.enable,
  });
}

class UserInGroup {
  final String user;
  final String group;
  final int role;
  final bool enable;

  UserInGroup({
    required this.user,
    required this.group,
    required this.role,
    required this.enable,
  });
}

