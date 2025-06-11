import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import '../home/esewa_pay_function.dart';
import '../home/index_home.dart';

class AmountEnterScreen_Esewa_p extends StatefulWidget {
  final String DonerUsername;
  final String ReceiverUsername;
  final int PostId;
  final String PaymentMethod;
  final String JwtToken;
  final String UserType;

  const AmountEnterScreen_Esewa_p({
    super.key,
    required this.DonerUsername,
    required this.PaymentMethod,
    required this.PostId,
    required this.ReceiverUsername,
    required this.JwtToken,
    required this.UserType,
  });

  @override
  State<AmountEnterScreen_Esewa_p> createState() => _AmountEnterScreen_Esewa_pState();
}

class _AmountEnterScreen_Esewa_pState extends State<AmountEnterScreen_Esewa_p> with SingleTickerProviderStateMixin {
  final DonateAmountController = TextEditingController();
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
    DonateAmountController.dispose();
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
          "Donate Now",
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
          DonateAmountController,
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
                "Donate Now",
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
                DonateAmountController,
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

  void _handleNext()
  {
   try{
    if (DonateAmountController.text.toString().isEmpty ||
        DonateAmountController.text == null ||
        int.tryParse(DonateAmountController.text.toString())! <= 0) {
      Toastget().Toastmsg("Enter amount greater than 0 or provide appropriate amount.");
      return;
    }
    int? DonateAmount = int.tryParse(DonateAmountController.text.toString());
    Pay_functiion(
      jwttoken: widget.JwtToken,
      context: context,
      DonerUsername: widget.DonerUsername,
      usertype: widget.UserType,
      DonateAmount: DonateAmount.toString(),
      PaymentMethod: widget.PaymentMethod,
      PostId: widget.PostId.toString(),
      ReceiverUsername: widget.ReceiverUsername,
    ).do_pay(
      context: context,
      doner_username: widget.DonerUsername,
      receiver_username: widget.ReceiverUsername,
      donate_amount: DonateAmount!,
      post_id: widget.PostId,
      payment_method: widget.PaymentMethod,
      JwtToken: widget.JwtToken,
      UserType: widget.UserType,
    );

  } catch (Obj) {
  print("Exception caught while donating through esewa.");
  print(Obj.toString());
  Toastget().Toastmsg("Enter correct details format.Failed.");
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return Index_Home_Screen(username: widget.DonerUsername, jwttoken: widget.JwtToken, usertype: widget.UserType);
  }));
  }
  }
}


