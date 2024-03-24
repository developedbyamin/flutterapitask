import 'dart:async';

import 'package:apitask/localization/locales.dart';
import 'package:apitask/services/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  String? _token;

  Future<void> _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final dio = Dio();

    try {
      await _storeCredentials(username, password);
      final response = await dio.post(
        'https://fakestoreapi.com/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data.containsKey('token')) {
          final token = data['token'];
          await _storeToken(token);
          setState(() {
            _errorMessage = null;
            _token = token;
            Provider.of<RouteProvider>(context, listen: false)
                .changeRoute(context,'/home');
          });
        } else {
          setState(() {
            _errorMessage = 'Login successful, but no token received.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password.';
        });
      }
    } on DioException catch (e) {
      print('Login error: ${e.message}');
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  Future<void> _storeCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  // Future<void> _clearCredentials() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('username');
  //   await prefs.remove('password');
  // }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _getToken();
    if (token != null) {
      setState(() {
        _token = token;
        final completer = Completer<void>();
        completer.future.then((_) {
          Provider.of<RouteProvider>(context, listen: false).changeRoute(context,'/home');
        });
        completer.complete();
      });
      // Use a Completer to bridge the async gap

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Provider.of<RouteProvider>(context, listen: false)
                .changeRoute(context,'/');
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(LocaleData.login.getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_token == null) ...[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: LocaleData.username.getString(context),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: LocaleData.password.getString(context),
                ),
                obscureText: true,
              ),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text(LocaleData.login.getString(context)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
