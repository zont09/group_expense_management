import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/features/group_detail/bloc/chat_bot_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:intl/intl.dart';

class ChatBotView extends StatelessWidget {
  const ChatBotView({super.key, required this.cubitDt});

  final GroupDetailCubit cubitDt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBotCubit(cubitDt),
      child: BlocBuilder<ChatBotCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<ChatBotCubit>(c);
          return Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.all(12),
                      itemCount: cubit.messages.length,
                      itemBuilder: (context, index) {
                        final msg = cubit.messages[cubit.messages.length - 1 - index];
                        if (!msg.enable) return SizedBox.shrink();
                        return Align(
                          alignment:
                          msg.isMe ? Alignment.centerRight : Alignment
                              .centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(maxWidth: 280),
                            decoration: BoxDecoration(
                              color: msg.isMe ? Colors.blue[100] : Colors
                                  .grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  msg.content,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat('HH:mm').format(msg.date),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cubit.controller,
                            decoration: InputDecoration(
                              hintText: "Nhập tin nhắn...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: cubit.sendMessage,
                        )
                      ],
                    ),
                  )
                ],
              ),
          );
        },
      ),
    );
  }
}
