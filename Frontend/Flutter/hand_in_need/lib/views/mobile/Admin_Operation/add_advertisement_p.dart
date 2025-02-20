import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add_Advertisement_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Add_Advertisement_P({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Add_Advertisement_P> createState() => _Add_Advertisement_PState();
}

class _Add_Advertisement_PState extends State<Add_Advertisement_P> {
  final Ad_Url_Cont=TextEditingController();
  @override
  void initState() {
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async {
    try {
      print("check jwt called");
      int result = await checkJwtToken_initistate_admin(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0)
      {
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
      print("Exception caught while verifying jwt for admin delete campaign screen.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Delete_Campaign({required String Campaign_Id})async
  {
    try {
      // const String url = "http://10.0.2.2:5074/api/Home/getpostinfo";
      const String url = "http://192.168.1.65:5074/api/Admin_Task_/delete_campaign";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> Body_Dict =
      {
        "Id": Campaign_Id,
      };
      final response = await http.post(Uri.parse(url), headers: headers,body: json.encode(Body_Dict));
      if (response.statusCode == 200)
      {
        print("Delete campaign success.");
        return 1;
      }
      else
      {
        print("Delete campaign fail.");
        return 2;
      }
    } catch (obj)
    {
      print("Exception caught while deleting campaign.");
      print(obj.toString());
      return 0;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
