import 'package:flutter/material.dart';
import 'package:transactions/Helpers/size_config.dart';

import '../Helpers/styling.dart';

final costumInputDecoration = InputDecoration(
  border: InputBorder.none,
  labelStyle: TextStyle(color: AppTheme.primaryColor),
  focusedErrorBorder:
      inputBorder.copyWith(borderSide: BorderSide(color: Colors.red)),
  errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: Colors.red)),
  enabledBorder: inputBorder,
  focusedBorder:
      inputBorder.copyWith(borderSide: BorderSide(color: AppTheme.accentColor)),
);

class AmountTextFormField extends StatelessWidget {
  const AmountTextFormField({
    @required TextEditingController amountController,
  }) : _amountController = amountController;

  final TextEditingController _amountController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.isPortrait ? double.infinity : 400,
      child: TextFormField(
        decoration: costumInputDecoration.copyWith(labelText: 'Amount'),
        keyboardType: TextInputType.number,
        controller: _amountController,
        validator: (val) {
          if (double.tryParse(val) == null) return 'Please enter number';
          if (double.parse(val) <= 0)
            return 'Please chose bigger number than $val';
          return null;
        },
      ),
    );
  }
}

class DescriptionTextFormField extends StatelessWidget {
  const DescriptionTextFormField({
    @required TextEditingController descriptionController,
  }) : _descriptionController = descriptionController;

  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.isPortrait ? double.infinity : 400,
      child: TextFormField(
        decoration: costumInputDecoration.copyWith(labelText: 'Notes'),
        controller: _descriptionController,
        maxLength: 50,
        maxLines: 2,
      ),
    );
  }
}
