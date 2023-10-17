import 'package:get/get.dart';
import 'package:qurban_app/helpers/usercontroller.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
    // Add other controllers here if needed
  }
}
