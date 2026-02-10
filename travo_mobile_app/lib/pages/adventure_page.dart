import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TravoAdventurePage extends StatelessWidget {
  const TravoAdventurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildTimeline()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.surfaceLight,
                  child: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sri Lanka Adventure',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Oct 12 - Oct 24 • 12 Days',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surfaceLight,
            child: const Icon(Icons.share, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        _buildTimelineItem(
          index: '1',
          title: 'Colombo Arrival',
          subtitle: 'Oct 12 - Oct 15 • 3 Nights',
          tag: 'Flight',
          stay: 'Hilton Hotel',
          stayInfo: 'Check-in 3 PM',
          icon: Icons.hotel,
          mapImage:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA8o2AuZ9rX6RorwCZNpmbdkpnduZ4zKgBIcavJqcd0eszDorReta7xe5txeEZgIIdLVcYtjUlepyiv1dcmXooXzfSnX0BmZt0ErW_G2Z1d0OCsAgvfds0wlmV1wsux5Z6mfq2sBVJwUh66wKgoevl8xQ-alDJ0fh2TAwl2v98oE0zjjRmtNmOnRUhJQ3_fGbAwf9FXa1M7oFYSfVTc58LlBvcMFrrjLHec21FkdcW2ZWO3cE8QvjpAmmKa-Sqp_GND5cIAicN1vs',
          mapTagIcon: Icons.location_on,
        ),
        const SizedBox(height: 16),
        _buildTimelineItem(
          index: '2',
          title: 'Galle',
          subtitle: 'Oct 15 - Oct 19 • 4 Nights',
          tag: 'Train',
          stay: 'Galle Fort Hotel',
          stayInfo: '4.8 Rating • Luxury',
          icon: Icons.star,
          iconColor: AppColors.warning,
          mapImage:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDm1yuBYmTDFQXSdJ5oY7adXaSdEprS3H9b7yNhf1y7_Mw3x00_qDGva_Skiyd5rRa9h3U6lvn14dhkfx49cq6hZgNq7cBfk0ak9WeqeBBOIzui84rUaUb_j2RUC6WOMNVdZuuSzgaD2RYlKIPwcn385JP3IAnuWjjCXTaiunUApJvrqctasDDPoXw7idoU4cDnheMlwepmJgKMKMIm-BFY7rG8RpukrHI1yYJegoUusEmfvKNB86lhXHLo8yv7_2OpJIL5JJO3ap4',
          mapTagIcon: Icons.location_on,
        ),
        const SizedBox(height: 16),
        _buildTimelineItem(
          index: '3',
          title: 'Yala Park',
          subtitle: 'Oct 19 - Oct 22 • 3 Nights',
          tag: 'Bus',
          stay: 'Yala Safari Hotel',
          stayInfo: 'Breakfast Included',
          icon: Icons.restaurant,
          mapImage:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDHFLKxxt40evY_6SUhDldGSvg4u2kQLD5NoIGPcCmQwMEzG89kuh8-rHzKH5YKRzkeITCAuGh7r_se4dQClJQQaJ61euxF3QuUPvqCFFiSIoEjdP6-PNBcEzzIIPfxfz6pG8VL48Ed9nq-lKCPlksh3oDHY0SJohpO4GycNQQmfMWSCWltssq9BNrdOkJ6MzIaHI7E6aSpow98cF73wsMoUXxbryDm3NLsIRb68i2HbXnmve9CCk8_lC0J5ewSms2DMTteIRfT3e8',
          mapTagIcon: Icons.location_on,
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Itinerary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight10,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              'Edit Plan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String index,
    required String title,
    required String subtitle,
    required String tag,
    required String stay,
    required String stayInfo,
    required IconData icon,
    Color? iconColor,
    required String mapImage,
    required IconData mapTagIcon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: index == '1'
                  ? AppColors.primary
                  : AppColors.surface,
              foregroundColor: index == '1'
                  ? AppColors.textOnPrimary
                  : AppColors.primary,
              child: Text(
                index,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(width: 2, height: 80, color: AppColors.divider),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight10,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STAY',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stay,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                icon,
                                size: 14,
                                color: iconColor ?? AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                stayInfo,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: iconColor ?? AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                      image: DecorationImage(
                        image: NetworkImage(mapImage),
                        fit: BoxFit.cover,
                        opacity: 0.6,
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.surface.withValues(
                          alpha: 0.7,
                        ),
                        child: Icon(
                          mapTagIcon,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


}
