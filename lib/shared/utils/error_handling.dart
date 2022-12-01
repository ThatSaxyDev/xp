// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:retro_pay_mobile_app/shared/app_elements/app_utils.dart';

// void httpErrorHandle({
//   required http.Response response,
//   required BuildContext context,
// }) {
//   switch (response.statusCode) {
//     case 201:
//       showSnackBar(context, jsonDecode(response.body)['message']);
//       break;
//     case 400:
//       showSnackBar(context, jsonDecode(response.body)['errors']);
//       break;
//     case 500:
//       showSnackBar(context, jsonDecode(response.body)['error']);
//       break;
//     default:
//       showSnackBar(context, response.body);
//   }
// }
