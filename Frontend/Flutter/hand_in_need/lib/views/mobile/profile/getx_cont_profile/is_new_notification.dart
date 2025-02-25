import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Is_New_Notification extends GetxController{
  RxBool Is_New_Notification_Value=false.obs;
  Change_Is_New_Notification(changeval)
  {
    this.Is_New_Notification_Value.value=changeval;
  }
}