import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/explore_categories_data.dart';

class ExploreCategoryPage extends StatefulWidget {
  final ExploreCategoryData categoryData;

  const ExploreCategoryPage({
    super.key,
    required this.categoryData,
  });

  @override
  State<ExploreCategoryPage> createState() => _ExploreCategoryPageState();
}

class _ExploreCategoryPageState extends State<ExploreCategoryPage> {
  final List<ExploreItem> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildSection1(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.32;

    return Stack(
      children: [
        SizedBox(
          height: headerHeight,
          width: double.infinity,
          child: Image.network(
            widget.categoryData.headerImageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: headerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(
                    Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      _circleBtn(Icons.share, onTap: () {}),
                      const SizedBox(width: 10),
                      _circleBtn(Icons.favorite_border, onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.categoryData.headerTitle,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(_getCategoryIcon(), color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    widget.categoryData.headerSubtitle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon() {
    switch (widget.categoryData.categoryName) {
      case 'Food':
        return Icons.restaurant;
      case 'Stays':
        return Icons.bed;
      case 'Activities':
        return Icons.kayaking;
      case 'Transport':
        return Icons.commute;
      default:
        return Icons.explore;
    }
  }

  Widget _circleBtn(IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.categoryData.section1Title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.categoryData.section1Items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = widget.categoryData.section1Items[index];
              final isSelected = _selectedItems.contains(item);
              return _itemCard(
                item,
                isSelected,
              );
            },
          ),
        ),
        if (_selectedItems.isNotEmpty) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Selected Options (${_selectedItems.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedItems.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = _selectedItems[index];
                return _selectedItemCard(item);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _itemCard(ExploreItem item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedItems.remove(item);
          } else {
            _selectedItems.add(item);
          }
        });
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    item.imageUrl,
                    height: 120,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(item.rating.toString()),
                const Spacer(),
                if (item.priceRange != null && item.priceRange!.isNotEmpty)
                  Text(item.priceRange!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedItemCard(ExploreItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItems.remove(item);
        });
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    item.imageUrl,
                    height: 120,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 120,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(item.rating.toString()),
                const Spacer(),
                if (item.priceRange != null && item.priceRange!.isNotEmpty)
                  Text(item.priceRange!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.mic_outlined, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ask AI...',
                  hintStyle: const TextStyle(color: AppColors.textDisabled),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: AppColors.textOnPrimary, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
