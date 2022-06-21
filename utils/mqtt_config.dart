
import 'dart:math';
///mqtt setting
const mqttbroker = 'iot.gotcash.me';
// const topic = 'ime/joTeam/#';
// const single_topic = 'ime/joTeam/00001';
const port = 1883;
const clientID = '';
const mqtt_username = 'sayhong';
const mqtt_password = 'HoolyHi168888';
 String myid = getUid();
// var pongCount = 0;
// Pong counter
getUid() {
  String s = '';
  var randomList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  var randomNumber;
  Random random = new Random();
  for (int i = 0; i < 9; i++) {
    randomNumber = random.nextInt(10);
    s += (randomList[randomNumber]);
  }
  return s;
}
