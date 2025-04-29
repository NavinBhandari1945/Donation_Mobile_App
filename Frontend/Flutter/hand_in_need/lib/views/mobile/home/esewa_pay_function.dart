import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:esewa_flutter_sdk/payment_failure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import '../../constant/esewa.dart';
import '../commonwidget/CommonMethod.dart';
import 'bill_generation_SP_SSDI_P.dart';
import 'bill_generation_SP_FSDID_P.dart';
import 'index_home.dart';

class Pay_functiion{
  final String DonerUsername;
  final String usertype;
  final String jwttoken;
  final BuildContext context;
  final String DonateAmount;
  final String PaymentMethod;
  final String PostId;
  final String ReceiverUsername;

  const Pay_functiion({required this.DonerUsername,required this.usertype,
    required this.jwttoken,required this.context,required this.DonateAmount,
    required this.PaymentMethod,required this.PostId,required this.ReceiverUsername
  });

  do_pay(
      {
        required context,
        required String doner_username,
        required String receiver_username,
        required int donate_amount,
        required int post_id,
        required String payment_method,
        required String JwtToken,
        required String UserType
      })async{
    try{
      await checkJWTExpiation(context: context, username: DonerUsername, usertype: usertype, jwttoken: jwttoken);
      print("Esewa payment proceed after jwt check.Jwt verified ");
      EsewaFlutterSdk.initPayment(

          esewaConfig:EsewaConfig(
              clientId: EsewaClientId,
              secretId: EsewaSecretKey,
              environment:Environment.test),

          // 9806800001
          esewaPayment:EsewaPayment(
              productId:post_id.toString(),
              productName: receiver_username,
              productPrice: donate_amount.toString(),
              callbackUrl: "",
          ),
          onPaymentSuccess:(EsewaPaymentSuccessResult success_result)
          async {
            // verifyTransactionStatus(success_result);
            int result= await Donate(
                JwtToken:JwtToken,
              donate_amount:donate_amount,
              Donate_date:DateTime.now().toUtc().toString(),
              doner_username:doner_username,
              payment_method: payment_method,
              post_id: post_id,
              receiver_username: receiver_username
            );
            print("");
            print("Http method call result to save data in dontation table in adatabase");
            print(result);
            print("");
            if(result == 1)
              {
                print("esewa payment succes result start");
                print("value");
                print(success_result);
                print("stop");
                Toastget().Toastmsg("Payment success by esewa.\n"+"Thank you");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return
                        Bill_generation(
                          donate_date:DateTime.now().toUtc().toString(),
                          donate_amount: donate_amount,
                          doner_username: doner_username,
                          payment_method: payment_method,
                          post_id: post_id,
                          receiver_username: receiver_username,
                          JwtToken: JwtToken,
                          UserType: UserType,
                        );
                  },
                  )
                  );
              }
            else
              {
               int result=await RetryFailDataSaveInDatabse(
                   jwttoken: jwttoken,
                   DonateAmount: DonateAmount,
                   DonerUsername: DonerUsername,
                   PaymentMethod: PaymentMethod,
                   PostId: PostId,
                   ReceiverUsername: ReceiverUsername);
               if (result==1)
               {
                 Toastget().Toastmsg(
                     "Payment success by esewa.\n"+"Thank you");
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                   return
                     Bill_generation(
                       donate_date:DateTime.now().toUtc().toString(),
                       donate_amount: donate_amount,
                       doner_username: doner_username,
                       payment_method: payment_method,
                       post_id: post_id,
                       receiver_username: receiver_username,
                       JwtToken: JwtToken,
                       UserType: UserType,
                     );
                 },
                 )
                 );
               }
               else
                 {
                    print("Retry to save fail payment data in database again.");
                    Toastget().Toastmsg(
                        "Payment success by esewa.\n"+"Thank you");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return
                        Bill_generation_SP_FD_P(
                          donate_date:DateTime.now().toUtc().toString(),
                          donate_amount: donate_amount,
                          doner_username: doner_username,
                          payment_method: payment_method,
                          post_id: post_id,
                          receiver_username: receiver_username,
                          JwtToken: JwtToken,
                          UserType: UserType,
                        );
                    },
                    )
                    );
                 }

              }


          },

          onPaymentFailure:(data,EsewaPaymentFailure fail_result)
          {
            print("payment failure start");
            print("data value");
            print(data);
            print("faul_result value");
            print(fail_result);
            print("stop");

            Toastget().Toastmsg("Payment Failed.\n"+"${fail_result}");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return  Index_Home_Screen(username:DonerUsername,jwttoken:JwtToken,usertype:UserType);
            },
            )
            );

          },

          onPaymentCancellation:(data){

            print("payment cancel start");
            print("data value");
            print(data);
            print("stop");
            Toastget().Toastmsg("Payment cancel");
            Navigator.pushReplacement (context, MaterialPageRoute(builder: (context) {
              return   Index_Home_Screen(username:DonerUsername,jwttoken:JwtToken,usertype:UserType);
            },
            )
            );
          }
          );
      }catch(o)
    {
      print("Exception caught in do pay function");
      print(o.toString());
      Toastget().Toastmsg('Donation failed.');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return  Index_Home_Screen(username:DonerUsername,jwttoken:JwtToken,usertype:UserType);
      },
      )
      );
      }
  }

}