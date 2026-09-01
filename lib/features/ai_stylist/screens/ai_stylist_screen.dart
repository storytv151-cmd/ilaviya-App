import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/home/models/product_model.dart';
import 'package:my_flutter_app/features/home/widgets/product_card.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final Product? recommendedProduct;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.recommendedProduct,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// AI Fashion Stylist & Virtual Consultant Screen ("AI Valu").
class AiStylistScreen extends StatefulWidget {
  const AiStylistScreen({super.key});

  @override
  State<AiStylistScreen> createState() => _AiStylistScreenState();
}

class _AiStylistScreenState extends State<AiStylistScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Namaste! ✨ I am your ILAVIYA Royal AI Stylist.\n\nTell me about your upcoming occasion, preferred colors, or fabric, and I will curate the perfect couture look for you!',
      isUser: false,
    ),
  ];

  final List<String> _quickPrompts = [
    '👗 Saree for Grand Reception',
    '👑 Royal Bridal Lehenga',
    '✨ Lightweight Festive Kurti',
    '💎 Matching Jewellery Suggestions',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text.trim(), isUser: true));
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Simulate smart AI Stylist response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      Product? rec;
      String reply = '';

      final lower = text.toLowerCase();
      if (lower.contains('saree') || lower.contains('reception')) {
        rec = Product.sampleProducts[0];
        reply = 'For a grand evening reception, nothing surpasses our pure handcrafted Royal Banarasi Katan Silk Saree in deep burgundy with gold zari weaves. Here is the curated piece for you:';
      } else if (lower.contains('bridal') || lower.contains('lehenga') || lower.contains('wedding')) {
        rec = Product.sampleProducts[1];
        reply = 'For a wedding celebration, our Heritage Zardozi Embroidered Bridal Lehenga in royal velvet is handcrafted to perfection. Pair it with antique kundan choker:';
      } else if (lower.contains('jewellery') || lower.contains('necklace')) {
        rec = Product.sampleProducts[4];
        reply = 'To complement royal ethnic attire, our handcrafted Kundan & Pearl Heritage Temple Choker Set adds timeless regal elegance:';
      } else {
        rec = Product.sampleProducts[2];
        reply = 'Based on your preference, here is our top-rated festive ensemble with gold threadwork:';
      }

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: reply,
          isUser: false,
          recommendedProduct: rec,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: SplashTheme.goldGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF111111)),
            ),
            const SizedBox(width: 8),
            const Text(
              'ILAVIYA AI STYLIST',
              style: TextStyle(
                color: Color(0xFF11141A),
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Prompts Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: _quickPrompts.map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(
                        prompt,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF141720),
                        ),
                      ),
                      backgroundColor: SplashTheme.goldSelectedBg,
                      side: const BorderSide(color: Color(0xFFE8D5A3), width: 0.8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: () => _sendMessage(prompt),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Message Stream
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: SplashTheme.goldPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AI Stylist is curating your look...',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: SplashTheme.goldDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: const Color(0xFFECEFF3), width: 1)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(fontSize: 13.5, color: Color(0xFF141720)),
                        decoration: const InputDecoration(
                          hintText: 'Ask stylist: e.g. Suggest outfit for sangeet...',
                          hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF8C93A4)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_textController.text),
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        gradient: SplashTheme.goldGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: SplashTheme.goldPrimary.withValues(alpha: 0.35),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, color: Color(0xFF111111), size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF11141A),
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomRight: const Radius.circular(2),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.4),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  topLeft: const Radius.circular(2),
                ),
                border: Border.all(color: const Color(0xFFEAEFF5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: Color(0xFF141720),
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
            ),

            if (msg.recommendedProduct != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 250,
                child: ProductCard(
                  product: msg.recommendedProduct!,
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${msg.recommendedProduct!.title} added to bag!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
