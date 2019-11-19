
import 'package:flutter/cupertino.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour});

  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['data'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      name: name,
      ratePerHour: ratePerHour
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}