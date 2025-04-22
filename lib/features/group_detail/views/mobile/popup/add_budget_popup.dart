import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_budget_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_wallet_cubit.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/currency_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/toast_utils.dart';
import 'package:group_expense_management/widgets/text_field_custom.dart';
import 'package:group_expense_management/widgets/z_button.dart';
import 'package:intl/intl.dart';

class AddBudgetPopup extends StatelessWidget {
  const AddBudgetPopup(
      {super.key,
      required this.group,
      required this.onAdd,
      required this.categories});

  final List<CategoryModel> categories;
  final GroupModel group;
  final Function(BudgetDetailModel) onAdd;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return BlocProvider(
      create: (context) => AddBudgetCubit(group)..initData(categories),
      child: BlocBuilder<AddBudgetCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<AddBudgetCubit>(c);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Thêm ngân sách",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor6),
                ),
                DropdownCategory(
                  title: "Loại ngân sách",
                  initItem: cubit.category,
                  items: cubit.listCategory.where((e) => e.type == 0).toList(),
                  onChanged: (v) {
                    cubit.category = v;
                  },
                ),
                MonthPickerCustom(
                  title: 'Chọn tháng',
                  controller: TextEditingController(text: "${cubit.date.month}/${cubit.date.year}"),
                  canEdit: true,
                  onDateSelected: (v) {
                    cubit.changeDate(v);
                  },
                ),
                TextFieldCustom(
                    title: "Ngân sách",
                    controller: cubit.conAmount,
                    isNumberOnly: true),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ZButton(
                        title: AppText.btnCancel.text,
                        colorBackground: Colors.transparent,
                        colorBorder: Colors.transparent,
                        paddingHor: 12,
                        colorTitle: ColorConfig.primary2,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    const SizedBox(width: 10),
                    ZButton(
                        title: "Thêm",
                        paddingHor: 12,
                        colorBackground: ColorConfig.primary2,
                        colorTitle: Colors.white,
                        onPressed: () async {
                          if(cubit.category == null) {
                            ToastUtils.showBottomToast(context, "Vui lòng chọn loại ngân sách");
                            return;
                          }
                          DialogUtils.showLoadingDialog(context);
                          final model = await cubit.addBudget(context);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                          if(model == null) {
                            return;
                          }
                          onAdd(model);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class DropdownCategory extends StatelessWidget {
  const DropdownCategory(
      {super.key,
      required this.title,
      required this.initItem,
      required this.items,
      required this.onChanged});

  final String title;
  final CategoryModel? initItem;
  final List<CategoryModel> items;
  final Function(CategoryModel) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryModel>(
      decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorConfig.hintText)),
      value: initItem,
      items: items.map((e) {
        return DropdownMenuItem<CategoryModel>(
          value: e,
          child: Text(e.title),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) {
          onChanged(v);
        }
      },
    );
  }
}

class MonthPickerCustom extends StatefulWidget {
  const MonthPickerCustom({
    super.key,
    required this.title,
    required this.controller,
    this.canEdit = true,
    required this.onDateSelected,
  });

  final String title;
  final TextEditingController controller;
  final bool canEdit;
  final ValueChanged<DateTime> onDateSelected;

  @override
  _MonthPickerCustomState createState() => _MonthPickerCustomState();
}

class _MonthPickerCustomState extends State<MonthPickerCustom> {
  Future<void> _selectMonth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConfig.hintText, // Màu chính của picker
              onPrimary: Colors.white, // Màu chữ trên nền primary
              surface: Colors.white, // Nền của picker
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorConfig.hintText, // Màu chữ nút
              ),
            ),
            // Tùy chỉnh để ẩn ngày
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: ColorConfig.hintText,
              headerForegroundColor: Colors.white,
              yearStyle: TextStyle(color: ColorConfig.hintText),
              // monthStyle: TextStyle(color: ColorConfig.hintText),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Tăng kích thước chữ để làm nổi bật tháng/năm
              textScaler: TextScaler.linear(1.2),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedDate != null) {
      // Định dạng chỉ lấy tháng và năm cho UI
      String formattedDate = DateFormat('MM/yyyy').format(pickedDate);
      widget.controller.text = formattedDate;
      // Trả về DateTime với năm và tháng
      widget.onDateSelected(DateTime(pickedDate.year, pickedDate.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.canEdit,
      readOnly: true, // Không cho phép nhập tay
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ColorConfig.hintText,
        ),
        suffixIcon: Icon(
          Icons.calendar_month,
          color: ColorConfig.hintText,
        ),
      ),
      onTap: () => _selectMonth(context), // Mở picker khi nhấn
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a month';
        }
        return null;
      },
    );
  }
}