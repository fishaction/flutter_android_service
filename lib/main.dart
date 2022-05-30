import 'dart:convert';
import 'dart:ffi';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';


Future<void> main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  String _resultStr = "";
  String _serviceStatus = "";

  static const MethodChannel _channel = MethodChannel('com.example.methodchannel/interop');
  static const String startService = "startService";

  String text = "";

  Future<void> _startService() async{
    await _channel.invokeMethod(startService);
  }

  static Future<Null> _onServiceStart() async{
    await _channel.invokeMethod('_onServiceStart');
  }

  static Future<Null> _onTick() async{
    await _channel.invokeMethod('onTick');
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async{
    switch(call.method){
      case 'onStart':
        setState((){
          _serviceStatus = call.method;
        });
        return Future.value('ok');
      case 'onTick':
        setState((){
          _counter ++;
        });
        return Future.value('ok');
      default:
        print('unknown method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  @override
  initState(){
    super.initState();
    _channel.setMethodCallHandler(_platformCallHandler);

    _onServiceStart();
    _onTick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Response:$_serviceStatus',
            ),
            Text(
              'Timer:$_counter',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startService,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
