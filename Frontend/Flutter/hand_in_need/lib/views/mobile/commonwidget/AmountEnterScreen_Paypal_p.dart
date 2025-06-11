import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import '../home/bill_generation_SP_SSDI_P.dart';
import '../home/bill_generation_SP_FSDID_P.dart';
import '../home/authentication_home_p.dart';
import '../home/index_home.dart';
import '../home/login_home_p.dart';
import 'CommonMethod.dart';

class AmountEnterScreen_Paypal_p extends StatefulWidget {
  final String DonerUsername;
  final String ReceiverUsername;
  final int PostId;
  final String PaymentMethod;
  final String JwtToken;
  final String UserType;

  const AmountEnterScreen_Paypal_p({
    super.key,
    required this.DonerUsername,
    required this.PaymentMethod,
    required this.PostId,
    required this.ReceiverUsername,
    required this.JwtToken,
    required this.UserType,
  });

  @override
  State<AmountEnterScreen_Paypal_p> createState() => _AmountEnterScreen_Paypal_pState();
}

class _AmountEnterScreen_Paypal_pState extends State<AmountEnterScreen_Paypal_p> with SingleTickerProviderStateMixin {
  final DonateAmountControllerPaypal_p = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    DonateAmountControllerPaypal_p.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter Donation Amount",
          style: TextStyle(fontFamily: 'bold', fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(shortestval * 0.04),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(shortestval * 0.05),
                      child: orientation == Orientation.portrait
                          ? _buildPortraitLayout(shortestval, widthval, heightval)
                          : _buildLandscapeLayout(shortestval, widthval, heightval),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Donate via PayPal",
          style: TextStyle(
            fontFamily: 'bold',
            fontSize: shortestval * 0.07,
            color: Colors.green[700],
          ),
        ),
        SizedBox(height: shortestval * 0.04),
        CommonTextField_obs_false_p(
          "Enter the amount to donate",
          "000",
          false,
          DonateAmountControllerPaypal_p,
          context,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.money, color: Colors.green[700]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.grey[500], fontFamily: 'regular'),
          ),
        ),
        SizedBox(height: shortestval * 0.06),
        Center(
          child: ElevatedButton(
            onPressed: _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: shortestval * 0.1, vertical: shortestval * 0.04),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                fontFamily: 'bold',
                color: Colors.white,
                fontSize: shortestval * 0.045,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Donate via PayPal",
                style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: shortestval * 0.07,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: shortestval * 0.04),
              CommonTextField_obs_false_p(
                "Enter the amount to donate",
                "000",
                false,
                DonateAmountControllerPaypal_p,
                context,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.money, color: Colors.green[700]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.grey[500], fontFamily: 'regular'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: shortestval * 0.06),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: shortestval * 0.1, vertical: shortestval * 0.04),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                fontFamily: 'bold',
                color: Colors.white,
                fontSize: shortestval * 0.045,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    try {
      if (DonateAmountControllerPaypal_p.text.toString().isEmpty ||
          DonateAmountControllerPaypal_p.text == null ||
          int.tryParse(DonateAmountControllerPaypal_p.text.toString())! <= 0) {
        Toastget().Toastmsg("Enter amount greater than 0 or provide appropriate amount.");
        return;
      }

      final String donateAmount = DonateAmountControllerPaypal_p.text.toString();

      print("paypal start");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return PaypalCheckoutView(
            sandboxMode: true,
            clientId: "AdOe46gI0DoYRpqUT_rD_bV_0vmocOBvRbxBKg2-8EbCZhD5NJuqv18BEoPqeY2h6EyBpjCpzt7RK6ST",
            secretKey: "EHwXT5_Vm2a3_puPeZ2jb8jmn7ooa0s-ADShYLzpqnnyD5pjoX1cSw_pO-5x6Psv-pdmIITr-nNr901q",
            transactions: [
              {
                "amount": {
                  "total": donateAmount,
                  "currency": "USD",
                  "details": {
                    "subtotal": donateAmount,
                    "shipping": "0",
                    "shipping_discount": "0"
                  }
                },
                "description": "Donation Payment",
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              int result = await Donate(
                JwtToken: widget.JwtToken,
                donate_amount: int.parse(DonateAmountControllerPaypal_p.text.toString()),
                Donate_date: DateTime.now().toUtc().toString(),
                doner_username: widget.DonerUsername,
                payment_method: widget.PaymentMethod,
                post_id: widget.PostId,
                receiver_username: widget.ReceiverUsername,
              );
              print("");
              print("Http method call result to save data in donation table in database");
              print(result);
              print("");
              if (result == 1) {
                Toastget().Toastmsg("Payment success by paypal.\nThank you");
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Bill_generation(
                    donate_date: DateTime.now().toUtc().toString(),
                    donate_amount: int.parse(DonateAmountControllerPaypal_p.text.toString()),
                    doner_username: widget.DonerUsername,
                    payment_method: widget.PaymentMethod,
                    post_id: widget.PostId,
                    receiver_username: widget.ReceiverUsername,
                    JwtToken: widget.JwtToken,
                    UserType: widget.UserType,
                  );
                }));
              } else {
                int result = await RetryFailDataSaveInDatabse(
                  jwttoken: widget.JwtToken,
                  DonateAmount: DonateAmountControllerPaypal_p.text.toString(),
                  DonerUsername: widget.DonerUsername,
                  PaymentMethod: widget.ReceiverUsername,
                  PostId: widget.PostId.toString(),
                  ReceiverUsername: widget.ReceiverUsername,
                );
                if (result == 1) {
                  Toastget().Toastmsg("Payment success by paypal.\nThank you");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return Bill_generation(
                      donate_date: DateTime.now().toUtc().toString(),
                      donate_amount: int.parse(DonateAmountControllerPaypal_p.text.toString()),
                      doner_username: widget.DonerUsername,
                      payment_method: widget.PaymentMethod,
                      post_id: widget.PostId,
                      receiver_username: widget.ReceiverUsername,
                      JwtToken: widget.JwtToken,
                      UserType: widget.UserType,
                    );
                  }));
                } else {
                  print("Retry to save fail payment data in database again.");
                  print("payment success by paypal but failed to save donation info in database in second time.");
                  Toastget().Toastmsg("Payment success by paypal.\nThank you");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return Bill_generation_SP_FD_P(
                      donate_date: DateTime.now().toUtc().toString(),
                      donate_amount: int.parse(DonateAmountControllerPaypal_p.text.toString()),
                      doner_username: widget.DonerUsername,
                      payment_method: widget.PaymentMethod,
                      post_id: widget.PostId,
                      receiver_username: widget.ReceiverUsername,
                      JwtToken: widget.JwtToken,
                      UserType: widget.UserType,
                    );
                  }));
                }
              }
            },
            onError: (error) {
              Toastget().Toastmsg("Donation by paypal encountered error. Try again. Thank you.");
              print("onError: $error");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return Index_Home_Screen(username: widget.DonerUsername, jwttoken: widget.JwtToken, usertype: widget.UserType);
              }));
            },
            onCancel: () {
              Toastget().Toastmsg("Donation by paypal cancelled. Thank you.");
              print('cancelled:');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return Index_Home_Screen(username: widget.DonerUsername, jwttoken: widget.JwtToken, usertype: widget.UserType);
              }));
            },
          );
        }),
      );
      print("paypal end");
    } catch (Obj) {
      print("Exception caught while donating through paypal.");
      print(Obj.toString());
      Toastget().Toastmsg("Donation failed.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Index_Home_Screen(username: widget.DonerUsername, jwttoken: widget.JwtToken, usertype: widget.UserType);
      }));
    }


  }
}


