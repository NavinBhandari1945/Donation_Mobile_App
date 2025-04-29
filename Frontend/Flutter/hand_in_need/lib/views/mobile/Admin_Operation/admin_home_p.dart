import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/styles.dart';
import 'add_advertisement_p.dart';
import 'admin_Update_Password_p.dart';
import 'delete_ad_p.dart';
import 'delete_campaign_p.dart';
import 'delete_post_p.dart';
import 'delete_user_p.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/toast.dart';
import '../home/authentication_home_p.dart';
import '../home/getx_cont/isloading_logout_button_admin.dart';
import 'feedback_screen_p.dart';

//admin home dashboard
class AdminHome extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const AdminHome(
      {super.key,
      required this.username,
      required this.usertype,
      required this.jwttoken});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  final LogoutButton_Loading_Cont =
      Get.put(Isloading_logout_button_admin_screen());
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
    checkJWTExpiation();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
              fontFamily: bold,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.2),
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
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(shortestval, widthval, heightval)
                  : _buildLandscapeLayout(shortestval, widthval, heightval),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
      double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminOption(
              title: "Delete User",
              icon: Icons.person_remove,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Delete_User_P(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            _buildAdminOption(
              title: "Delete Post",
              icon: Icons.post_add_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Delete_Post_P(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            _buildAdminOption(
              title: "Delete Campaign",
              icon: Icons.campaign_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Delete_Campaign_P(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            _buildAdminOption(
              title: "Add Advertisement",
              icon: Icons.add_circle_outline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add_Advertisement_P(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            _buildAdminOption(
              title: "Delete Advertisement",
              icon: Icons.delete_sweep_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Delete_Ad_P(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            _buildAdminOption(
              title: "See Feedback",
              icon: Icons.feedback_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Feedback_Screen_Ui(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            _buildAdminOption(
              title: "Update User Password",
              icon: Icons.lock_reset,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => admin_Update_password_P(
                    usertype: widget.usertype,
                    username: widget.username,
                    jwttoken: widget.jwttoken,
                  ),
                ),
              ),
            ),
            SizedBox(height: shortestval * 0.04),
            _buildLogoutButton(shortestval, widthval),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(
      double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdminOption(
                    title: "Delete User",
                    icon: Icons.person_remove,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Delete_User_P(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                  _buildAdminOption(
                    title: "Delete Post",
                    icon: Icons.post_add_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Delete_Post_P(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                  _buildAdminOption(
                    title: "Delete Campaign",
                    icon: Icons.campaign_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Delete_Campaign_P(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                  _buildAdminOption(
                    title: "Add Advertisement",
                    icon: Icons.add_circle_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Add_Advertisement_P(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdminOption(
                    title: "Delete Advertisement",
                    icon: Icons.delete_sweep_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Delete_Ad_P(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                  _buildAdminOption(
                    title: "See Feedback",
                    icon: Icons.feedback_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Feedback_Screen_Ui(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                  _buildAdminOption(
                    title: "Update User Password",
                    icon: Icons.lock_reset,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => admin_Update_password_P(
                          usertype: widget.usertype,
                          username: widget.username,
                          jwttoken: widget.jwttoken,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: shortestval * 0.04),
                  _buildLogoutButton(shortestval, widthval * 0.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOption(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widthval,
      margin: EdgeInsets.symmetric(vertical: shortestval * 0.02),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Row(
              children: [
                Icon(icon, color: Colors.green[700], size: shortestval * 0.07),
                SizedBox(width: shortestval * 0.04),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: semibold,
                      color: Colors.grey[800],
                      fontSize: shortestval * 0.045,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.grey[600], size: shortestval * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(double shortestval, double width) {
    return Center(
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(
                horizontal: shortestval * 0.1, vertical: shortestval * 0.04),
          ),
          child: Obx(
            () => LogoutButton_Loading_Cont.isloading.value
                ? Circular_pro_indicator_Yellow(context)
                : Text(
                    "Log Out",
                    style: TextStyle(
                      fontFamily: bold,
                      color: Colors.white,
                      fontSize: shortestval * 0.045,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  //logout method to exit from system
  void _logout() async {
    try {
      LogoutButton_Loading_Cont.change_isloadingval(true);
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleting temporary directory success.");
      Toastget().Toastmsg("Logout Success");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthenticationHome()));
    } catch (obj) {
      print("Logout fail. Exception occur.");
      print("${obj.toString()}");
      Toastget().Toastmsg("Logout fail. Try again.");
    } finally {
      LogoutButton_Loading_Cont.change_isloadingval(false);
    }
  }
}
