import 'package:flutter/material.dart';

class OtpFieldStyle {
  /// The background color for outlined box.
  final Color backgroundColor;

  /// The background color for valued outlined box.
  final Color valueBackgroundColor;

  // The background color for focused outlined box.
  final Color focusBackgroundColor;

  /// The border color text field.
  final Color borderColor;

  /// The background color for valued outlined box.
  final Color valueBorderColor;

  /// The border color of text field when in focus.
  final Color focusBorderColor;

  /// The border color of text field when disabled.
  final Color disabledBorderColor;

  /// The border color of text field when in focus.
  final Color enabledBorderColor;

  /// The border color of text field when disabled.
  final Color errorBorderColor;

  OtpFieldStyle({
    this.backgroundColor: Colors.transparent,
    this.focusBackgroundColor: Colors.transparent,
    this.valueBackgroundColor: Colors.transparent,
    this.borderColor: Colors.black26,
    this.focusBorderColor: Colors.blue,
    this.disabledBorderColor: Colors.grey,
    this.enabledBorderColor: Colors.black26,
    this.errorBorderColor: Colors.red,
    this.valueBorderColor: Colors.black26,
  });
}
