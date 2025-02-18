import 'package:get/get.dart';

class Initialize_video_post extends GetxController
{
  RxBool initialize_value=false.obs;
  changeValue(value)
  {
    if(this.initialize_value.value==false)
      {
        this.initialize_value.value=true;
      }

    if(this.initialize_value.value==true)
    {
      this.initialize_value.value=false;
    }
  }
}