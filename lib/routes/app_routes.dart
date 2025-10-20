// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';


abstract class Routes {
  Routes._();

  static const SPLASH = _paths.SPLASH;
  static const HOME = _paths.HOME;
  static const NEWS_DETAIL = _paths.NEWS_DETAIL;
}

abstract class _paths {
  _paths._();
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const NEWS_DETAIL = '/news_detail';
}