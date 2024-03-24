import 'package:apitask/localization/locales.dart';
import 'package:apitask/services/product_category.dart';
import 'package:apitask/services/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.home.getString(context)),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () {
            Provider.of<RouteProvider>(context, listen: false)
                .changeRoute(context,'/welcome');
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: (){
                Provider.of<RouteProvider>(context, listen: false).changeRoute(context,'/profile');
              },
              icon: Image.asset('assets/user.png',width: 32, height: 32,),
            ),
          ),
        ],
      ),
      body: const ProductCategory(),
    );
  }
}
