import 'package:get/get.dart';

class CheckBox_A_T_C extends GetxController
{
  RxBool termns_cond=false.obs;
  ValueChange(change_value){
    this.termns_cond.value=change_value;
  }
}