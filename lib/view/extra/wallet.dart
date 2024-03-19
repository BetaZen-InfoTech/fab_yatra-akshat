import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/extra/withdraw.dart';
import 'package:fabyatra/view/loading.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double wallet = 0;
  String uid = "";
  bool showLoading = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("${GlobalVariable.appType}/project-backend");

  Future<void> getWallet() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;
    setState(() {});

    Stream<DatabaseEvent> stream = ref
        .child("account/user-data/user")
        .child(uid)
        .child("wallet/amount")
        .onValue;

    stream.listen((DatabaseEvent event) async {

      double data = double.parse(event.snapshot.value.toString());

      setState(() {
        wallet = data;
      });

    });
    setState(() {
      showLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Wallet & Account',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff7d2aff),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Icon(
                Icons.account_balance_wallet,
                size: 100,
                color: Color(0xff7d2aff),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Available Balance:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '₹ ${wallet}', // Replace with actual balance
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff7d2aff),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //     primary: Color(0xff7d2aff)
              // ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Withdraw()),
                );
              },
              child: Text('Withdraw Money'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'All Transactions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            showLoading == true
                ? LottieDialog()
                : Expanded(
                    child: TransactionList(),
                  ),
          ],
        ),
      ),
    );
  }


}




class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TransactionItem(
          type: 'Credit',
          detail: 'Received payment from John',
          amount: '₹100.00',
          time: '2 days ago',
        ),
        TransactionItem(
          type: 'Debit',
          detail: 'Paid for groceries',
          amount: '₹50.00',
          time: '4 days ago',
        ),
        // Add more TransactionItems here
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String type;
  final String detail;
  final String amount;
  final String time;

  TransactionItem({
    required this.type,
    required this.detail,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TransactionItem(
          type: 'Credit',
          detail: 'Received payment from John',
          amount: '₹100.00',
          time: '2 days ago',
        ),
        TransactionItem(
          type: 'Debit',
          detail: 'Paid for groceries',
          amount: '₹50.00',
          time: '4 days ago',
        ),
        // Add more TransactionItems here
      ],
    );
  }
}
