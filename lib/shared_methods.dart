/*
 * All shared dart methods
 */

//Returns a readable date
import 'package:intl/intl.dart';

String getDisplayTime(String timestamp) {
  String val = "";

  //Calculate the date
  DateTime dateTime = DateTime.parse(timestamp);
  Duration diff = DateTime.now().difference(dateTime);

  if(diff.inDays > 7) {
    val = DateFormat.yMd().format(dateTime);
  } else if (diff.inDays >= 1) {
    val = "${diff.inDays} d";
  } else if(diff.inHours >= 1) {
    val = "${diff.inHours} hr";
  } else if(diff.inMinutes >= 1) {
    val = "${diff.inMinutes} min";
  } else {
    val = "${diff.inSeconds} sec";
  }
  return val;
}
