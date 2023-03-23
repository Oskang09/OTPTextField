import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Credit Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Awesome Credit Card Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // send otp api trigger
      otpController.setFocus(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cleaning_services),
        onPressed: () {
          print("Floating button was pressed.");
          otpController.clear();
          // otpController.set(['2', '3', '5', '5', '7']);
          // otpController.setValue('3', 0);
          // otpController.setFocus(1);
        },
      ),
      body: Center(
        child: OTPTextField(
          length: 6,
          controller: otpController,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldWidth: 45,
          obscureText: true,
          obscuringCharacter: '*',
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly
          ],
          outlineBorderRadius: 12,
          otpFieldStyle: OtpFieldStyle(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            valueBackgroundColor: const Color.fromRGBO(53, 227, 219, 1),
            enabledBorderColor: const Color.fromRGBO(250, 250, 250, 1),
            focusBorderColor: const Color.fromRGBO(53, 227, 219, 1),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.all(8),
          fieldStyle: FieldStyle.box,
          onChanged: (value) {},
          onCompleted: null,
        ),
      ),
    );
  }
}
