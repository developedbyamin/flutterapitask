

import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('en', LocaleData.en),
  MapLocale('az', LocaleData.az),
  MapLocale('ru', LocaleData.ru),
];


mixin LocaleData{
  static const String title = 'title';
  static const String body = 'body';
  static const String login = 'login';
  static const String username = 'username';
  static const String password = 'password';
  static const String home = 'home';
  static const String allProducts = 'all products';
  static const String electronics = 'electronics';
  static const String jewelery = 'jewelery';
  static const String menCloth = "men's clothing";
  static const String womenCloth = "women's clothing";
  static const String bio = "bio";
  static const String profile = 'profile';
  static const String deleteAccount = 'Delete Account';
  static const String enterUser = 'enter username';
  static const String enterPassword = 'enter password';
  static const String enterBio = 'enter bio';


  static const Map<String, dynamic> en = {
    title: 'Welcome',
    body: 'Flutter Task',
    login: 'Login',
    username: 'username',
    password: 'password',
    home: 'Home',
    allProducts: 'all products',
    electronics: 'electronics',
    jewelery: 'jewelery',
    menCloth: "men's clothing",
    womenCloth: "women's clothing",
    bio: 'bio',
    profile: 'Profile',
    deleteAccount: 'Delete Account',
    enterUser: 'enter username',
    enterPassword: 'enter password',
    enterBio: 'enter bio',
  };

  static const Map<String, dynamic> az = {
    title: 'Xoş gəlmişsiniz',
    body: 'Flutter tapşırığı',
    login: 'Giriş',
    username: 'istifadəçi adı',
    password: 'parol',
    home: 'Əsas menyu',
    allProducts: 'bütün məhsullar',
    electronics: 'elektronika',
    jewelery: 'zərgərlik',
    menCloth: "kişi geyimləri",
    womenCloth: "qadın geyimləri",
    bio: 'bio',
    profile: 'Profil',
    deleteAccount: 'Hesabı Sil',
    enterUser: 'istifadəçi adını daxil edin',
    enterPassword: 'parol daxil edin',
    enterBio: 'bio daxil edin',
  };

  static const Map<String, dynamic> ru = {
    title: 'Добро пожаловать',
    body: 'Задача флаттера',
    login: 'логин',
    username: 'имя пользователя',
    password: 'пароль',
    home: 'Главное меню',
    allProducts: 'все продукты',
    electronics: 'электроника',
    jewelery: 'Ювелирные изделия',
    menCloth: "мужская одежда",
    womenCloth: "Женская одежда",
    bio: 'био',
    profile: 'Профиль',
    deleteAccount: 'Удалить аккаунт',
    enterUser: 'введите имя пользователя',
    enterPassword: 'введите пароль',
    enterBio: 'биографию',
  };

}