import 'package:flutter/material.dart';
import 'package:nazra/app/models/complaint_model.dart';
import 'package:nazra/peresentation/widgets/complaint_card.dart';

import 'complaint_details_screen.dart';
class ComplainsScreen extends StatefulWidget {
  const ComplainsScreen({super.key});

  @override
  State<ComplainsScreen> createState() => _ComplainsScreenState();
}

class _ComplainsScreenState extends State<ComplainsScreen> {

  @override
  Widget build(BuildContext context) {
    final complaint = Complaint.dummyData; // ✅ use your dummy data

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(title: const Text("My Complaints")),
      body: ListView.builder(
        itemCount: complaint.length,
        itemBuilder: (context, index) {
          return ComplaintCard(
            complaint: complaint[index],
            onDetailsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComplaintDetailsScreen(complaint: complaint[index]),
                ),
              );            },
          );
        },
      ),
    );
  }
}
