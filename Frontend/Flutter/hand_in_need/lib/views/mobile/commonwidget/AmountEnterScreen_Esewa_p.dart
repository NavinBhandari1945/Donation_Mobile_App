import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';

import '../home/esewa_pay_function.dart';

class AmountEnterScreen_Esewa_p extends StatefulWidget {

  final String DonerUsername;
  final String ReceiverUsername;
  final int PostId;
  final String PaymentMethod;
  final String JwtToken;
  final String UserType;

  const AmountEnterScreen_Esewa_p(
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
  State<AmountEnterScreen_Esewa_p> createState() => _AmountEnterScreen_Esewa_pState();
}

class _AmountEnterScreen_Esewa_pState extends State<AmountEnterScreen_Esewa_p> {

  final DonateAmountController=TextEditingController();
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

                CommonTextField_obs_false_p("Enter the amount to donate.","000", false, DonateAmountController, context),
                Commonbutton("Next", ()
               {
                 if(
                 DonateAmountController.text.toString().isEmpty ||
                     DonateAmountController.text == null ||
                     int.tryParse(DonateAmountController.text.toString())! <= 0
                 )
                 {
                   Toastget().Toastmsg("Enter amount greater than 0 or provide appropriate amount.");
                   return;
                 }
                  int? DonateAmount = int.tryParse(DonateAmountController.text.toString());

                  Pay_functiion
                    (
                    jwttoken: widget.JwtToken,
                    context: context,
                    DonerUsername: widget.DonerUsername,
                    usertype: widget.UserType,
                    DonateAmount:DonateAmount.toString() ,
                    PaymentMethod:widget.PaymentMethod ,
                    PostId: widget.PostId.toString(),
                    ReceiverUsername:widget.ReceiverUsername ,
                  ).do_pay(
                      context: context,
                      doner_username:widget.DonerUsername ,
                      receiver_username:widget.ReceiverUsername,
                      donate_amount:DonateAmount!,
                      post_id: widget.PostId,
                      payment_method: widget.PaymentMethod,
                    JwtToken:widget.JwtToken ,
                    UserType:widget.UserType
                  );
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
