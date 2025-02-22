import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class chatbotScreen extends StatefulWidget {
  const chatbotScreen({super.key});

  @override
  State<chatbotScreen> createState() => _chatbotScreenState();
}

class _chatbotScreenState extends State<chatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late GenerativeModel _model;
  late var _chat;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  void _initializeModel() {
    final apiKey = dotenv.env['API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      // Warn developer/user if key is missing. The underlying SDK may throw if key is empty.
      debugPrint('API_KEY is not set in environment. Add it to your .env file.');
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100),
      systemInstruction: Content.text(
        'You are a helpful assistant for a Library Management System. '
        'Your role is to help users with book recommendations, library information, '
        'and general queries about books and reading. '
        'Always respond in plain text without using any markdown formatting. '
        'Do not use bold (**text**), italic (*text*), headers (#), bullet points, '
        'code blocks, or any other markdown symbols. '
        'Provide clear, conversational responses in regular text only.'
      ),
    );
    _chat = _model.startChat();
  }

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": message});
    });

    try {
      final content = Content.text(message);
      final response = await _chat.sendMessage(content);

      setState(() {
        _messages.add({"sender": "bot", "message": response.text});
      });
    } catch (e) {
      setState(() {
        _messages.add({"sender": "error", "message": e.toString()});
      });
    }
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    bool isUser = msg['sender'] == 'user';
    bool isError = msg['sender'] == 'error';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: isError ? Colors.red[400] : const Color(0xFF26A69A),
              child: Icon(
                isError ? Icons.error_outline : Icons.smart_toy_rounded,
                color: Colors.white,
              ),
            ),
          if (!isUser) const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser 
                    ? const Color(0xFF5E35B1)
                    : isError 
                        ? Colors.red[100]
                        : const Color(0xFFE0F2F1),
                border: Border.all(
                  color: isUser
                      ? const Color(0xFF5E35B1)
                      : isError
                          ? Colors.red[300]!
                          : const Color(0xFF26A69A).withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Text(
                msg['message'],
                style: TextStyle(
                  color: isUser 
                      ? Colors.white
                      : isError 
                          ? Colors.red[900]
                          : Colors.black87,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 10),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Color(0xFF5E35B1),
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'New Conversation',
            onPressed: () {
              setState(() {
                _messages.clear();
                _chat = _model.startChat();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 80,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start a conversation',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ask me about books, recommendations,\nor library information',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(_messages[index]);
                        },
                      ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        onSubmitted: (text) {
                          _sendMessage(text);
                          _controller.clear();
                        },
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _sendMessage(_controller.text);
                          _controller.clear();
                        },
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
