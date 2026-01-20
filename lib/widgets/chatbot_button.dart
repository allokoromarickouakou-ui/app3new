
import 'package:flutter/material.dart';
import 'package:APP3/state/app_state.dart';
import 'package:APP3/api/api_client.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ChatbotButton extends StatelessWidget {
  const ChatbotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showChatbotDialog(context);
      },
      backgroundColor: Colors.blue[600],
      child: const Icon(Icons.chat_bubble, color: Colors.white),
    );
  }

  void _showChatbotDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatbotContainer(),
    );
  }
}

class ChatbotContainer extends StatefulWidget {
  const ChatbotContainer({super.key});

  @override
  State<ChatbotContainer> createState() => _ChatbotContainerState();
}

class _ChatbotContainerState extends State<ChatbotContainer> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ApiClient _apiClient = ApiClient(); // Utilisation du client intelligent
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      "text": "Bonjour Sophie ! Je suis Dr. RespirIA. Comment puis-je vous aider ?",
      "isMe": false
    });
  }

  Future<void> _callBackend(String text) async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.dio.post(
        "/chatbot/chat/",
        data: {
          "message": text,
          "profile": AppState.hideCrises ? "prevention" : "asthmatique",
        },
      );

      if (mounted) {
        setState(() {
          _messages.add({
            "text": response.data['response'] ?? response.data['reply'] ?? "J'ai bien reçu votre message.",
            "isMe": false
          });
        });
      }
    } on DioException catch (e) {
      String errorMsg = "Erreur de connexion.";
      if (e.response?.statusCode == 401) errorMsg = "Session expirée. Reconnectez-vous.";
      if (mounted) {
        setState(() {
          _messages.add({"text": errorMsg, "isMe": false});
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _isLoading) return;
    setState(() => _messages.add({"text": text, "isMe": true}));
    _controller.clear();
    _callBackend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy, color: Colors.white),
                const SizedBox(width: 12),
                const Text('Dr. RespirIA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (_isLoading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _ChatBubble(message: _messages[index]["text"], isMe: _messages[index]["isMe"]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: 'Posez votre question...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: _isLoading ? Colors.grey : Colors.blue[600]),
                  onPressed: _isLoading ? null : () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  const _ChatBubble({required this.message, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message),
      ),
    );
  }
}
