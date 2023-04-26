import 'package:flashcards/features/auth/models/auth_exception.dart';
import 'package:flashcards/helpers/dialog_handler.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  LoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Future<void> Function() onPressed;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleOnPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _handleOnPressed() async {
    bool errorOccured = false;
    try {
      showLoadingDialog(context);
      await widget.onPressed();
    } on AuthException catch (e) {
      errorOccured = true;
      hideDialog(context);
      showErrorDialog(context, e.toString());
    } finally {
      if (!errorOccured) {
        hideDialog(context);
      }
    }
  }
}
