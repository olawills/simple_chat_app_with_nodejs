import 'package:chat_app/model/chat_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chatMessages = <ChatMessage>[].obs;
  var connectUser = 0.obs;
}
