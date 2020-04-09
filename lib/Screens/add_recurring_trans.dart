import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import './add_bill.dart';
import '../DB/bills.dart';
import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../DB/initialize_HiveDB.dart';
import '../widgets/show_overlay.dart';
import '../widgets/date_time_picker.dart';
import '../Helpers/app_localizations.dart';
import '../widgets/select_category_widget.dart';
import '../widgets/costume_text_form_field.dart';

class AddRecurringTransaction extends StatefulWidget {
  @override
  _AddRecurringTransactionState createState() =>
      _AddRecurringTransactionState();
}

class _AddRecurringTransactionState extends State<AddRecurringTransaction> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repeatNumberController = TextEditingController(text: '1');
  final _form = GlobalKey<FormState>();

  DateTime _startingDate = DateTime.now();
  DateTime _endingDate;
  BillType _billType = BillType.Daily;
  RepeatType _repeatType = RepeatType.Forever;
  String _category = '';
  String _dropdownValue = 'Income';
  bool _isDeposit = true;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _repeatNumberController.dispose();
    super.dispose();
  }

  void _onSelectedCategory(String cat) {
    setState(() {
      _category = cat;
    });
  }

  void setPickedDate({bool isEndingDate, DateTime pickedDate}) {
    setState(
      () {
        !isEndingDate ? _startingDate = pickedDate : _endingDate = pickedDate;
      },
    );
  }

  void _submit() {
    final _transactions = Hive.box(H.transactions.box())
        .get(H.transactions.str()) as Transactions;

    if (!_form.currentState.validate()) return;

    if (_category.isEmpty) {
      showOverlay(context: context, text: "Please select category");
      return;
    }
    int _days;
    final _amount = double.parse(_amountController.text);

    if (_billType == BillType.Monthly) {
      _days = int.parse(_repeatNumberController.text) * 30;
    } else if (_billType == BillType.Weekly) {
      _days = int.parse(_repeatNumberController.text) * 7;
    } else if (_billType == BillType.Daily) {
      _days = int.parse(_repeatNumberController.text);
    } else {
      _days = int.parse(_repeatNumberController.text) * 365;
    }
    final _newFT = FutureTransaction(
      id: Uuid().v4().toString(),
      isDeposit: _isDeposit,
      isrecurring: true,
      costumeBill: Bill(
        billType: _billType,
        category: _category,
        endingDate: _endingDate,
        id: null,
        startingDate: _startingDate,
        amount: _amount,
        days: _days,
        description: _descriptionController.text,
        remainingDays: _days,
        excuteDate: _startingDate.add(Duration(days: _days)),
      ),
    );
    _transactions.addFutureTrans(_newFT);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Add recurring transaction'),
          softWrap: true,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submit,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                AmountTextFormField(
                  amountController: _amountController,
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  value: _dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  onChanged: (String newValue) {
                    setState(() {
                      _dropdownValue = newValue;
                      
                    });
                    if (newValue == 'Expense') {
                      _isDeposit = false;
                    } else {
                      _isDeposit = true;
                    }
                  },
                  items: <String>['Income', 'Expense']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(translate(value)),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                SelectCategoryWidget(
                  categoryName: _category,
                  isIncome: _isDeposit,
                  onSelectedCategory: _onSelectedCategory,
                ),
                const SizedBox(
                  height: 40,
                ),
                DescriptionTextFormField(
                  descriptionController: _descriptionController,
                ),
                DropdownButton<BillType>(
                  value: _billType,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  onChanged: (BillType newValue) {
                    setState(
                      () {
                        _billType = newValue;
                      },
                    );
                  },
                  items: <BillType>[
                    BillType.Monthly,
                    BillType.Weekly,
                    BillType.Daily,
                    BillType.Yearly,
                  ].map<DropdownMenuItem<BillType>>(
                    (BillType value) {
                      return DropdownMenuItem<BillType>(
                        value: value,
                        child: Text(translate(value.toString())),
                      );
                    },
                  ).toList(),
                ),
                Column(
                  children: <Widget>[
                    DateTimePicker(
                      date: _startingDate,
                      setPickedDate: setPickedDate,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          translate('Repeat every'),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 30,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _repeatNumberController,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 17),
                              decoration: const InputDecoration(),
                              validator: (val) {
                                if (double.tryParse(val) == null) {
                                  return translate('enter number');
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                        Text(
                          translate(getNameOfBillType(_billType)),
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ],
                ),
                DropdownButton<RepeatType>(
                  value: _repeatType,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  onChanged: (RepeatType newValue) {
                    setState(
                      () {
                        _repeatType = newValue;
                      },
                    );
                  },
                  items: <RepeatType>[
                    RepeatType.Forever,
                    RepeatType.Until,
                  ].map<DropdownMenuItem<RepeatType>>(
                    (RepeatType value) {
                      return DropdownMenuItem<RepeatType>(
                        value: value,
                        child: Text(translate(value.toString())),
                      );
                    },
                  ).toList(),
                ),
                if (_repeatType != RepeatType.Forever)
                  DateTimePicker(
                    date: _startingDate,
                    setPickedDate: setPickedDate,
                    isEndingDate: true,
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
