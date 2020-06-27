import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _authorized = false;

  Future<void> _autheniticate() async {
    try {
      setState(() {
        _isAuthenticating = true;
      });

      bool _authenticated = false;

      _authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Please authenticate to show account details',
          useErrorDialogs: true,
          stickyAuth: true);

      setState(() {
        _authorized = _authenticated;
        _isAuthenticating = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _authorized
                ? Column(
                    children: <Widget>[
                      Text('Balance: Rs.20000'),
                      Text('Account No: 12345678'),
                      Text('Account Holder: Huzaifa Ahmed')
                    ],
                  )
                : Text('Can\'t show details untill authorized'),
            RaisedButton(
              child: Text('Show Account Details'),
              onPressed: _autheniticate,
            )
          ],
        ),
      ),
    ));
  }
}
