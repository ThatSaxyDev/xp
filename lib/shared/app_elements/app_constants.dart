import 'package:flutter/material.dart';

double height(BuildContext context){
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context){
  return MediaQuery.of(context).size.width;
}

String baseUrl = 'https://api-retropay.herokuapp.com/api/v1';

const double kItemExtent = 32.0;