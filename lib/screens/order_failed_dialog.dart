import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';

class OrderFailedDialogue extends StatelessWidget {
  const OrderFailedDialogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 28),
              ),
            ),
            const SizedBox(height: 20),
            const Image(
              image: AssetImage("assets/images/order_failed_image.png"),
              height: 180,
            ),
            const SizedBox(height: 30),
            const AppText(
              text: "Oops! Order Failed",
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            const AppText(
              text: "Something went wrong.\nPlease try again later.",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff7C7C7C),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const AppText(
                text: "Go Back",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
