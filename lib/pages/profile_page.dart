import 'dart:async';

import 'package:apitask/localization/locales.dart';
import 'package:apitask/services/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  bool _isObscure = true;

  Future<String?> _getInfo(String info) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(info);
  }

  Future<void> _loadUserInfo() async {
    final usernameFuture = _getInfo('username');
    final passwordFuture = _getInfo('password');
    final bioFuture = _getInfo('bio');
    final username = await usernameFuture;
    final password = await passwordFuture;
    final bio = await bioFuture;
    _nameController.text = username ?? '';
    _emailController.text = password ?? '';
    _bioController.text = bio ?? '';
  }

  Future<void> _storeCredentials(
      String username, String password, String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('bio', bio);
    final completer = Completer<void>();
    completer.future.then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Information saved successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    });
    completer.complete();
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('bio');
    prefs.remove('token');
    final completer = Completer<void>();
    completer.future.then((_) {
      Provider.of<RouteProvider>(context, listen: false)
          .changeRoute(context, '/welcome');
    });
    completer.complete();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Provider.of<RouteProvider>(context, listen: false)
                .changeRoute(context, '/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(LocaleData.profile.getString(context)),
        actions: [
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                _storeCredentials(_nameController.text, _emailController.text,
                    _bioController.text);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleData.username.getString(context)),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your username',
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(LocaleData.password.getString(context)),
                Stack(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                      ),
                      obscureText: _isObscure,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(LocaleData.bio.getString(context)),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your bio',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                // Show alert dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text(
                          'Are you sure you want to delete your account?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            _deleteAccount();
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            // User pressed Cancel
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                ).then((confirmed) {
                  // Handle the user's choice
                  if (confirmed == true) {
                    // User pressed Yes, delete account logic here
                  } else {
                    // User pressed Cancel
                  }
                });
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Text(LocaleData.deleteAccount.getString(context)),
            ),
          ],
        ),
      ),
    );
  }
}
