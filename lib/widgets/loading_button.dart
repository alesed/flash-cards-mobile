import 'package:flashcards/helpers/dialog_handler.dart';
import 'package:flutter/material.dart';

class LoadingButtonWidget {
  final ButtonStyle style;
  final Widget? child;

  LoadingButtonWidget({
    required this.style,
    this.child,
  });
}

class LoadingButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String? text;
  final LoadingButtonWidget? customWidget;

  LoadingButton({
    super.key,
    required this.onPressed,
    this.text,
    this.customWidget,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _buildLoadingWidget(),
    );
  }

  ElevatedButton _buildLoadingWidget() {
    if (widget.customWidget != null) {
      return ElevatedButton(
        onPressed: _handleOnPressed,
        style: widget.customWidget!.style,
        child: widget.customWidget!.child,
      );
    }

    return ElevatedButton(
      onPressed: _handleOnPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      child: Text(
        widget.text ?? "",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _handleOnPressed() async {
    bool errorOccurred = false;
    try {
      showLoadingDialog(context);
      await widget.onPressed();
    } on Exception catch (e) {
      errorOccurred = true;
      hideDialog(context);
      showErrorDialog(context, e.toString());
    } finally {
      if (!errorOccurred) {
        hideDialog(context);
      }
    }
  }
}
