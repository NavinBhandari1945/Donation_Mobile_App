import 'package:get/get.dart';
class Home_2_BNBI_getx extends  GetxController{
  RxInt currentIndexVal=0.obs;
  changeindexval(indexval){
    this.currentIndexVal.value=indexval;
  }
}