
import 'package:get/get.dart';

class Is_Navigating_getx extends GetxController
{
  RxBool Is_Navigating=false.obs;
  change_Is_Navigating(changeval)
  {
    this.Is_Navigating.value=changeval;
  }
}
