// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../main.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';

class Attesattion extends StatelessWidget {
  final String title = 'Firebase App Check';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App Check',
      home: FirebaseAppCheckExample(title: title),
    );
  }
}

class FirebaseAppCheckExample extends StatefulWidget {
  const FirebaseAppCheckExample({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _FirebaseAppCheck createState() => _FirebaseAppCheck();
}

class _FirebaseAppCheck extends State<FirebaseAppCheckExample> {
  final appCheck = FirebaseAppCheck.instance;
  String _message = '';
  String _eventToken = 'not yet';

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    );
  }

  @override
  void initState() {
    //init();
    appCheck.onTokenChange.listen(setEventToken);
    super.initState();
  }

  void setEventToken(String? token) async{
    setState(() {
      _eventToken = token ?? 'not yet';
      print("TOKEN ${_eventToken}");
    });
  }
  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App check"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child:  Column(
            children: [

              ElevatedButton(
                onPressed: () async {
                  if (kIsWeb) {
                    print(
                      'Pass in your "webRecaptchaSiteKey" key found on you Firebase Console to activate if using on the web platform.',
                    );
                  }
                  await appCheck.activate(
                    webRecaptchaSiteKey: kWebRecaptchaSiteKey,
                  );
                  setMessage('activated!!');
                },
                child: const Text('activate()'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Token will be passed to `onTokenChange()` event handler

                  //var token = await appCheck.getToken(true);//.then((value) => sp.setStringToSF(enumKey.ATTESTATION_KEY.name, value!));
                  await appCheck.getToken(true);
                },
                child: const Text('getToken()'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await appCheck.setTokenAutoRefreshEnabled(true);
                  setMessage('successfully set auto token refresh!!');
                },
                child: const Text('setTokenAutoRefreshEnabled()'),
              ),
              const SizedBox(height: 20),
              Text(
                _message, //#007bff
                style: const TextStyle(
                  color: Color.fromRGBO(47, 79, 79, 1),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Token received from tokenChanges() API: $_eventToken', //#007bff
                style: const TextStyle(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}