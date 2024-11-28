import 'package:flutter/cupertino.dart';

class FeedbackModel {
  final String name;
  final String job;
  final String photo;
  final String message;
  final Alignment alignment;

  const FeedbackModel({
    this.name = "",
    this.photo = "",
    this.job = "",
    this.message = "",
    this.alignment = Alignment.bottomCenter,
  });
}
