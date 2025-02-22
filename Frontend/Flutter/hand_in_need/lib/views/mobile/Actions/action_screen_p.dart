import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/models/mobile/AdvertisementModel.dart';
import 'package:hand_in_need/models/mobile/DonationModel.dart';
import 'package:hand_in_need/models/mobile/FriendInfoModel.dart';
import 'package:hand_in_need/views/mobile/Actions/InsertPostScreen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/UserInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';
import '../profile/User_Friend_Profile_Screen_P.dart';
import 'InsertCampaignScreen_p.dart';
import 'ScanQRScreen.dart';
import 'package:http/http.dart' as http;


class ActionScreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const ActionScreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {

  final isLoadingCont=Get.put(Isloading());

  final  Search_User_Action_cont=TextEditingController();

  @override
  void initState(){
    super.initState();
    checkJWTExpiation();
  }

  @override
  void dispose(){
    super.dispose();
    Search_User_Action_cont.dispose();
  }

  Future<void> checkJWTExpiation()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
      print(widget.jwttoken);
      if (result == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    }
    catch(obj)
    {
      print("Exception caught while verifying jwt for Action screen.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.");
    }

  }

  List<UserInfoModel> Filter_User_Info_List = [];

  List<UserInfoModel> User_Info_List = [];

  Future<void> GetUserInfo() async
  {
    try {
      print("Profile post info method called");
      // const String url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
      const String url = "http://192.168.1.65:5074/api/Actions/getuserinfo";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
          Uri.parse(url),
          headers: headers,
      );

      if (response.statusCode == 200)
      {
        List<dynamic> responseData = await jsonDecode(response.body);
        User_Info_List.clear();
        User_Info_List.addAll
          (
          responseData.map((data) => UserInfoModel.fromJson(data)).toList(),
        );
        print("User_Info_List for actions screen count value");
        print(User_Info_List.length);
        return;
      } else
      {
        User_Info_List.clear();
        print("Data insert in User_Info_List for actions screen failed.");
        return;
      }
    } catch (obj) {
      User_Info_List.clear();
      print("Exception caught while fetching User_Info  for actions screen screen in http method");
      print(obj.toString());
      return;
    }
  }

  List<AdvertisementModel> Ad_Info_List = [];

  Future<void> Get_Advertisement_Info() async
  {
    try {
      print("Profile post info method called");
      // const String url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
      const String url = "http://192.168.1.65:5074/api/Actions/get_ad_info";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200)
      {
        List<dynamic> responseData = await jsonDecode(response.body);
        Ad_Info_List.clear();
        Ad_Info_List.addAll
          (
          responseData.map((data) => AdvertisementModel.fromJson(data)).toList(),
        );
        print("Ad info list for actions screen count value");
        print(Ad_Info_List.length);
        return;
      } else
      {
        Ad_Info_List.clear();
        print("Data insert in ad info list for actions screen failed.");
        return;
      }
    } catch (obj) {
      Ad_Info_List.clear();
      print("Exception caught while fetching ad info for actions screen screen in http method");
      print(obj.toString());
      return;
    }
  }

  List<DonationModel> Donation_Info_List = [];

  Future<void> Get_Donation_Info() async
  {
    try {
      print("Profile post info method called");
      // const String url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
      const String url = "http://192.168.1.65:5074/api/Actions/get_donation_info";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200)
      {
        List<dynamic> responseData = await jsonDecode(response.body);
        Donation_Info_List.clear();
        Donation_Info_List.addAll
          (
          responseData.map((data) => DonationModel.fromJson(data)).toList(),
        );
        print("Donation info list for actions screen count value");
        print(Donation_Info_List.length);
        return;
      } else
      {
        Donation_Info_List.clear();
        print("Data insert in Donation info list for actions screen failed.");
        return;
      }
    } catch (obj) {
      Donation_Info_List.clear();
      print("Exception caught while fetching Donation info for actions screen in http method");
      print(obj.toString());
      return;
    }
  }



  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    Filter_User_Info_List.clear();
    return Scaffold
      (
        appBar: AppBar(
          title: Text("Action Screen"),
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
        ),
        body:OrientationBuilder(builder: (context, orientation)
        {
          if(orientation==Orientation.portrait)
          {
            return

              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Container(
                    width:widthval,
                    height: heightval,
                    color: Colors.grey,
                    child:
                    Column(
                      children:
                      [
                        TextFormField
                          (
                            onChanged: (value)
                            {
                              setState(()
                              {
                              });
                            },
                            controller: Search_User_Action_cont,
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

                        Container (
                          // color: Colors.brown,
                          width: widthval,
                          height: heightval*0.15,
                          child:
                          FutureBuilder<void>(
                              future: GetUserInfo(),
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
                                  if(Search_User_Action_cont.text.toString().isNotEmptyAndNotNull && User_Info_List.length>=1)
                                  {
                                    try {
                                      print("Filtere user list add item condition called.");
                                      // Iterate through your CampaignInfoList and check if postId matches the text input.
                                      for (var user_info in User_Info_List)
                                      {
                                        if (user_info.username.toString().toLowerCase().trim()==Search_User_Action_cont.text.toString().toLowerCase().trim())
                                        {
                                          // If the postId matches, add it to the FilteredCampaigns list.
                                          print("Search username of cuser match and add in filter user info list.");
                                          print("Username= ${user_info.username}");
                                          Filter_User_Info_List.clear();
                                          Filter_User_Info_List.add(user_info);
                                        }
                                      }
                                      if(Filter_User_Info_List.length<=0)
                                      {
                                        Filter_User_Info_List.clear();
                                        Toastget().Toastmsg("Enter username didn't match with available user username.");
                                        print("Enter username didn't match with available user username.");
                                      }
                                    }catch(Obj)
                                    {
                                      Filter_User_Info_List.clear();
                                      Toastget().Toastmsg("Enter username didn't match with available user username.");
                                      print("Exception caught while filtering user info list");
                                      print(Obj.toString());
                                    }
                                  }
                                  return User_Info_List.isEmpty
                                      ? const Center(child: Text("No user data available."))
                                      :
                                  Container(
                                    color: Colors.grey,
                                    width: widthval,
                                    height: heightval,
                                    child:
                                    Builder(builder: (context)
                                    {
                                      if(Filter_User_Info_List.length>=1)
                                      {
                                        return
                                          ListView.builder(
                                            shrinkWrap: true,
                                              itemBuilder: (context, index)
                                              {
                                                final user = Filter_User_Info_List[index];
                                                return
                                                  Card(
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children:
                                                    [
                                                      Text("Friend Username:${user.username}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05),),
                                                      Icon(Icons.people_rounded),
                                                    ],
                                                  ).onTap((){
                                                    Navigator.push(context,MaterialPageRoute(builder: (context)
                                                    {
                                                      return User_Friend_Profile_Screen_P(
                                                        FriendUsername:user.username!,
                                                        Current_User_Usertype:widget.usertype ,
                                                        Current_User_Username: widget.username,
                                                        Current_User_Jwt_Token: widget.jwttoken,);
                                                    },));
                                                  }) ,
                                                )
                                                    .onTap (()
                                                {
                                                  Navigator.push(context,MaterialPageRoute(builder: (context) {
                                                    return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,
                                                    Current_User_Username: widget.username,
                                                      FriendUsername: user.username!,
                                                      Current_User_Usertype: widget.usertype,
                                                    );
                                                  },
                                                  )
                                                  );

                                                }
                                                );
                                              },
                                              itemCount: Filter_User_Info_List.length
                                          );
                                      }
                                      else{
                                        return
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemBuilder: (context, index)
                                              {
                                                final user = User_Info_List[index];
                                                return Card(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children:
                                                    [
                                                      Text("Friend Username:${user.username}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05),),
                                                      Icon(Icons.people_rounded),
                                                    ],
                                                  )
                                                      .onTap((){
                                                    Navigator.push(context,MaterialPageRoute(builder: (context)
                                                    {
                                                      return User_Friend_Profile_Screen_P(
                                                        FriendUsername:user.username!,
                                                        Current_User_Usertype:widget.usertype ,
                                                        Current_User_Username: widget.username,
                                                        Current_User_Jwt_Token: widget.jwttoken,);
                                                    },));
                                                  }) ,
                                                )
                                                    .onTap (()
                                                {
                                                  Navigator.push(context,MaterialPageRoute(builder: (context) {
                                                    return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,
                                                      Current_User_Username: widget.username,
                                                      FriendUsername: user.username!,
                                                      Current_User_Usertype: widget.usertype,
                                                    );
                                                  },
                                                  )
                                                  );
                                                }
                                                );
                                              },
                                              itemCount: User_Info_List.length
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

                        SizedBox(
                          height: heightval*0.01,
                        ),

                        Row (
                          children: [

                            CommonButton_loading(label: "Insert Post",
                                onPressed: ()
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Insertpostscreen(username: widget.username, usertype: widget.usertype, jwttoken:widget.jwttoken);
                                    },
                                    )
                                    );
                                },

                              color:Colors.red,
                              textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                              padding: const EdgeInsets.all(12),
                              borderRadius:25.0,
                              width: shortestval*0.35,
                              height: shortestval*0.15,
                              isLoading: isLoadingCont.isloading.value,
                            ),

                            CommonButton_loading(label: "Insert Campaign",
                              onPressed: ()
                              {

                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return InsertcampaignscreenP(username: widget.username, usertype: widget.usertype, jwttoken:widget.jwttoken);
                                },
                                )
                                );
                              },

                              color:Colors.red,
                              textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                              padding: const EdgeInsets.all(12),
                              borderRadius:25.0,
                              width: shortestval*0.35,
                              height: shortestval*0.15,
                              isLoading: isLoadingCont.isloading.value,
                            ),


                          ],
                        ),

                        SizedBox(
                          height: heightval*0.01,
                        ),

                        FutureBuilder<void>(
                          future: Get_Advertisement_Info(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Circular_pro_indicator_Yellow(context);
                            }
                            else if (snapshot.hasError) {
                              // Handle any error from the future
                              return Center(
                                child: Text(
                                  "Error fetching advertisements. Please try again.",
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              );
                            }
                            else if (snapshot.connectionState == ConnectionState.done) {
                              return Ad_Info_List.isEmpty
                                  ? const Center(
                                child: Text("No advertisement data available."),
                              )
                                  : Container(
                                color: Colors.white12,
                                height: heightval * 0.30,
                                width: widthval,
                                child: VxSwiper.builder(
                                  itemCount: Ad_Info_List.length,
                                  autoPlay: true,
                                  enlargeCenterPage: false,  // Disable enlargement effect
                                  viewportFraction: 1.0,    // Each item occupies full width
                                  aspectRatio: 16 / 9,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final ad = Ad_Info_List[index];
                                    return SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Description Text
                                          Text(
                                            ad.adUrl!,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: heightval * 0.02),
                                          // Image converted from Base64 String
                                          Container(
                                            height: heightval * 0.5,
                                            width: widthval,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child:
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.memory(
                                                base64Decode(ad.adPhoto!),
                                                height:heightval*0.05 ,
                                                width: widthval,
                                                fit: BoxFit.fill
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else {
                              return Center(
                                child: Text(
                                  "Please close and reopen app.",
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              );
                            }
                          },
                        ),

                        SizedBox(
                          height: heightval*0.01,
                        ),

                        FutureBuilder<void>(
                          future: Get_Donation_Info(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Circular_pro_indicator_Yellow(context);
                            }
                            else if (snapshot.hasError) {
                              // Handle any error from the future
                              return Center(
                                child: Text(
                                  "Error fetching donation info. Please try again.",
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              );
                            }
                            else if (snapshot.connectionState == ConnectionState.done) {
                              return Donation_Info_List.isEmpty
                                  ? const Center(
                                child: Text("No donation data available."),
                              )
                                  : 
                              Container(
                                width: widthval,
                                height: heightval*0.18,
                                color: Colors.blueGrey,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: Donation_Info_List.length,
                                  itemBuilder: (context, index) {
                                    final donation = Donation_Info_List[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // CircleAvatar to show postId
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.lightGreen,
                                            child: Text(
                                              donation.postId.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height:heightval*0.01),
                                          // Column containing donor username and donate amount
                                          Text(donation.donerUsername.toString(),
                                            style: TextStyle(
                                              fontSize: shortestval*0.05,
                                             fontFamily: semibold
                                            ),
                                          ),
                                          SizedBox(height:heightval*0.01),
                                          // Donate Amount
                                          Text(donation.donateAmount.toString(),
                                            style: TextStyle(
                                              fontSize: shortestval*0.05,
                                             fontFamily: semibold
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else {
                              return Center(
                                child: Text(
                                  "Please close and reopen app.",
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              );
                            }
                          },
                        ),


                        SizedBox(
                          height: heightval*0.01,
                        ),

                        IconButton(onPressed: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QrScannerScreen(
                              usertype: widget.usertype,
                              jwttoken: widget.jwttoken,
                              username: widget.username,
                            )
                            ),
                          );
                        },
                            icon:Icon(Icons.scanner,size: shortestval*0.25,
                            )
                        ),

                      ],
                    )
                ),
              );
          }
          else if(orientation==Orientation.landscape)
          {
            return
              Container(

              );

          }
          else
          {
            return CircularProgressIndicator();
          }
        },
        ),
    );
  }
}
