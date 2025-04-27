import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:intl/intl.dart';

class DayPickerCustom extends StatefulWidget {
  const DayPickerCustom({
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
  _DayPickerCustomState createState() => _DayPickerCustomState();
}

class _DayPickerCustomState extends State<DayPickerCustom> {
  Future<void> _selectDay(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConfig.hintText,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorConfig.hintText,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: ColorConfig.hintText,
              headerForegroundColor: Colors.white,
              dayStyle: TextStyle(color: ColorConfig.hintText),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.2),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      widget.controller.text = formattedDate;
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.canEdit,
      readOnly: true,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ColorConfig.hintText,
        ),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: ColorConfig.hintText,
        ),
      ),
      onTap: () => _selectDay(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a day';
        }
        return null;
      },
    );
  }
}
