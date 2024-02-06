import 'package:flutter/cupertino.dart';

mixin DialogHelper {
  void showMessage(
    BuildContext context, {
    required DialogHelperData parameters,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(parameters.title),
        content: Text(parameters.message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(parameters.buttonTitle),
          ),
        ],
      ),
    );
  }
}

final class DialogHelperData {
  final String title;
  final String message;
  final String buttonTitle;

  DialogHelperData({
    required this.title,
    required this.message,
    this.buttonTitle = 'OK',
  });
}
