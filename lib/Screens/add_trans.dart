import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../DB/bills.dart';
import '../DB/app_state.dart';
import '../DB/transactions.dart';
import '../Helpers/size_config.dart';
import '../widgets/show_overlay.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';
import '../widgets/select_category_widget.dart';
import '../widgets/costume_text_form_field.dart';

class AddTransactions extends StatefulWidget {
  final bool isDeposit;

  const AddTransactions({@required this.isDeposit});
  @override
  _AddTransactionsState createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  final _form = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _pickedDate = DateTime.now();
  String _category = '';

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSelectedCategory(String catName) {
    _category = catName;
  }

  Future<void> _submit() async {
    final _navigator = Navigator.of(context);
    final isVilad = _form.currentState.validate();
    if (!isVilad) return;

    final double _total = Hive.box(H.transactions.box())
        .get(H.transactions.str())
        .total as double;

    final _amount = double.parse(_amountController.text);
    final translate = AppLocalizations.of(context).translate;

    if (_category.isEmpty) {
      showOverlay(context: context, text: "Please select category");
      return;
    }

    if (!widget.isDeposit) {
      if (_total < _amount) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(translate('Do you want to proceed')),
            title: Text(
              translate(_total == 0
                  ? "There's no money in your wallet"
                  : "There's no enough money in your wallet"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _navigator.pop();
                },
                child: Text(translate('No')),
              ),
              FlatButton(
                onPressed: () {
                  addTrans();
                  _navigator.pop();
                  _navigator.pop();
                },
                child: Text(translate('Yes')),
              ),
            ],
          ),
        );
        return;
      }
    }
    addTrans();

    _navigator.pop();
  }

  Future<void> addTrans() async {
    final transactions = Hive.box(H.transactions.box())
        .get(H.transactions.str()) as Transactions;
    double _amount = double.parse(_amountController.text);

    if (DateTime.now().isBefore(_pickedDate)) {
      final _newFutureTrans = FutureTransaction(
        id: Uuid().v4().toString(),
        isDeposit: widget.isDeposit,
        isrecurring: false,
        costumeBill: Bill(
          amount: _amount,
          category: _category,
          description: _descriptionController.text,
          billType: BillType.FutureTrans,
          startingDate: _pickedDate,
          endingDate: null,
          days: null,
          id: null,
          remainingDays: 0,
          excuteDate: _pickedDate,
        ),
      );
      transactions.addFutureTrans(_newFutureTrans);
    } else {
      final valueOfSaving = _amount.getValueOfSaving();
      if (widget.isDeposit) {
        _amount -= valueOfSaving;
        valueOfSaving.addToSavingTotal();
      }
      final _newTransData = Trans(
        amount: _amount,
        category: _category,
        dateTime: _pickedDate,
        id: Uuid().v4().toString(),
        description: _descriptionController.text,
        isDeposit: widget.isDeposit,
      );
      await transactions.addTrans(_newTransData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(translate('Add transaction')),
            Text(
              translate(widget.isDeposit ? 'Deposit' : 'Withdrawal'),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).accentColor,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 4 * SizeConfig.heightMultiplier,
                    ),
                    AmountTextFormField(
                      amountController: _amountController,
                    ),
                    SizedBox(
                      height: 4 * SizeConfig.heightMultiplier,
                    ),
                    SelectCategoryWidget(
                      categoryName: _category,
                      isIncome: widget.isDeposit,
                      onSelectedCategory: _onSelectedCategory,
                    ),
                    SizedBox(
                      height: 4 * SizeConfig.heightMultiplier,
                    ),
                    DescriptionTextFormField(
                      descriptionController: _descriptionController,
                    ),
                    SizedBox(
                      height: 4 * SizeConfig.heightMultiplier,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${translate('Choose date')}:',
                          style: TextStyle(
                              fontSize: 3 * SizeConfig.textMultiplier),
                        ),
                        SizedBox(
                          width: 10 * SizeConfig.widthMultiplier,
                        ),
                        RaisedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text(
                            _pickedDate.day == DateTime.now().day
                                ? translate('Today')
                                : DateFormat.yMd().format(_pickedDate),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: _pickedDate,
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2021),
                            ).then(
                              (pickedValue) {
                                if (pickedValue != null) {
                                  setState(
                                    () {
                                      _pickedDate = pickedValue;
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
