import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/CampaignInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';
import 'campaign_screen_seconadry_p.dart';

class CampaignScreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const CampaignScreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {


  @override
  void initState() {
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async {
    try {
      print("check jwt called");
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)
        {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    }
    catch(obj) {
      print("Exception caught while verifying jwt for Campaign screen.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }


  List<CampaignInfoModel> CampaignInfoList = [];
  List<CampaignInfoModel> FilteredCampaignsList = [];

  Future<void> GetCampaignInfo() async {
    try {
      print("campaign info method called");
      // const String url = "http://10.0.2.2:5074/api/Campaigns/getcampaigninfo";
      const String url = "http://192.168.1.65:5074/api/Campaigns/getcampaigninfo";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        CampaignInfoList.clear();
        CampaignInfoList.addAll
          (
          responseData.map((data) => CampaignInfoModel.fromJson(data)).toList(),
        );
        print("campaign list count value");
        print(CampaignInfoList.length);
        return;
      } else
      {
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
    super.dispose();
  }

  final Campaign_Search_Cont=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    FilteredCampaignsList.clear();
    return Scaffold
      (
      appBar: AppBar(
        title: Text("Campaign Screen"),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body:
      OrientationBuilder(
        builder: (context, orientation)
        {
                      if (orientation == Orientation.portrait) {
                        return
                          Column(
                            children: [

                              TextFormField
                                (
                                  onChanged: (value)
                                  {
                                    setState(()
                                    {
                                    });
                                  },
                                  controller: Campaign_Search_Cont,
                                  obscureText: false,
                                  decoration:InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black,
                                          width: shortestval*0.01
                                      ),
                                      borderRadius: BorderRadius.circular(shortestval*0.04),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black,
                                          width: shortestval*0.01
                                      ),
                                      borderRadius: BorderRadius.circular(shortestval*0.04),
                                    ),
                                    hintText: "Search",
                                    prefixIcon: Icon(Icons.search),
                                  )
                              ),

                              SizedBox(
                                    height: heightval*0.01,
                              ),

                              Expanded(
                                child:Container(
                                  width: widthval,
                                  child:
                                  FutureBuilder<void>(
                                    future: GetCampaignInfo(),
                                    builder: (context, snapshot)
                                    {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Show a loading indicator while the future is executing
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      else if (snapshot.hasError) {
                                        // Handle any error from the future
                                        return Center(
                                          child: Text(
                                            "Error fetching campaigns data. Please reopen app.",
                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                          ),
                                        );
                                      }
                                      else if (snapshot.connectionState == ConnectionState.done)
                                      {
                                        if(Campaign_Search_Cont.text.toString().isNotEmptyAndNotNull && CampaignInfoList.length>=1)
                                          {
                                            try {
                                              print("Filteredcampaign list add item condition called.");
                                              // Iterate through your CampaignInfoList and check if postId matches the text input.
                                              for (var campaign in CampaignInfoList)
                                              {
                                                if (campaign.postId.toString()==Campaign_Search_Cont.text.toString().toLowerCase().trim())
                                                {
                                                  // If the postId matches, add it to the FilteredCampaigns list.
                                                  print("Search id of campaign match and add in filter campign list.");
                                                  print("Campaign Id = ${campaign.postId}");
                                                  FilteredCampaignsList.clear();
                                                  FilteredCampaignsList.add(campaign);
                                                }
                                              }
                                              if(FilteredCampaignsList.length<=0)
                                                {
                                                  FilteredCampaignsList.clear();
                                                  Toastget().Toastmsg("Enter campaign id didn't match with available campaign post.");
                                                  print("Campaign Id didn't match that enter in textformfield.");
                                                }
                                            }catch(Obj)
                                      {
                                        FilteredCampaignsList.clear();
                                        Toastget().Toastmsg("Enter campaign id didn't match with available campaign post.");
                                        print("Exception caught while filtering campaign list");
                                        print(Obj.toString());
                                      }
                                          }
                                          return CampaignInfoList.isEmpty
                                              ? const Center(child: Text("No campaign data available."))
                                              :
                                              Container(
                                                color: Colors.grey,
                                                width: widthval,
                                                height: heightval,
                                                child:
                                                    Builder(builder: (context)
                                                    {
                                                      if(FilteredCampaignsList.length>=1)
                                                        {
                                                          return
                                                            ListView.builder(
                                                                itemBuilder: (context, index)
                                                                {
                                                                  final campaign = FilteredCampaignsList[index];
                                                                  return Card(
                                                                    child: ListTile(
                                                                        leading: CircleAvatar(
                                                                          backgroundImage: MemoryImage(
                                                                            base64Decode(campaign.photo!),
                                                                          ),
                                                                        ),
                                                                        title: Text(campaign.tittle!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
                                                                        subtitle: Text(campaign.campaignDate!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
                                                                        trailing: Text("${campaign.postId!}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05))
                                                                    ),
                                                                  )
                                                                      .onTap (()
                                                                  {
                                                                    Navigator.push(context,MaterialPageRoute(builder: (context) {
                                                                      return CampaignScreenSeconadry(campaign:campaign);
                                                                    },
                                                                    )
                                                                    );
                                                                  }
                                                                  );
                                                                },
                                                                itemCount: FilteredCampaignsList.length
                                                            );
                                                        }
                                                      else{
                                                        return
                                                          ListView.builder(
                                                              itemBuilder: (context, index)
                                                              {
                                                                final campaign = CampaignInfoList[index];
                                                                return Card(
                                                                  child: ListTile(
                                                                      leading: CircleAvatar(
                                                                        backgroundImage: MemoryImage(
                                                                          base64Decode(campaign.photo!),
                                                                        ),
                                                                      ),
                                                                      title: Text(campaign.tittle!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
                                                                      subtitle: Text(campaign.campaignDate!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
                                                                      trailing: Text("${campaign.postId!}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05))
                                                                  ),
                                                                )
                                                                    .onTap (()
                                                                {
                                                                  Navigator.push(context,MaterialPageRoute(builder: (context) {
                                                                    return CampaignScreenSeconadry(campaign:campaign);
                                                                  },
                                                                  )
                                                                  );
                                                                }
                                                                );
                                                              },
                                                              itemCount: CampaignInfoList.length
                                                          );
                                                      }
                                                    },
                                                    ),
                                              );
                                      }
                                      else
                                      {
                                        return
                                          Center(
                                            child: Text(
                                              "Please reopen app.",
                                              style: TextStyle(color: Colors.red, fontSize: 16),
                                            ),
                                          );
                                      }
                                    }
                                  ),
                                ),
                              )
                            ],
                          );
                      }
                      else if (orientation == Orientation.landscape)
                      {
                        return Container(
                          // Add your landscape-specific layout here
                        );
                      }
                      else
                      {
                        return
                          Center(
                          child: Text(
                            "Mobile orientation must be either protrait or landscape.",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      }
        },
      ),

    );
  }
}

