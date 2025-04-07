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
  const CampaignScreenSeconadry({super.key, required this.campaign});

  @override
  State<CampaignScreenSeconadry> createState() => _CampaignScreenSeconadryState();
}

class _CampaignScreenSeconadryState extends State<CampaignScreenSeconadry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isMobile = shortestSide < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Details",
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.green.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: _buildPostCardCampaign(context, isMobile),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCardCampaign(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final campaign = widget.campaign;
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.cardColor,
              theme.cardColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign.tittle!,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            )),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 16, color: theme.hintColor),
                            const SizedBox(width: 4),
                            Text(campaign.username!,
                                style: theme.textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: theme.hintColor),
                            const SizedBox(width: 4),
                            Text(
                              campaign.campaignDate.toString().split("T").first,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildDownloadMenu(context),
                ],
              ),
            ),

            // Media Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64Decode(campaign.photo!),
                  width: double.infinity,
                  height: shortestSide * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Video Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: ListTile(
                  onTap: () async {
                    String videoFilePath = await writeBase64VideoToTempFileCampaign(campaign.video!);
                    if (videoFilePath.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => VideoPlayerControllerScreen(
                            video_file_path: videoFilePath),
                      ));
                    } else {
                      Toastget().Toastmsg("No video data available.");
                    }
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  title: Text("Watch Campaign Video",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      )),
                  trailing: const Icon(Icons.chevron_right),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            // Description Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(),
                collapsedShape: const RoundedRectangleBorder(),
                iconColor: theme.colorScheme.primary,
                collapsedIconColor: theme.colorScheme.secondary,
                title: Text("Campaign Details",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(campaign.description!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadMenu(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_vert,
            color: Theme.of(context).colorScheme.primary),
      ),
      onSelected: (value) async {
        if (value == 'download file') {
          await downloadFileCampaign(
              widget.campaign.campaignFile!, widget.campaign.fileExtension!);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'download file',
          child: Row(
            children: [
              Icon(Icons.download,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text('Download Resources',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hand_in_need/models/mobile/CampaignInfoModel.dart';
// import '../../constant/styles.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/VideoPlayer_controller.dart';
// import '../commonwidget/toast.dart';
//
// class CampaignScreenSeconadry extends StatefulWidget {
//   final CampaignInfoModel campaign;
//   const CampaignScreenSeconadry({super.key,required this.campaign});
//
//   @override
//   State<CampaignScreenSeconadry> createState() => _CampaignScreenSeconadryState();
// }
//
// class _CampaignScreenSeconadryState extends State<CampaignScreenSeconadry> {
//   @override
//   Widget build(BuildContext context)
//   {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return
//     Scaffold(
//       appBar: AppBar(
//         title: Text("Campaign secondary screen"),
//         backgroundColor: Colors.green,
//         automaticallyImplyLeading: true,
//       ),
//       body:
//       Container(
//         height: heightval,
//         width: widthval,
//         color: Colors.grey,
//         child: Center(
//           child:  _buildPostCardCampaign(widget.campaign,context),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildPostCardCampaign(CampaignInfoModel campaign, BuildContext context)
// {
//   var shortestval = MediaQuery.of(context).size.shortestSide;
//   var widthval = MediaQuery.of(context).size.width;
//   var heightval = MediaQuery.of(context).size.height;
//   return
//     Container(
//       height:heightval*0.60,
//       width: widthval,
//       decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       color: Colors.blueGrey,
//       boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
//     ),
//     child:
//     SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       scrollDirection: Axis.vertical,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           // Row 1: Username ,date and 3-dot button for downloading resources
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children:
//             [
//               Text("${campaign.username} posted campaign.", style: TextStyle(fontFamily: bold,fontSize: shortestval*0.05)),
//
//               Expanded(
//                 child: SizedBox(
//                 ),
//               ),
//
//               PopupMenuButton<String>(
//                 onSelected: (value) async
//                 {
//                   if (value == 'download file')
//                   {
//                     await downloadFileCampaign(campaign.campaignFile!,campaign.fileExtension!);
//                   }
//                 },
//                 itemBuilder: (context) =>
//                 [
//                   PopupMenuItem(value: 'download file', child: Text('Download Resources',style: TextStyle(fontFamily:bold,color: Colors.black,fontSize: shortestval*0.06),)),
//                 ],
//               ),
//
//
//             ],
//           ),
//
//           Text('${campaign.campaignDate.toString().split("T").first}', style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),
//
//           // Row 3: Description for the post
//           Center(child: Text("Tittle:${campaign.tittle!}", style: TextStyle(color: Colors.black,fontSize: shortestval*0.05))),
//           SizedBox(height: heightval*0.02,),
//           // Row 3: Description for the post
//           ExpansionTile(
//             title:Text("Description of campaign."),
//             tilePadding: EdgeInsets.zero,
//             childrenPadding: EdgeInsets.zero,
//             children:
//             [
//               Container
//                 (
//                   alignment: Alignment.centerLeft,
//                   child:  Text(campaign.description!, style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),),
//             ],
//           ),
//           SizedBox(height: 8),
//           // Row 4: Image (Decode base64 and display)
//           Image.memory(base64Decode(campaign.photo!), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
//           SizedBox(height: heightval*0.02,),
//
//           // Row 5: Video (Placeholder for now, video player to be added later)
//           // We'll add the video player functionality later
//           Container(
//             color: Colors.teal,
//             height: heightval*0.06,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: ()async
//                 {
//                   String video_file_path=await writeBase64VideoToTempFileCampaign(campaign.video!);
//                   if(video_file_path != null && video_file_path.isNotEmpty)
//                   {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       return VideoPlayerControllerScreen(video_file_path:video_file_path);
//                     },
//                     )
//                     );
//                   }
//                   else
//                   {
//                     Toastget().Toastmsg("No video data available.");
//                     return;
//                   }
//
//                 },
//                 child: Text("Play Video"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
