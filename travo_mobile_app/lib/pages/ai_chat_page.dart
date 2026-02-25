import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';
import '../core/services/trip_data_service.dart';
import '../data/recommendations_data.dart';
import '../data/adventure_data.dart';
import 'place_details_page.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage>
    with SingleTickerProviderStateMixin {
  static const Duration _scrollAnimationDuration = Duration(milliseconds: 300);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _locationGlowController;
  late final Animation<double> _locationGlowAnimation;
  bool _isDestinationSheetOpen = false;
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
  void initState() {
    super.initState();
    _locationGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _locationGlowAnimation = CurvedAnimation(
      parent: _locationGlowController,
      curve: Curves.easeInOut,
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    if (shouldExit == true) {
      SystemNavigator.pop();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tripService = TripDataService();
    final tripDestinations = tripService.hasCurrentTrip ? tripService.currentTripItems : <TripItem>[];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop(context);
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppColors.textOnPrimary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "AI Assist",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [],
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
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showRecommendationsOverlay();
                        },
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text('See Recommendations'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accent,
                          side: const BorderSide(color: AppColors.accent),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedBuilder(
                      animation: _locationGlowAnimation,
                      builder: (context, child) {
                        final glowStrength = tripDestinations.isEmpty
                            ? 0.0
                            : _locationGlowAnimation.value;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: glowStrength == 0
                                ? []
                                : [
                                    BoxShadow(
                                      color: AppColors.error.withValues(
                                        alpha: 0.35 * glowStrength,
                                      ),
                                      blurRadius: 10 + (18 * glowStrength),
                                      spreadRadius: 1 + (2 * glowStrength),
                                    ),
                                  ],
                          ),
                          child: child,
                        );
                      },
                      child: Material(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.location_on),
                          color: AppColors.error,
                          onPressed: tripDestinations.isEmpty
                              ? null
                              : () {
                                  if (_isDestinationSheetOpen &&
                                      Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                    return;
                                  }
                                  _showDestinationPicker(tripDestinations);
                                },
                          tooltip: 'Selected places',
                        ),
                      ),
                    ),
                  ],
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
                        icon: const Icon(Icons.mic, color: AppColors.primary),
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
                            hintStyle: TextStyle(color: AppColors.textDisabled),
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
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const SharedBottomNavBar(activeRoute: '/ai-chat'),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: message.isUser ? 40 : 0, // Add left padding for user messages
        right: message.isUser
            ? 0
            : 80, // Add right padding only for AI messages
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            "• ${index + 1}. ${destinations[index]}",
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

  void _showDestinationPicker(List<TripItem> destinations) {
    if (_isDestinationSheetOpen) return;
    _isDestinationSheetOpen = true;
    FocusScope.of(context).unfocus();

    final tripService = TripDataService();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected places - ${tripService.currentTripName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        color: AppColors.textSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: destinations.length,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1, color: AppColors.divider);
                  },
                  itemBuilder: (context, index) {
                    final destination = destinations[index];

                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TravoPlaceDetailsPage(
                              title: destination.title,
                              location: destination.location,
                              imageUrl: destination.mapImage,
                              rating: 4.5,
                            ),
                          ),
                        );
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(destination.mapImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        destination.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${destination.location} • ${destination.tag}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.textDisabled,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (!mounted) return;
      _isDestinationSheetOpen = false;
      FocusScope.of(context).unfocus();
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });

    _messageController.clear();

    _scrollToBottom(delay: const Duration(milliseconds: 100));

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
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

      _scrollToBottom();
    });
  }

  void _scrollToBottom({Duration delay = Duration.zero}) {
    if (!_scrollController.hasClients) return;
    Future.delayed(delay, () {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: _scrollAnimationDuration,
        curve: Curves.easeOut,
      );
    });
  }

  void _showRecommendationsOverlay() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _RecommendationsBottomSheet(),
    );
  }

  @override
  void dispose() {
    _locationGlowController.dispose();
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

// ===== RECOMMENDATIONS BOTTOM SHEET =====
class _RecommendationsBottomSheet extends StatefulWidget {
  const _RecommendationsBottomSheet();

  @override
  State<_RecommendationsBottomSheet> createState() =>
      _RecommendationsBottomSheetState();
}

class _RecommendationsBottomSheetState
    extends State<_RecommendationsBottomSheet> {
  bool _isDismissing = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent <= 0.3 && !_isDismissing && mounted) {
          _isDismissing = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.1,
        maxChildSize: 0.88,
        snap: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top Picks for You',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Based on your recent interests',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.surfaceLight,
                        child: const Icon(
                          Icons.tune,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 4 / 5,
                    ),
                    itemCount: recommendationsData.length,
                    itemBuilder: (context, index) =>
                        _RecommendationCard(item: recommendationsData[index]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ===== RECOMMENDATION CARD =====
class _RecommendationCard extends StatelessWidget {
  final RecommendationItem item;

  const _RecommendationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravoPlaceDetailsPage(
              title: item.title,
              location: item.location,
              imageUrl: item.imageUrl,
              rating: item.rating,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: AppColors.textPrimary.withValues(
                      alpha: 0.25,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
