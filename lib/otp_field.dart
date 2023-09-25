import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OTPTextField extends StatefulWidget {
  /// TextField Controller
  final OtpFieldController? controller;

  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// space between the text fields
  final double spaceBetween;

  /// content padding of the text fields
  final EdgeInsets contentPadding;

  /// Manage the type of keyboard that shows up
  final TextInputType keyboardType;

  /// show the error border or not
  final bool hasError;

  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// The style to use for the value text being edited.
  final TextStyle? valueStyle;

  /// The style to use for the text being edited.
  final double outlineBorderRadius;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Whether the [InputDecorator.child] is part of a dense form (i.e., uses less vertical
  /// space).
  final bool isDense;

  /// Text Field Style
  final OtpFieldStyle? otpFieldStyle;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String>? onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  final List<TextInputFormatter>? inputFormatter;

  final String? obscuringCharacter;

  const OTPTextField({
    Key? key,
    this.length = 4,
    this.width = 10,
    this.controller,
    this.fieldWidth = 30,
    this.spaceBetween = 0,
    this.otpFieldStyle,
    this.hasError = false,
    this.keyboardType = TextInputType.number,
    this.style = const TextStyle(),
    this.valueStyle,
    this.outlineBorderRadius: 10,
    this.textCapitalization = TextCapitalization.none,
    this.textFieldAlignment = MainAxisAlignment.spaceBetween,
    this.obscureText = false,
    this.fieldStyle = FieldStyle.underline,
    this.onChanged,
    this.inputFormatter,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.isDense = false,
    this.onCompleted,
    this.obscuringCharacter,
  })  : assert(length > 1),
        super(key: key);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late OtpFieldStyle _otpFieldStyle;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  late List<String> _pin;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.setOtpTextFieldState(this);
    }

    if (widget.otpFieldStyle == null) {
      _otpFieldStyle = OtpFieldStyle();
    } else {
      _otpFieldStyle = widget.otpFieldStyle!;
    }

    _focusNodes = List<FocusNode?>.filled(widget.length, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.length, null, growable: false);

    _pin = List.generate(widget.length, (int i) {
      return '';
    });
  }

  void clear() {
    setState(() {
      final textFieldLength = widget.length;
      _pin = List.generate(textFieldLength, (int i) {
        return '';
      });

      final textControllers = _textControllers;
      textControllers.forEach((textController) {
        if (textController != null) {
          textController.text = '';
        }
      });

      final firstFocusNode = _focusNodes[0];
      if (firstFocusNode != null) {
        firstFocusNode.requestFocus();
      }
    });
  }

  void setValue(String value, int position) {
    setState(() {
      final maxIndex = widget.length - 1;
      if (position > maxIndex) {
        throw Exception("Provided position is out of bounds for the OtpTextField");
      }

      final textControllers = _textControllers;
      final textController = textControllers[position];
      final currentPin = _pin;

      if (textController != null) {
        textController.text = value;
        currentPin[position] = value;
      }

      String newPin = "";
      currentPin.forEach((item) {
        newPin += item;
      });

      if (widget.onChanged != null) {
        widget.onChanged!(newPin);
      }
    });
  }

  void setFocus(int position) {
    setState(() {
      final maxIndex = widget.length - 1;
      if (position > maxIndex) {
        throw Exception("Provided position is out of bounds for the OtpTextField");
      }

      final focusNodes = _focusNodes;
      final focusNode = focusNodes[position];

      if (focusNode != null) {
        focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((controller) => controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return buildTextField(context, index);
        }),
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? textEditingController = _textControllers[index];

    // if focus node doesn't exist, create it.
    if (focusNode == null) {
      _focusNodes[index] = FocusNode();
      focusNode = _focusNodes[index];
      focusNode?.addListener((() => handleFocusChange(index)));
    }
    if (textEditingController == null) {
      _textControllers[index] = TextEditingController();
      textEditingController = _textControllers[index];
    }

    final isLast = index == widget.length - 1;

    InputBorder _getBorder(Color color) {
      final colorOrError = widget.hasError ? _otpFieldStyle.errorBorderColor : color;

      return widget.fieldStyle == FieldStyle.box
          ? OutlineInputBorder(
              borderSide: BorderSide(color: colorOrError),
              borderRadius: BorderRadius.circular(widget.outlineBorderRadius),
            )
          : UnderlineInputBorder(borderSide: BorderSide(color: colorOrError));
    }

    bool hasValue = textEditingController!.text != "";
    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(
        right: isLast ? 0 : widget.spaceBetween,
      ),
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(skipTraversal: true),
        onKey: (event) {
          if (event.data.logicalKey.keyId == 4295426090) {
            debugPrint("backsapce handler");
          }
        },
        child: TextField(
          controller: _textControllers[index],
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textAlign: TextAlign.center,
          style: hasValue ? widget.valueStyle ?? widget.style : widget.style,
          inputFormatters: widget.inputFormatter,
          maxLength: 1,
          focusNode: _focusNodes[index],
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter ?? '•',
          decoration: InputDecoration(
            isDense: widget.isDense,
            filled: true,
            fillColor: focusNode!.hasFocus ? _otpFieldStyle.focusBackgroundColor : (hasValue ? _otpFieldStyle.valueBackgroundColor : _otpFieldStyle.backgroundColor),
            counterText: "",
            contentPadding: widget.contentPadding,
            border: _getBorder(hasValue ? _otpFieldStyle.valueBorderColor : _otpFieldStyle.borderColor),
            focusedBorder: _getBorder(_otpFieldStyle.focusBorderColor),
            enabledBorder: _getBorder(_otpFieldStyle.enabledBorderColor),
            disabledBorder: _getBorder(_otpFieldStyle.disabledBorderColor),
            errorBorder: _getBorder(_otpFieldStyle.errorBorderColor),
            focusedErrorBorder: _getBorder(_otpFieldStyle.errorBorderColor),
            errorText: null,
            // to hide the error text
            errorStyle: const TextStyle(height: 0, fontSize: 0),
          ),
          onChanged: (String str) {
            if (str.length > 1) {
              _handlePaste(str);
              return;
            }

            // Check if the current value at this position is empty
            // If it is move focus to previous text field.
            if (str.isEmpty) {
              if (index == 0) return;
              _focusNodes[index]!.unfocus();
              _focusNodes[index - 1]!.requestFocus();
            }

            // Update the current pin
            setState(() {
              _pin[index] = str;
            });

            // Remove focus
            if (str.isNotEmpty) _focusNodes[index]!.unfocus();
            // Set focus to the next field if available
            if (index + 1 != widget.length && str.isNotEmpty) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }

            String currentPin = _getCurrentPin();

            // if there are no null values that means otp is completed
            // Call the `onCompleted` callback function provided
            if (!_pin.contains(null) && !_pin.contains('') && currentPin.length == widget.length) {
              widget.onCompleted?.call(currentPin);
            }

            // Call the `onChanged` callback function
            widget.onChanged!(currentPin);
          },
        ),
      ),
    );
  }

  void handleFocusChange(int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? controller = _textControllers[index];

    if (focusNode == null || controller == null) return;

    if (focusNode.hasFocus) {
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    }
  }

  String _getCurrentPin() {
    String currentPin = "";
    _pin.forEach((String value) {
      currentPin += value;
    });
    return currentPin;
  }

  void _handlePaste(String str) {
    if (str.length > widget.length) {
      str = str.substring(0, widget.length);
    }

    for (int i = 0; i < str.length; i++) {
      String digit = str.substring(i, i + 1);
      _textControllers[i]!.text = digit;
      _pin[i] = digit;
    }

    FocusScope.of(context).requestFocus(_focusNodes[widget.length - 1]);

    String currentPin = _getCurrentPin();

    // if there are no null values that means otp is completed
    // Call the `onCompleted` callback function provided
    if (!_pin.contains(null) && !_pin.contains('') && currentPin.length == widget.length) {
      widget.onCompleted?.call(currentPin);
    }

    // Call the `onChanged` callback function
    widget.onChanged!(currentPin);
  }
}

class OtpFieldController {
  late _OTPTextFieldState _otpTextFieldState;

  void setOtpTextFieldState(_OTPTextFieldState state) {
    _otpTextFieldState = state;
  }

  void clear() {
    _otpTextFieldState.clear();
  }

  void setValue(String value, int position) {
    _otpTextFieldState.setValue(value, position);
  }

  void setFocus(int position) {
    _otpTextFieldState.setFocus(position);
  }
}
