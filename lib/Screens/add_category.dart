import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:transactions/Helpers/size_config.dart';

import '../Helpers/styling.dart';
import '../widgets/select_category_widget.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _catNameController = TextEditingController();

  bool _isvalidate = true;
  String dropdownValue = 'Income';
  bool isIncomeList = true;
  String _parentCatName = '';

  @override
  void dispose() {
    _catNameController.dispose();
    super.dispose();
  }

  void _onSelectedCategory(String parentCatName) {
      _parentCatName = parentCatName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_catNameController.text.isEmpty ||
                  _catNameController.text.length <= 2) {
                setState(() {
                  _isvalidate = false;
                });

                return;
              }

              Hive.box('categoriesBox').get('categories').addCategory(
                    _catNameController.text,
                    _parentCatName,
                    isIncomeList,
                  );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: SizeConfig.isPortrait
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: SizeConfig.isPortrait ? double.infinity : 400,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  errorText: _isvalidate ? null : 'please enter name',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedErrorBorder: inputBorder.copyWith(
                      borderSide: BorderSide(color: Colors.red)),
                  errorBorder: inputBorder.copyWith(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder.copyWith(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                ),
                controller: _catNameController,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
                if (newValue == 'Expense') {
                  isIncomeList = false;
                } else {
                  isIncomeList = true;
                }
              },
              items: <String>['Income', 'Expense']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '*Optional',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SelectCategoryWidget(
              categoryName: _parentCatName,
              isIncome: isIncomeList,
              onSelectedCategory: _onSelectedCategory,
              isComingFromAddcategory: true,
            ),
          ],
        ),
      ),
    );
  }
}