import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Is_Friend_Or_Not_getx_cont extends GetxController
{
  RxBool Is_Friend_Or_Not=false.obs;
  change_Is_Friend_Or_Not(changeval)
  {
    this.Is_Friend_Or_Not.value=changeval;
  }
}