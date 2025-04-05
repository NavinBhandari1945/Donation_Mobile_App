import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Qr_scanned_post_actions_screen extends GetxController{
  RxString scanned_data="No data scanned".obs;
  change_scanned_data(changeval){
    this.scanned_data.value=changeval;
  }
}