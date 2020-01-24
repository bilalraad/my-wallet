import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../DB/bills.dart';
import '../Helpers/styling.dart';
import '../widgets/show_overlay.dart';
import '../DB/initialize_HiveDB.dart';
import '../widgets/date_time_picker.dart';
import '../Helpers/app_localizations.dart';
import '../widgets/select_category_widget.dart';
import '../widgets/costume_text_form_field.dart';

enum RepeatType {
  Forever,
  Until,
}

class AddBill extends StatefulWidget {
  @override
  _AddBillState createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repeatNumberController = TextEditingController(text: '1');
  final _form = GlobalKey<FormState>();
  DateTime _startingDate = DateTime.now();
  DateTime _endingDate;
  BillType _billType = BillType.Daily;
  RepeatType _repeatType = RepeatType.Forever;

  Bill _newBill = Bill(
    billType: null,
    category: '',
    endingDate: null,
    id: Uuid().v4().toString(),
    startingDate: null,
    amount: null,
    days: null,
    description: null,
    remainingDays: null,
  );

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _repeatNumberController.dispose();
    super.dispose();
  }

  void _onSelectedCategory(String cat) {
    _newBill = _newBill.updateBill(category: cat);
  }

  void setPickedDate({bool isEndingDate, DateTime pickedDate}) {
    setState(
      () {
        !isEndingDate ? _startingDate = pickedDate : _endingDate = pickedDate;
      },
    );
  }

  Future<void> _submit() async {
    final _bills = Hive.box(H.bills.box()).get(H.bills.str()) as Bills;

    if (!_form.currentState.validate()) return;

    if (_newBill.category.isEmpty) {
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

    _newBill = _newBill.updateBill(
      amount: _amount,
      startingDate: _startingDate,
      endingDate: _endingDate,
      description: _descriptionController.text,
      billType: _billType,
      days: _days,
      remainingDays: _days,
    );
    _bills.addBill(_newBill);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Add Bill')),
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
                AmountTextFormField(amountController: _amountController),
                const SizedBox(
                  height: 40,
                ),
                SelectCategoryWidget(
                  categoryName: _newBill.category,
                  isIncome: false,
                  onSelectedCategory: _onSelectedCategory,
                ),
                const SizedBox(
                  height: 40,
                ),
                DescriptionTextFormField(
                  descriptionController: _descriptionController,
                ),
                DropdownButton<BillType>(
                  //To select Bill type
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
                              style: const TextStyle(fontSize: 17),
                              decoration: const InputDecoration(),
                              validator: (val) {
                                if (double.tryParse(val) == null) {
                                  return 'Enter number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Text(
                          translate(getnNameOfBillType(_billType)),
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
                    date: _endingDate,
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
