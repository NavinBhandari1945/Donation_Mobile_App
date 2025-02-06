import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'AmountEnterScreen_Esewa_p.dart';


import 'AmountEnterScreen_Paypal_p.dart';

class DonateOption
{
  void donate({required BuildContext context,required String donerUsername,required String receiver_useranme,required int postId,required String jwttoken,required String userType})
  {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Choose Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.account_balance_wallet, color: Colors.green),
              title: Text("Esewa"),
              onTap: ()
              {
                Get.back();
                Navigator.push(context,MaterialPageRoute(builder: (context)
                {
                  return AmountEnterScreen_Esewa_p(
                    DonerUsername:donerUsername.toString(),
                    PaymentMethod: "Esewa",
                    PostId: postId,
                    ReceiverUsername: receiver_useranme.toString(),
                    JwtToken:jwttoken.toString() ,
                    UserType:userType.toString() ,
                  );
                },
                )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.blue),
              title: Text("PayPal"),
              onTap: ()
              {
                Get.back();
                Navigator.push(context,MaterialPageRoute(builder: (context)
                {
                  return AmountEnterScreen_Paypal_p(
                    DonerUsername:donerUsername.toString(),
                    PaymentMethod: "Paypal",
                    PostId: postId,
                    ReceiverUsername: receiver_useranme.toString(),
                    JwtToken:jwttoken.toString() ,
                    UserType:userType.toString() ,
                  );
                },
                )
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}