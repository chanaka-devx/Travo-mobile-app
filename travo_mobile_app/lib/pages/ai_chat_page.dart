import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hello! I've found some great spots for your trip to Sri Lanka. Would you like to explore the southern coast?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ChatMessage(
      text:
          "Yes, definitely! I want to visit some beaches and maybe see some wildlife.",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
    ),
    ChatMessage(
      text:
          "Perfect choice! Here is a suggested itinerary covering the best beaches and Yala National Park:",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 13)),
      destinations: ["Mirissa", "Galle", "Yala"],
    ),
    ChatMessage(
      text: "That looks amazing. Can you recommend hotels in Galle?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = _latestDestinations();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "AI Assist",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Timestamp
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Today, ${TimeOfDay.now().format(context)}",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              // Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),

              // Action Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recommendations');
                  },
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text("See Recommendations"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),

              // Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight10,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.mic,
                          color: AppColors.primary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: "Ask anything...",
                            hintStyle: TextStyle(
                              color: AppColors.textDisabled,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.textOnPrimary,
                          size: 20,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          if (destinations.isNotEmpty)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height * 0.28,
              child: _buildDestinationDots(destinations),
            ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const SharedBottomNavBar(activeRoute: '/ai-chat'),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: message.isUser ? 40 : 0, // Add left padding for user messages
        right: message.isUser ? 0 : 80, // Add right padding only for AI messages
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // Avatar for AI messages
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.smart_toy, size: 18, color: AppColors.accent),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(child: _buildMessageBubble(message)),

          // Avatar for user messages
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1607746882042-944635dfe10e?fit=crop&w=64&h=64",
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Column(
      crossAxisAlignment: message.isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(message.isUser ? 20 : 0),
              topRight: Radius.circular(message.isUser ? 0 : 20),
              bottomLeft: const Radius.circular(20),
              bottomRight: const Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              if (message.destinations != null &&
                  message.destinations!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildDestinationList(message.destinations!),
              ],
            ],
          ),
        ),
        if (!message.isUser)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.search, size: 18),
                  color: AppColors.textSecondary,
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                if (message.destinations != null)
                  IconButton(
                    icon: const Icon(Icons.print, size: 18),
                    color: AppColors.textSecondary,
                    onPressed: () {},
                    padding: const EdgeInsets.only(left: 8),
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDestinationList(List<String> destinations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(destinations.length, (index) {
        String description = "";
        if (destinations[index] == "Mirissa") {
          description = "(Whale watching)";
        } else if (destinations[index] == "Galle") {
          description = "(Historic Fort)";
        } else if (destinations[index] == "Yala") {
          description = "(Safari)";
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            "• ${index + 1}. ${destinations[index]} $description",
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDestinationDots(List<String> destinations) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: destinations.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isActive = index == destinations.length - 1;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              _showDestinationDetails(destinations, index);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.textDisabled.withValues(alpha: 0.4),
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDestinationDetails(List<String> destinations, int selectedIndex) {
    // Unfocus any focused widget to prevent keyboard from appearing
    FocusScope.of(context).unfocus();
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
            padding: EdgeInsets.only(
              right: 28,
              top: MediaQuery.of(context).size.height * 0.28,
            ),
            child: Material(
              color: Colors.transparent,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: destinations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final destination = entry.value;
                      final isSelected = index == selectedIndex;
                      
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/adventure');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.primary 
                                : Colors.transparent,
                            borderRadius: index == 0 && index == destinations.length - 1
                                ? BorderRadius.circular(16)
                                : index == 0
                                    ? const BorderRadius.vertical(top: Radius.circular(16))
                                    : index == destinations.length - 1
                                        ? const BorderRadius.vertical(bottom: Radius.circular(16))
                                        : BorderRadius.zero,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                destination,
                                style: TextStyle(
                                  color: isSelected 
                                      ? AppColors.textOnPrimary 
                                      : AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: isSelected 
                                      ? FontWeight.w700 
                                      : FontWeight.w600,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.textOnPrimary,
                                  size: 12,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // Ensure keyboard stays hidden after popup closes
      FocusScope.of(context).unfocus();
    });
  }

  List<String> _latestDestinations() {
    for (int index = _messages.length - 1; index >= 0; index--) {
      final destinations = _messages[index].destinations;
      if (destinations != null && destinations.isNotEmpty) {
        return destinations;
      }
    }
    return [];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                "I'd be happy to help! Let me find the best hotels in Galle for you.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// ===== CHAT MESSAGE MODEL =====
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? destinations;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.destinations,
  });
}
