import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/helpers/column_with_seprator.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/styles/colors.dart';

import 'account_item.dart';

class AccountScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final username = user?.displayName ?? "User";

    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: AppText(
                  text: "Hello, $username 👋",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: AppText(
                  text: "Welcome back to your account.",
                  fontSize: 16,
                  color: Color(0xff7C7C7C),
                ),
              ),
              SizedBox(height: 25),
              Column(
                children: getChildrenWithSeperator(
                  widgets: accountItems.map((e) {
                    return getAccountItemWidget(e);
                  }).toList(),
                  seperator: Divider(thickness: 1),
                ),
              ),
              SizedBox(height: 20),
              logoutButton(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 0,
          backgroundColor: Color(0xffF2F3F2),
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                "assets/icons/account_icons/logout_icon.svg",
              ),
            ),
            Text(
              "Log Out",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            Container(),
          ],
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }

  Widget getAccountItemWidget(AccountItem accountItem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(accountItem.iconPath),
          ),
          SizedBox(width: 20),
          Text(
            accountItem.label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
