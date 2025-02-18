import 'package:flutter/material.dart';
import 'package:hand_in_need/models/mobile/PostInfoModel.dart';

import '../commonwidget/circular_progress_ind_yellow.dart';

class QrScanPostScreen extends StatefulWidget {
  final int postId;
  const QrScanPostScreen({super.key,required this.postId});
  @override
  State<QrScanPostScreen> createState() => _QrScanPostScreenState();
}

class _QrScanPostScreenState extends State<QrScanPostScreen> {
  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold
      (

      appBar: AppBar(
        title: Text("QR scan post screen."),
        backgroundColor: Colors.green,
      ),
      body:
      OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return
            Container(
                width:widthval,
                height: heightval,
                color: Colors.white10,
                child:
                Center(
                  child: Container(
                    width: widthval,
                    height: heightval*0.5,
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children:
                        [

                          Text("${widget.postId}"),


                        ],
                      ),
                    ),
                  ),
                )
            );
        }
        else if(orientation==Orientation.landscape)
        {
          return
            Container(

            );

        }
        else{
          return Circular_pro_indicator_Yellow(context);
        }
      },
      ),
    );
  }
}
