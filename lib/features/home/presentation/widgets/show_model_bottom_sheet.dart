import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

showModelBottomSheet(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      final stationData = getStationData();
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // علشان ياخد مساحة على قد المحتوى بس
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('نسخ الرابط'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}

Future<List<Map<String, dynamic>>> getStationData() async {
  final stations = FirebaseFirestore.instance.collection('stations');
  final stationSnapshot = await stations.get();

  print('count: ${stationSnapshot.docs.length}');

  for (final doc in stationSnapshot.docs) {
    print('id: ${doc.id} -> ${doc.data()}');
  }

  return stationSnapshot.docs.map((doc) => doc.data()).toList();
}