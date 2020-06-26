import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  bool _authorized = false;
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to show account details',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated;
    });
  }

  void _cancelAuthentication() {
    // auth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    print('AUTH $_authorized');
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            _authorized == true
                ? Column(
                    children: <Widget>[
                      Text('Balance: Rs.20000'),
                      Text('Account No: 12345678'),
                      Text('Account Holder: Huzaifa Ahmed')
                    ],
                  )
                : Text('Can\'t shoe details untill authorized'),
            _isAuthenticating
                ? CircularProgressIndicator()
                : RaisedButton(
                    child: Text('Show Account Details'),
                    onPressed: _authenticate,
                  )
          ])),
    ));
  }
}
