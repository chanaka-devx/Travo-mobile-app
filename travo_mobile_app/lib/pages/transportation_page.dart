import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TransportationPage extends StatelessWidget {
  const TransportationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _header(context),
                Expanded(child: _content()),
              ],
            ),
            _bottomAIBar(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: AppColors.textPrimary,
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Transportation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _placesSection(),
          const Divider(height: 24),
          _routeSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _placesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Places you visit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '2 Destinations',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _PlaceCard(
                title: 'Yala National Park',
                subtitle: 'Southern Sri Lanka',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA5X8QjUkNLCMg00ftHnWovTNai-W6-1i44wRdEXVZZF7I1zfHgcxi_SQ-nG4fRDjsO4O0O4f_pLa0oVm-JUpfPVFsSMQNdZX6Jk_2hzJjiZDHH1hC0gT3xUlsCg-v5xR3X5PtCglnkfWVV9rWUGSmBjinJSCAJ7d--tetcrA-FA90AduISZvqyZREvvlnjeF9dWvO_iB94j9CioGosdHrs0JLlgkY7NW3vzdAW2npN0kLoZm6zHd4PtyxEOGlq1arIuUztHUW7OZc',
              ),
              _PlaceCard(
                title: 'Mirissa Beach',
                subtitle: 'Southern Sri Lanka',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBDjZ3BsdtxDLdebcpX5d8jyXoQllW_w7Nmjq2N17tD3O2qGO7k0fHcy0coP9K6bpLE63JH2nAjr0h-LsX1xkhVZ5S7YMS6uxXoqfJuclwiICIxMzHgyhSODqUmb4xB6zzCtyQ7tXySlsZ3kcb_XNWc-4Exmtft1S0mGHTCPoaIA4Hmux7Umm_-NO2B4NASwwB3gaz3TJ8lCswt-e9Wxh5J22k4vPdvXIJo9WO2oK_WTyjI-DYhlNVE77dbNSKPd6kNq1BknSkYyXM',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _routeSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Itinerary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const _RouteItem(title: 'Colombo', subtitle: 'Start Point'),
          const _RouteItem(title: 'Mirissa', subtitle: 'Stay 2 days'),
          const _RouteItem(
            title: 'Yala National Park',
            subtitle: 'Stay 2 days',
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDj7OqO5s9BAzDKvLXYYYLrxF9GHuafT5ETRru0EYstn_6Q70ARHGBB-6MLiW2jkUr-0FeE8EuNLB2H1sJbL41V5MabE_lCZFjnstZs3ZkdJJoNf5dxXWHQ7Pb4zC6-L0n7kRU4yLikpZwxwj6GEMBSFNktDqcz8iGHRvYtacsJjQ_q3-kD2DgcKWUKFnOso_MqJ7FNdLNxqZfCag3fTn_KHrAhVkbHl-5wX0Xfv62jUzI5kTU1czMNqTLwv6gHHTdDGPVXL9ZYwcA',
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAIBar(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Describe changes you want...',
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
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const _PlaceCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 300,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = (constraints.maxHeight * 0.42).clamp(
            105.0,
            135.0,
          );

          return Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.divider),
              color: AppColors.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const _RowField(label: 'Duration', value: '2 Days'),
                          const _RowField(label: 'Priority', value: 'High'),
                          const _RowField(label: 'Budget', value: '\$250'),
                        ],
                      ),
                    ),
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

class _RowField extends StatelessWidget {
  final String label;
  final String value;

  const _RowField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RouteItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
