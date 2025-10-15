import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<NewsController>(() => NewsController());
  }
  
}