import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Isloading_QR_Profile extends GetxController{
  RxBool isloading=false.obs;
  change_isloadingval(changeval)
  {
    this.isloading.value=changeval;
  }
}