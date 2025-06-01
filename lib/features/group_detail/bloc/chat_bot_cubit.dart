import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/models/message_model.dart';
import 'package:group_expense_management/services/gemini_service.dart';

class ChatBotCubit extends Cubit<int> {
  ChatBotCubit(this.cubit) : super(0);

  List<MessageModel> messages = [];
  final TextEditingController controller = TextEditingController();
  late final GroupDetailCubit cubit;

  initData() {}

  addMessage(MessageModel v) {
    messages.add(v);
    EMIT();
  }

  sendMessage() async {
    if (controller.text.isEmpty) return;
    final messageSend = MessageModel(
      content: controller.text,
      date: DateTime.now(),
      isMe: true,
      enable: true,
    );
    addMessage(messageSend);
    final prompt = GeminiService.createPrompt(
        controller.text,
        cubit.transactions ?? [],
        cubit.wallets ?? [],
        cubit.budgets ?? [],
        cubit.budgetDetails ?? [],
        cubit.categories ?? [],
        [cubit.group],
        cubit.savings ?? [],
        cubit.listUser);
    final response = await GeminiService().getChatResponse(prompt);
    final messageReceive = MessageModel(
      content: response,
      date: DateTime.now(),
      isMe: false,
      enable: true);
    addMessage(messageReceive);
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
