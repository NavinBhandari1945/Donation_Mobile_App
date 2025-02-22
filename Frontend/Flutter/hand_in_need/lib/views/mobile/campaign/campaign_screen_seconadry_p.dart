import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_in_need/models/mobile/CampaignInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/toast.dart';

class CampaignScreenSeconadry extends StatefulWidget {
  final CampaignInfoModel campaign;
  const CampaignScreenSeconadry({super.key,required this.campaign});

  @override
  State<CampaignScreenSeconadry> createState() => _CampaignScreenSeconadryState();
}

class _CampaignScreenSeconadryState extends State<CampaignScreenSeconadry> {
  @override
  Widget build(BuildContext context)
  {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return
    Scaffold(
      appBar: AppBar(
        title: Text("Campaign secondary screen"),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
      ),
      body:
      Container(
        height: heightval,
        width: widthval,
        color: Colors.grey,
        child: Center(
          child:  _buildPostCardCampaign(widget.campaign,context),
        ),
      ),
    );
  }
}

Widget _buildPostCardCampaign(CampaignInfoModel campaign, BuildContext context)
{
  var shortestval = MediaQuery.of(context).size.shortestSide;
  var widthval = MediaQuery.of(context).size.width;
  var heightval = MediaQuery.of(context).size.height;
  return
    Container(
      height:heightval*0.60,
      width: widthval,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.blueGrey,
      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
    ),
    child:
    SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Row 1: Username ,date and 3-dot button for downloading resources
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              Text("${campaign.username} posted campaign.", style: TextStyle(fontFamily: bold,fontSize: shortestval*0.05)),

              Expanded(
                child: SizedBox(
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) async
                {
                  if (value == 'download file')
                  {
                    await downloadFileCampaign(campaign.campaignFile!,campaign.fileExtension!);
                  }
                },
                itemBuilder: (context) =>
                [
                  PopupMenuItem(value: 'download file', child: Text('Download Resources',style: TextStyle(fontFamily:bold,color: Colors.black,fontSize: shortestval*0.06),)),
                ],
              ),


            ],
          ),

          Text('${campaign.campaignDate.toString().split("T").first}', style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),

          // Row 3: Description for the post
          Center(child: Text("Tittle:${campaign.tittle!}", style: TextStyle(color: Colors.black,fontSize: shortestval*0.05))),
          SizedBox(height: heightval*0.02,),
          // Row 3: Description for the post
          ExpansionTile(
            title:Text("Description of campaign."),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children:
            [
              Container
                (
                  alignment: Alignment.centerLeft,
                  child:  Text(campaign.description!, style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),),
            ],
          ),
          SizedBox(height: 8),
          // Row 4: Image (Decode base64 and display)
          Image.memory(base64Decode(campaign.photo!), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
          SizedBox(height: heightval*0.02,),

          // Row 5: Video (Placeholder for now, video player to be added later)
          // We'll add the video player functionality later
          Container(
            color: Colors.teal,
            height: heightval*0.06,
            child: Center(
              child: ElevatedButton(
                onPressed: ()async
                {
                  String video_file_path=await writeBase64VideoToTempFileCampaign(campaign.video!);
                  if(video_file_path != null && video_file_path.isNotEmpty)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return VideoPlayerControllerScreen(video_file_path:video_file_path);
                    },
                    )
                    );
                  }
                  else
                  {
                    Toastget().Toastmsg("No video data available.");
                    return;
                  }

                },
                child: Text("Play Video"),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

