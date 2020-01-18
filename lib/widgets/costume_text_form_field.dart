import 'package:flutter/material.dart';

import '../Helpers/styling.dart';
import '../Helpers/size_config.dart';
import '../Helpers/app_localizations.dart';

final InputDecoration costumInputDecoration = InputDecoration(
  border: InputBorder.none,
  labelStyle: const TextStyle(color: AppTheme.primaryColor),
  focusedErrorBorder:
      inputBorder.copyWith(borderSide: const BorderSide(color: Colors.red)),
  errorBorder:
      inputBorder.copyWith(borderSide: const BorderSide(color: Colors.red)),
  enabledBorder: inputBorder,
  focusedBorder: inputBorder.copyWith(
      borderSide: const BorderSide(color: AppTheme.accentColor)),
);

class AmountTextFormField extends StatelessWidget {
  const AmountTextFormField({
    @required TextEditingController amountController,
  }) : _amountController = amountController;

  final TextEditingController _amountController;

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return Container(
      width: SizeConfig.isPortrait ? double.infinity : 400,
      child: TextFormField(
        decoration:
            costumInputDecoration.copyWith(labelText: translate('Amount')),
        keyboardType: TextInputType.number,
        controller: _amountController,
        validator: (val) {
          if (double.tryParse(val) == null) {
            return translate('Please enter number');
          }
          if (double.parse(val) <= 0) {
            return '${translate("Please chose bigger number than")} $val';
          }
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
    final translate = AppLocalizations.of(context).translate;

    return Container(
      width: SizeConfig.isPortrait ? double.infinity : 400,
      child: TextFormField(
        decoration:
            costumInputDecoration.copyWith(labelText: translate('Notes')),
        controller: _descriptionController,
        maxLength: 50,
        maxLines: 2,
      ),
    );
  }
}
