import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'TransactionBeliModel-test-inherit.dart';


class StateContainerTestInherit extends StatefulWidget {
  final Widget child;
  final TransactionBeliModelTestInherit transactionBeliModel;

  StateContainerTestInherit({
    @required this.child,
    this.transactionBeliModel,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainerTestInherit> {
  TransactionBeliModelTestInherit model;

  void updateModel({currentStep, currencyCode, rate, volume, visibilityFormInput,visibilityFormResult, currencyController, currencyResult, transaction}) {
    if (model == null) {
      model = new TransactionBeliModelTestInherit(currentStep, currencyCode, rate, volume, 
                visibilityFormInput, visibilityFormResult, currencyController, currencyResult, transaction);
      setState(() {
        model = model;
      });
    } else {
      setState(() {
        model.currentStep = currentStep ?? model.currentStep;
        model.currencyCode = currencyCode ?? model.currencyCode;
        model.rate = rate ?? model.rate;
        model.volume = volume ?? model.volume;
        model.visibilityFormInput = visibilityFormInput ?? model.visibilityFormInput;
        model.visibilityFormResult = visibilityFormResult ?? model.visibilityFormResult;
        model.currencyController = currencyController ?? model.currencyController;
        model.currencyResult = currencyResult ?? model.currencyResult;
        model.transaction = transaction ?? model.transaction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}