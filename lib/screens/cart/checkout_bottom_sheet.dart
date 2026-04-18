import 'package:flutter/material.dart';
import 'package:grocery_app/screens/location_picker_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import '../order_failed_dialog.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/screens/cart_provider.dart';
import 'package:grocery_app/screens/order_accepted_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/app_order.dart' as model_order;
import 'dart:convert';

class CheckoutBottomSheet extends StatefulWidget {
  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  String selectedPayment = "";
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalCost = cartProvider.totalPrice;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              AppText(
                text: "Checkout",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, size: 25),
              ),
            ],
          ),
          SizedBox(height: 45),
          Divider(),
          GestureDetector(
            onTap: _selectLocation,
            child: checkoutRow(
              "Delivery",
              trailingText: _selectedLocation != null
                  ? "Location Selected"
                  : "Select Location",
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: showPaymentOptions,
            child: checkoutRow(
              "Payment",
              trailingText:
                  selectedPayment.isEmpty ? "Select Payment" : selectedPayment,
            ),
          ),
          Divider(),
          checkoutRow("Promo Code", trailingText: "Pick Discount"),
          Divider(),
          checkoutRow(
            "Total Cost",
            trailingText: "\$${totalCost.toStringAsFixed(2)}",
          ),
          Divider(),
          SizedBox(height: 30),
          termsAndConditionsAgreement(context),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: AppButton(
              label: "Place Order",
              padding: EdgeInsets.symmetric(vertical: 25),
              onTap: onPlaceOrderClicked,
            ),
          ),
        ],
      ),
    );
  }

  void _selectLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          onLocationPicked: (LatLng location) {
            setState(() {
              _selectedLocation = location;
            });
          },
        ),
      ),
    );
  }

  void onPlaceOrderClicked() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    // Check if any required data is missing
    if (selectedPayment.isEmpty || _selectedLocation == null || cartProvider.items.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => OrderFailedDialogue(),
      );
      return;
    }

    if (user == null) return;

    final order = model_order.Order(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.uid,
      products: cartProvider.toMap(),
      totalCost: cartProvider.totalPrice,
      location: jsonEncode({
        "lat": _selectedLocation!.latitude,
        "lng": _selectedLocation!.longitude,
      }),
      paymentMethod: selectedPayment,
      createdAt: DateTime.now().toIso8601String(),
    );

    final orderMap = order.toMap();
    print("🛒 Order Data: $orderMap");

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(order.orderId)
          .set(orderMap);

      cartProvider.clearCart();

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderAcceptedScreen(),
        ),
      );
    } catch (e) {
      print("🔥 Firestore Error: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) => OrderFailedDialogue(),
      );
    }
  }

  void showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/images/bkash_logo.png',
                  width: 40,
                ),
                title: Text('bKash'),
                onTap: () {
                  setState(() {
                    selectedPayment = "bKash";
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Credit / Debit Card'),
                onTap: () {
                  setState(() {
                    selectedPayment = "Card";
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.money),
                title: Text('Cash on Delivery'),
                onTap: () {
                  setState(() {
                    selectedPayment = "Cash";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget checkoutRow(String label, {String? trailingText, Widget? trailingWidget}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          AppText(
            text: label,
            fontSize: 18,
            color: Color(0xFF7C7C7C),
            fontWeight: FontWeight.w600,
          ),
          Spacer(),
          trailingText == null
              ? (trailingWidget ?? Container())
              : AppText(
                  text: trailingText,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'By placing an order you agree to our',
        style: TextStyle(
          color: Color(0xFF7C7C7C),
          fontSize: 14,
          fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: " Terms",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: " And"),
          TextSpan(
            text: " Conditions",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
