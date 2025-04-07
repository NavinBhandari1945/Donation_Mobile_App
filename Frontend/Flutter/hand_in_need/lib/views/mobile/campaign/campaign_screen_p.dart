import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/CampaignInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import '../home/authentication_home_p.dart';
import 'campaign_screen_seconadry_p.dart';

class CampaignScreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const CampaignScreen({
    super.key,
    required this.username,
    required this.usertype,
    required this.jwttoken,
  });

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final Campaign_Search_Cont = TextEditingController();

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
    checkJWTExpiation();
    _animationController.forward();
  }

  Future<void> checkJWTExpiation() async {
    try {
      print("check jwt called");
      int result = await checkJwtToken_initistate_user(widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for Campaign screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  List<CampaignInfoModel> CampaignInfoList = [];
  List<CampaignInfoModel> FilteredCampaignsList = [];

  Future<void> GetCampaignInfo() async {
    try {
      print("campaign info method called");
      const String url = Backend_Server_Url + "api/Campaigns/getcampaigninfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        CampaignInfoList.clear();
        CampaignInfoList.addAll(responseData.map((data) => CampaignInfoModel.fromJson(data)).toList());
        print("campaign list count value");
        print(CampaignInfoList.length);
        return;
      } else {
        CampaignInfoList.clear();
        print("Data insert in campaign info list failed.");
        return;
      }
    } catch (obj) {
      CampaignInfoList.clear();
      print("Exception caught while fetching campaign data for campaign screen in http method");
      print(obj.toString());
      return;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    Campaign_Search_Cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    FilteredCampaignsList.clear();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Campaigns",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: false,
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
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(shortestval, widthval, heightval)
                  : _buildLandscapeLayout(shortestval, widthval, heightval),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.all(shortestval * 0.03),
          child: TextFormField(
            onChanged: (value) => setState(() {}),
            controller: Campaign_Search_Cont,
            obscureText: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: "Search by Campaign ID",
              hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
              prefixIcon: Icon(Icons.search, color: Colors.green[700]),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: shortestval * 0.04, horizontal: shortestval * 0.03),
            ),
            style: TextStyle(fontSize: shortestval * 0.04, color: Colors.grey[800]),
          ),
        ),
        SizedBox(height: heightval * 0.01),
        // Campaign List
        Expanded(
          child: FutureBuilder<void>(
            future: GetCampaignInfo(),
            builder: (context, snapshot) => _buildCampaignList(snapshot, shortestval, widthval, heightval, isPortrait: true),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return Row(
      children: [
        // Search Bar (Left Side)
        Container(
          width: widthval * 0.3,
          padding: EdgeInsets.all(shortestval * 0.03),
          child: TextFormField(
            onChanged: (value) => setState(() {}),
            controller: Campaign_Search_Cont,
            obscureText: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: "Search by ID",
              hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
              prefixIcon: Icon(Icons.search, color: Colors.green[700]),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: shortestval * 0.04, horizontal: shortestval * 0.03),
            ),
            style: TextStyle(fontSize: shortestval * 0.04, color: Colors.grey[800]),
          ),
        ),
        // Campaign List (Right Side)
        Expanded(
          child: FutureBuilder<void>(
            future: GetCampaignInfo(),
            builder: (context, snapshot) => _buildCampaignList(snapshot, shortestval, widthval, heightval, isPortrait: false),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignList(AsyncSnapshot<void> snapshot, double shortestval, double widthval, double heightval, {required bool isPortrait}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator(color: Colors.green[700], strokeWidth: 3));
    } else if (snapshot.hasError) {
      return Center(
        child: Text(
          "Error fetching campaigns data. Please reopen app.",
          style: TextStyle(color: Colors.red[700], fontSize: shortestval * 0.045, fontFamily: semibold),
          textAlign: TextAlign.center,
        ),
      );
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (Campaign_Search_Cont.text.toString().isNotEmptyAndNotNull && CampaignInfoList.length >= 1) {
        try {
          print("Filteredcampaign list add item condition called.");
          for (var campaign in CampaignInfoList) {
            if (campaign.postId.toString() == Campaign_Search_Cont.text.toString().toLowerCase().trim()) {
              print("Search id of campaign match and add in filter campaign list.");
              print("Campaign Id = ${campaign.postId}");
              FilteredCampaignsList.clear();
              FilteredCampaignsList.add(campaign);
            }
          }
          if (FilteredCampaignsList.length <= 0) {
            FilteredCampaignsList.clear();
            Toastget().Toastmsg("Enter campaign id didn't match with available campaign post.");
            print("Campaign Id didn't match that enter in textformfield.");
          }
        } catch (Obj) {
          FilteredCampaignsList.clear();
          Toastget().Toastmsg("Enter campaign id didn't match with available campaign post.");
          print("Exception caught while filtering campaign list");
          print(Obj.toString());
        }
      }
      return CampaignInfoList.isEmpty
          ? Center(
        child: Text(
          "No campaign data available",
          style: TextStyle(fontSize: shortestval * 0.05, fontFamily: semibold, color: Colors.grey[600]),
        ),
      )
          : Builder(builder: (context) {
        final displayList = FilteredCampaignsList.length >= 1 ? FilteredCampaignsList : CampaignInfoList;
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPortrait ? 1 : 2,
            childAspectRatio: isPortrait ? 3 : 2,
            crossAxisSpacing: shortestval * 0.03,
            mainAxisSpacing: shortestval * 0.03,
          ),
          padding: EdgeInsets.all(shortestval * 0.03),
          itemBuilder: (context, index) => _buildCampaignCard(displayList[index], context),
          itemCount: displayList.length,
        );
      });
    }
    return Center(
      child: Text(
        "Please reopen app.",
        style: TextStyle(color: Colors.red[700], fontSize: shortestval * 0.045, fontFamily: semibold),
      ),
    );
  }

  Widget _buildCampaignCard(CampaignInfoModel campaign, BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 2, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignScreenSeconadry(campaign: campaign))),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    base64Decode(campaign.photo!),
                    width: shortestval * 0.15,
                    height: shortestval * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: shortestval * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        campaign.tittle!,
                        style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.045, color: Colors.grey[800]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: shortestval * 0.01),
                      Text(
                        campaign.campaignDate!,
                        style: TextStyle(fontFamily: regular, fontSize: shortestval * 0.035, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03, vertical: shortestval * 0.015),
                  decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "#${campaign.postId!}",
                    style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.04, color: Colors.green[700]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}









// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:velocity_x/velocity_x.dart';
// import '../../../models/mobile/CampaignInfoModel.dart';
// import '../../constant/styles.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/toast.dart';
// import '../constant/constant.dart';
// import '../home/authentication_home_p.dart';
// import 'campaign_screen_seconadry_p.dart';
//
// class CampaignScreen extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const CampaignScreen({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//
//   @override
//   State<CampaignScreen> createState() => _CampaignScreenState();
// }
//
// class _CampaignScreenState extends State<CampaignScreen> {
//
//
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiation();
//   }
//
//   Future<void> checkJWTExpiation()async {
//     try {
//       print("check jwt called");
//       int result = await checkJwtToken_initistate_user(
//           widget.username, widget.usertype, widget.jwttoken);
//       if (result == 0) {
//         await clearUserData();
//         await deleteTempDirectoryPostVideo();
//         await deleteTempDirectoryCampaignVideo();
//         print("Deleteing temporary directory success.");
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context)
//         {
//           return AuthenticationHome();
//         },)
//         );
//         Toastget().Toastmsg("Session End. Relogin please.");
//       }
//     }
//     catch(obj) {
//       print("Exception caught while verifying jwt for Campaign screen.");
//       print(obj.toString());
//       await clearUserData();
//       await deleteTempDirectoryPostVideo();
//       await deleteTempDirectoryCampaignVideo();
//       print("Deleteing temporary directory success.");
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) {
//         return AuthenticationHome();
//       },)
//       );
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//
//   List<CampaignInfoModel> CampaignInfoList = [];
//   List<CampaignInfoModel> FilteredCampaignsList = [];
//
//   Future<void> GetCampaignInfo() async {
//     try {
//       print("campaign info method called");
//       // const String url = "http://10.0.2.2:5074/api/Campaigns/getcampaigninfo";
//       const String url =Backend_Server_Url+"api/Campaigns/getcampaigninfo";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//
//       final response = await http.get(Uri.parse(url), headers: headers);
//
//       if (response.statusCode == 200) {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         CampaignInfoList.clear();
//         CampaignInfoList.addAll
//           (
//           responseData.map((data) => CampaignInfoModel.fromJson(data)).toList(),
//         );
//         print("campaign list count value");
//         print(CampaignInfoList.length);
//         return;
//       } else
//       {
//         CampaignInfoList.clear();
//         print("Data insert in campaign info list failed.");
//         return;
//       }
//     } catch (obj) {
//       CampaignInfoList.clear();
//       print("Exception caught while fetching campaign data for campaign screen in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   final Campaign_Search_Cont=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     FilteredCampaignsList.clear();
//     return Scaffold
//       (
//       appBar: AppBar(
//         title: Text("Campaign Screen"),
//         backgroundColor: Colors.green,
//         automaticallyImplyLeading: false,
//       ),
//       body:
//       OrientationBuilder(
//         builder: (context, orientation)
//         {
//                       if (orientation == Orientation.portrait) {
//                         return
//                           Column(
//                             children: [
//
//                               TextFormField
//                                 (
//                                   onChanged: (value)
//                                   {
//                                     setState(()
//                                     {
//                                     });
//                                   },
//                                   controller: Campaign_Search_Cont,
//                                   obscureText: false,
//                                   decoration:InputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.black,
//                                           width: shortestval*0.01
//                                       ),
//                                       borderRadius: BorderRadius.circular(shortestval*0.04),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.black,
//                                           width: shortestval*0.01
//                                       ),
//                                       borderRadius: BorderRadius.circular(shortestval*0.04),
//                                     ),
//                                     hintText: "Search",
//                                     prefixIcon: Icon(Icons.search),
//                                   )
//                               ),
//
//                               SizedBox(
//                                     height: heightval*0.01,
//                               ),
//
//                               Expanded(
//                                 child:Container(
//                                   width: widthval,
//                                   child:
//                                   FutureBuilder<void>(
//                                     future: GetCampaignInfo(),
//                                     builder: (context, snapshot)
//                                     {
//                                       if (snapshot.connectionState == ConnectionState.waiting) {
//                                         // Show a loading indicator while the future is executing
//                                         return Center(child: CircularProgressIndicator());
//                                       }
//                                       else if (snapshot.hasError) {
//                                         // Handle any error from the future
//                                         return Center(
//                                           child: Text(
//                                             "Error fetching campaigns data. Please reopen app.",
//                                             style: TextStyle(color: Colors.red, fontSize: 16),
//                                           ),
//                                         );
//                                       }
//                                       else if (snapshot.connectionState == ConnectionState.done)
//                                       {
//                                         if(Campaign_Search_Cont.text.toString().isNotEmptyAndNotNull && CampaignInfoList.length>=1)
//                                           {
//                                             try {
//                                               print("Filteredcampaign list add item condition called.");
//                                               // Iterate through your CampaignInfoList and check if postId matches the text input.
//                                               for (var campaign in CampaignInfoList)
//                                               {
//                                                 if (campaign.postId.toString()==Campaign_Search_Cont.text.toString().toLowerCase().trim())
//                                                 {
//                                                   // If the postId matches, add it to the FilteredCampaigns list.
//                                                   print("Search id of campaign match and add in filter campign list.");
//                                                   print("Campaign Id = ${campaign.postId}");
//                                                   FilteredCampaignsList.clear();
//                                                   FilteredCampaignsList.add(campaign);
//                                                 }
//                                               }
//                                               if(FilteredCampaignsList.length<=0)
//                                                 {
//                                                   FilteredCampaignsList.clear();
//                                                   Toastget().Toastmsg("Enter campaign id didn't match with available campaign post.");
//                                                   print("Campaign Id didn't match that enter in textformfield.");
//                                                 }
//                                             }catch(Obj)
//                                       {
//                                         FilteredCampaignsList.clear();
//                                         Toastget().Toastmsg("Enter campaign id didn't match with available campaign post.");
//                                         print("Exception caught while filtering campaign list");
//                                         print(Obj.toString());
//                                       }
//                                           }
//                                           return CampaignInfoList.isEmpty
//                                               ? const Center(child: Text("No campaign data available."))
//                                               :
//                                               Container(
//                                                 color: Colors.grey,
//                                                 width: widthval,
//                                                 height: heightval,
//                                                 child:
//                                                     Builder(builder: (context)
//                                                     {
//                                                       if(FilteredCampaignsList.length>=1)
//                                                         {
//                                                           return
//                                                             ListView.builder(
//                                                                 itemBuilder: (context, index)
//                                                                 {
//                                                                   final campaign = FilteredCampaignsList[index];
//                                                                   return Card(
//                                                                     child: ListTile(
//                                                                         leading: CircleAvatar(
//                                                                           backgroundImage: MemoryImage(
//                                                                             base64Decode(campaign.photo!),
//                                                                           ),
//                                                                         ),
//                                                                         title: Text(campaign.tittle!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
//                                                                         subtitle: Text(campaign.campaignDate!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
//                                                                         trailing: Text("${campaign.postId!}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05))
//                                                                     ),
//                                                                   )
//                                                                       .onTap (()
//                                                                   {
//                                                                     Navigator.push(context,MaterialPageRoute(builder: (context) {
//                                                                       return CampaignScreenSeconadry(campaign:campaign);
//                                                                     },
//                                                                     )
//                                                                     );
//                                                                   }
//                                                                   );
//                                                                 },
//                                                                 itemCount: FilteredCampaignsList.length
//                                                             );
//                                                         }
//                                                       else{
//                                                         return
//                                                           ListView.builder(
//                                                               itemBuilder: (context, index)
//                                                               {
//                                                                 final campaign = CampaignInfoList[index];
//                                                                 return Card(
//                                                                   child: ListTile(
//                                                                       leading: CircleAvatar(
//                                                                         backgroundImage: MemoryImage(
//                                                                           base64Decode(campaign.photo!),
//                                                                         ),
//                                                                       ),
//                                                                       title: Text(campaign.tittle!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
//                                                                       subtitle: Text(campaign.campaignDate!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
//                                                                       trailing: Text("${campaign.postId!}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05))
//                                                                   ),
//                                                                 )
//                                                                     .onTap (()
//                                                                 {
//                                                                   Navigator.push(context,MaterialPageRoute(builder: (context) {
//                                                                     return CampaignScreenSeconadry(campaign:campaign);
//                                                                   },
//                                                                   )
//                                                                   );
//                                                                 }
//                                                                 );
//                                                               },
//                                                               itemCount: CampaignInfoList.length
//                                                           );
//                                                       }
//                                                     },
//                                                     ),
//                                               );
//                                       }
//                                       else
//                                       {
//                                         return
//                                           Center(
//                                             child: Text(
//                                               "Please reopen app.",
//                                               style: TextStyle(color: Colors.red, fontSize: 16),
//                                             ),
//                                           );
//                                       }
//                                     }
//                                   ),
//                                 ),
//                               )
//                             ],
//                           );
//                       }
//                       else if (orientation == Orientation.landscape)
//                       {
//                         return Container(
//                           // Add your landscape-specific layout here
//                         );
//                       }
//                       else
//                       {
//                         return
//                           Center(
//                           child: Text(
//                             "Mobile orientation must be either protrait or landscape.",
//                             style: TextStyle(color: Colors.red, fontSize: 16),
//                           ),
//                         );
//                       }
//         },
//       ),
//
//     );
//   }
// }
//
