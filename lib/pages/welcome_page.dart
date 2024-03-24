import 'dart:async';
import 'package:apitask/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/route_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  String selectedValue = 'en';
  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    print(_currentLocale);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleData.title.getString(context),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: DropdownButton(
                padding: const EdgeInsets.only(right: 10),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Colors.black,
                style: const TextStyle(
                  color: Colors.white,
                ),
                value: selectedValue,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English'),),
                  DropdownMenuItem(value: 'az', child: Text('Azərbaycan'),),
                  DropdownMenuItem(value: 'ru', child: Text('Русский'),),
                ],
                onChanged: (value){
                  _setLocale(value);
                  selectedValue = value!;
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/icon.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  LocaleData.body.getString(context),
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<RouteProvider>(context, listen: false)
                        .changeRoute(context, '/login');
                    final token = await _getToken();
                    if (token != null) {
                      final completer = Completer<void>();
                      completer.future.then((_) {
                        Provider.of<RouteProvider>(context, listen: false)
                            .changeRoute(context, '/home');
                      });
                      completer.complete();
                    } else {
                      final completer = Completer<void>();
                      completer.future.then((_) {
                        Provider.of<RouteProvider>(context, listen: false)
                            .changeRoute(context, '/login');
                      });
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LocaleData.login.getString(context),
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setLocale(String? value){
    if(value == null) return;
    if(value == 'en'){
      _flutterLocalization.translate('en');
    } else if(value == 'az'){
      _flutterLocalization.translate('az');
    } else if(value == 'ru'){
      _flutterLocalization.translate('ru');
    } else{
      return;
    }
    setState(() {
      _currentLocale = value;
    });
  }
}
