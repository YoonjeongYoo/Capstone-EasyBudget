import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptsScreen extends StatefulWidget {
  @override
  _ReceiptsScreenState createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<DateTime, double> _receiptsMap = {};

  @override
  void initState() {
    super.initState();
    _fetchReceipts();
  }

  Future<void> _fetchReceipts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Space').doc('Receipts').collection('Receipts').get();

      Map<DateTime, double> tempMap = {};
      for (var doc in querySnapshot.docs) {
        DateTime date = (doc['pdate'] as Timestamp).toDate();
        double totalCost = doc['totalcost'];
        tempMap[date] = totalCost;
      }

      setState(() {
        _receiptsMap = tempMap;
      });

      //_printReceiptsMap(_receiptsMap);

    } catch (e) {
      print("Error fetching receipts: $e");
    }
  }

  // void _printReceiptsMap(Map<DateTime, double> receiptsMap) {
  //   print("Receipts Map:");
  //   receiptsMap.forEach((date, totalCost) {
  //     print("${date.toLocal()}: \$${totalCost.toStringAsFixed(2)}");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipts'),
      ),
      body: _receiptsMap.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _receiptsMap.length,
        itemBuilder: (context, index) {
          DateTime date = _receiptsMap.keys.elementAt(index);
          double cost = _receiptsMap[date]!;
          return ListTile(
            title: Text('Date: ${date.toLocal()}'),
            subtitle: Text('Total Cost: \$${cost.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}