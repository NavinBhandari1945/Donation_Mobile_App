import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import '../home/bill_generation_SDP_P.dart';
import '../home/bill_generation_SP_FD_P.dart';
import '../home/home_p.dart';
import '../home/index_login_home.dart';
import '../home/login_home_p.dart';
import 'CommonMethod.dart';

class AmountEnterScreen_Paypal_p extends StatefulWidget {

  final String DonerUsername;
  final String ReceiverUsername;
  final int PostId;
  final String PaymentMethod;
  final String JwtToken;
  final String UserType;

  const AmountEnterScreen_Paypal_p(
      {
        super.key,
        required this.DonerUsername,
        required this.PaymentMethod,
        required this.PostId,
        required this.ReceiverUsername,
        required this.JwtToken,
        required this.UserType
      }
      );

  @override
  State<AmountEnterScreen_Paypal_p> createState() => _AmountEnterScreen_Paypal_pState();
}

class _AmountEnterScreen_Paypal_pState extends State<AmountEnterScreen_Paypal_p> {

  final DonateAmountControllerPaypal_p=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Amount enter screen."),
        backgroundColor: Colors.green,
      ),
      body:Container(
        height: heightval,
        width: widthval,
        color: Colors.grey,
        child: Center(
          child: Container(
            width: widthval,
            height: heightval*0.25,
            color: Colors.blueGrey,
            child: Column(
              children:
              [

                CommonTextField_obs_false_p("Enter the amount to donate.","000", false, DonateAmountControllerPaypal_p, context),
                Commonbutton("Next", ()
                {
                 try {
                   if (
                   DonateAmountControllerPaypal_p.text
                       .toString()
                       .isEmpty ||
                       DonateAmountControllerPaypal_p.text == null ||
                       int.tryParse(DonateAmountControllerPaypal_p.text.toString())! <=
                           0
                   ) {
                     Toastget().Toastmsg(
                         "Enter amount greater than 0 or provide appropriate amount.");
                     return;
                   }

                   final String donateAmount = DonateAmountControllerPaypal_p.text.toString();

                   print("paypal start");
                   Navigator.pushReplacement(
                       context, MaterialPageRoute(builder: (context) {
                     return

                       PaypalCheckoutView(
                         sandboxMode: true,
                         clientId: "AdOe46gI0DoYRpqUT_rD_bV_0vmocOBvRbxBKg2-8EbCZhD5NJuqv18BEoPqeY2h6EyBpjCpzt7RK6ST",
                         secretKey: "EHwXT5_Vm2a3_puPeZ2jb8jmn7ooa0s-ADShYLzpqnnyD5pjoX1cSw_pO-5x6Psv-pdmIITr-nNr901q",
                         transactions: [
                           {
                             "amount": {
                               "total": donateAmount, // Dynamically set the donation amount
                               "currency": "USD",
                               "details": {
                                 "subtotal": donateAmount, // Ensure subtotal matches total
                                 "shipping": "0",
                                 "shipping_discount": "0"
                               }
                             },
                             "description": "Donation Payment",
                           }
                         ],
                         note: "Contact us for any questions on your order.",
                         onSuccess: (Map params) async
                         {

                           // Toastget().Toastmsg("Donation success by papypal.Thank you.");
                           // print("onSuccess: $params");

                           int result= await Donate(
                               JwtToken:widget.JwtToken,
                               donate_amount:int.parse(DonateAmountControllerPaypal_p.text.toString()),
                               Donate_date:DateTime.now().toUtc().toString(),
                               doner_username:widget.DonerUsername,
                               payment_method:widget.PaymentMethod,
                               post_id: widget.PostId,
                               receiver_username:widget.ReceiverUsername
                           );
                           print("");
                           print("Http method call result to save data in dontation table in adatabase");
                           print(result);
                           print("");
                           if(result == 1)
                           {
                             Toastget().Toastmsg("Payment success by paypal.\n"+"Thank you");
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                               return
                                 Bill_generation(
                                   donate_date:DateTime.now().toUtc().toString(),
                                   donate_amount:int.parse(DonateAmountControllerPaypal_p.text.toString()),
                                   doner_username: widget.DonerUsername,
                                   payment_method: widget.PaymentMethod,
                                   post_id:widget.PostId,
                                   receiver_username: widget.ReceiverUsername,
                                   JwtToken:widget.JwtToken,
                                   UserType: widget.UserType,
                                 );
                             },
                             )
                             );
                           }
                           else
                           {
                             int result=await RetryFailDataSaveInDatabse(
                                 jwttoken: widget.JwtToken,
                                 DonateAmount:DonateAmountControllerPaypal_p.text.toString(),
                                 DonerUsername: widget.DonerUsername,
                                 PaymentMethod: widget.ReceiverUsername,
                                 PostId: widget.PostId.toString(),
                                 ReceiverUsername: widget.ReceiverUsername
                             );
                             if (result==1)
                             {
                               Toastget().Toastmsg(
                                   "Payment success by paypal.\n"+"Thank you");
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                 return
                                   Bill_generation(
                                     donate_date:DateTime.now().toUtc().toString(),
                                     donate_amount:int.parse(DonateAmountControllerPaypal_p.text.toString()),
                                     doner_username: widget.DonerUsername,
                                     payment_method: widget.PaymentMethod,
                                     post_id:widget.PostId,
                                     receiver_username: widget.ReceiverUsername,
                                     JwtToken:widget.JwtToken,
                                     UserType: widget.UserType,
                                   );
                               },
                               )
                               );
                             }
                             else
                             {
                               print("Retry to save fail payment data in database again.");
                               Toastget().Toastmsg(
                                   "Payment success by paypal.\n"+"Thank you");
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                 return
                                   Bill_generation_SP_FD_P(
                                     donate_date:DateTime.now().toUtc().toString(),
                                     donate_amount:int.parse(DonateAmountControllerPaypal_p.text.toString()),
                                     doner_username: widget.DonerUsername,
                                     payment_method: widget.PaymentMethod,
                                     post_id:widget.PostId,
                                     receiver_username: widget.ReceiverUsername,
                                     JwtToken:widget.JwtToken,
                                     UserType: widget.UserType,
                                   );
                               },
                               )
                               );
                             }
                           }
                         },
                         onError: (error)
                         {
                           Toastget().Toastmsg("Donation by papypal encounter error.Try again.Thank you.");
                           print("onError: $error");
                           Navigator.pushReplacement (context, MaterialPageRoute(builder: (context) {
                             return  HomeScreen_2(username:widget.DonerUsername,jwttoken:widget.JwtToken,usertype:widget.UserType);
                           },
                           )
                           );
                         },
                         onCancel: () {
                           Toastget().Toastmsg("Donation by papypal cancel.Thank you.");
                           print('cancelled:');
                           Navigator.pushReplacement (context, MaterialPageRoute(builder: (context) {
                             return   HomeScreen_2(username:widget.DonerUsername,jwttoken:widget.JwtToken,usertype:widget.UserType);
                           },
                           )
                           );
                         },
                       );

                   },
                   )
                   );

                   print("paypal end");
                 }catch(Obj)
                  {
                    print("Exception caught while donating through paypal.");
                    print(Obj.toString());
                    Toastget().Toastmsg("Donation failed.");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                    {
                      return  HomeScreen_2(username:widget.DonerUsername,jwttoken:widget.JwtToken,usertype:widget.UserType);
                    },
                    )
                    );
                  }

                },
                   context, Colors.red
               ),

              ],
            ),
          ),
        ),

      )
    );
  }
}
