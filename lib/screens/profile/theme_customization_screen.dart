import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/theme.dart';
import 'profile_info_sheet.dart';

/// Theme Customization Screen (Premium Feature)
/// Allows PRO and ELITE users to customize their profile appearance
class ThemeCustomizationScreen extends StatefulWidget {
  final SubscriptionTier currentTier;
  final ProfileTheme? currentTheme;

  const ThemeCustomizationScreen({
    super.key,
    this.currentTier = SubscriptionTier.free,
    this.currentTheme,
  });

  @override
  State<ThemeCustomizationScreen> createState() =>
      _ThemeCustomizationScreenState();
}

class _ThemeCustomizationScreenState extends State<ThemeCustomizationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ProfileTheme _selectedTheme;
  double _glowIntensity = 0.6;
  double _animationSpeed = 1.0;

  // For ELITE custom gradient
  List<Color> _customColors = [
    const Color(0xFF6366F1),
    const Color(0xFF8B5CF6),
  ];

  bool get _isPro =>
      widget.currentTier == SubscriptionTier.pro ||
      widget.currentTier == SubscriptionTier.elite;

  bool get _isElite => widget.currentTier == SubscriptionTier.elite;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme ?? ProfileTheme.defaultTheme;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3000 / _animationSpeed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAnimationSpeed(double speed) {
    setState(() {
      _animationSpeed = speed;
      _animationController.duration =
          Duration(milliseconds: (3000 / speed).round());
      if (_animationController.isAnimating) {
        _animationController
          ..stop()
          ..repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Theme Customization'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveTheme,
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Preview Section
            _buildLivePreview(),

            const SizedBox(height: 24),

            // Theme Selection
            _buildSectionTitle('Choose Theme'),
            _buildThemeGrid(),

            const SizedBox(height: 24),

            // Glow Settings (PRO+)
            if (_isPro) ...[
              _buildSectionTitle('Glow Settings'),
              _buildGlowSettings(),
              const SizedBox(height: 24),
            ],

            // Custom Gradient (ELITE only)
            if (_isElite) ...[
              _buildSectionTitle('Custom Gradient'),
              _buildCustomGradientCreator(),
              const SizedBox(height: 24),
            ],

            // Cover Style
            _buildSectionTitle('Cover Style'),
            _buildCoverStyleOptions(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreview() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Preview Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Live Preview',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _selectedTheme.isAnimated
                        ? Colors.green[100]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _selectedTheme.isAnimated
                            ? Icons.play_circle
                            : Icons.pause_circle,
                        size: 14,
                        color: _selectedTheme.isAnimated
                            ? Colors.green[700]
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedTheme.isAnimated ? 'Animated' : 'Static',
                        style: TextStyle(
                          fontSize: 11,
                          color: _selectedTheme.isAnimated
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Preview Content
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gradient Cover
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: _buildPreviewGradient(),
                      ),
                    );
                  },
                ),

                // Avatar with Glow
                Positioned(
                  bottom: 16,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: _selectedTheme.isAnimated && _isPro
                              ? [
                                  BoxShadow(
                                    color: _selectedTheme.gradientColors[
                                            (_animationController.value *
                                                        _selectedTheme
                                                            .gradientColors
                                                            .length)
                                                    .floor() %
                                                _selectedTheme
                                                    .gradientColors.length]
                                        .withOpacity(_glowIntensity),
                                    blurRadius: 20 * _glowIntensity,
                                    spreadRadius: 4 * _glowIntensity,
                                  ),
                                ]
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.person,
                              size: 40, color: Colors.grey[400]),
                        ),
                      );
                    },
                  ),
                ),

                // Theme name badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedTheme.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Gradient _buildPreviewGradient() {
    final colors = _selectedTheme.gradientColors;
    if (_selectedTheme.isAnimated && _isPro) {
      final offset = _animationController.value;
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        transform: GradientRotation(offset * 2 * math.pi),
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildThemeGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Free Theme
          _buildThemeCategory('Free', [ProfileTheme.defaultTheme], true),

          const SizedBox(height: 16),

          // PRO Themes
          _buildThemeCategory(
            'PRO Themes',
            ProfileTheme.proThemes,
            _isPro,
            badge: 'PRO',
            badgeColor: AppColors.primary,
          ),

          const SizedBox(height: 16),

          // ELITE Themes
          _buildThemeCategory(
            'ELITE Exclusive',
            ProfileTheme.eliteThemes,
            _isElite,
            badge: 'ELITE',
            badgeColor: const Color(0xFFFFD700),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCategory(
    String title,
    List<ProfileTheme> themes,
    bool isUnlocked, {
    String? badge,
    Color? badgeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor?.withOpacity(0.2) ?? Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: badgeColor ?? Colors.grey[600],
                  ),
                ),
              ),
            ],
            if (!isUnlocked) ...[
              const Spacer(),
              Icon(Icons.lock, size: 14, color: Colors.grey[400]),
            ],
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: themes.map((theme) {
              final isSelected = _selectedTheme == theme;
              return GestureDetector(
                onTap: isUnlocked
                    ? () => setState(() => _selectedTheme = theme)
                    : () => _showUpgradeDialog(theme.requiredTier),
                child: Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                      width: isSelected ? 3 : 1,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: theme.gradientColors.take(2).toList(),
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (!isUnlocked)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      if (isSelected)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 4,
                        left: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            theme.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Glow Intensity
          Row(
            children: [
              Icon(Icons.brightness_6, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              const Text(
                'Glow Intensity',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '${(_glowIntensity * 100).round()}%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _glowIntensity,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            activeColor: AppColors.primary,
            onChanged: (value) => setState(() => _glowIntensity = value),
          ),

          const Divider(),

          // Animation Speed
          Row(
            children: [
              Icon(Icons.speed, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              const Text(
                'Animation Speed',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '${_animationSpeed.toStringAsFixed(1)}x',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _animationSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 6,
            activeColor: AppColors.primary,
            onChanged: _updateAnimationSpeed,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomGradientCreator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              const Text(
                'Create Your Own Gradient',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Color pickers
          Row(
            children: [
              _buildColorPicker(0),
              const SizedBox(width: 16),
              _buildColorPicker(1),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _addGradientColor,
                icon: Icon(Icons.add_circle, color: AppColors.primary),
                tooltip: 'Add color',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Preview
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(colors: _customColors),
            ),
          ),

          const SizedBox(height: 12),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyCustomGradient,
              child: const Text('Apply Custom Gradient'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(int index) {
    if (index >= _customColors.length) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showColorPickerDialog(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _customColors[index],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: index > 1
            ? IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                onPressed: () => _removeGradientColor(index),
              )
            : null,
      ),
    );
  }

  Widget _buildCoverStyleOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildCoverOption(
            'Solid Color',
            'Simple single color background',
            Icons.square,
            SubscriptionTier.free,
          ),
          _buildCoverOption(
            'Glow Themes',
            'Animated gradient backgrounds',
            Icons.auto_awesome,
            SubscriptionTier.pro,
          ),
          _buildCoverOption(
            'Custom Gradient',
            'Create your own unique gradient',
            Icons.gradient,
            SubscriptionTier.elite,
          ),
        ],
      ),
    );
  }

  Widget _buildCoverOption(
    String title,
    String subtitle,
    IconData icon,
    SubscriptionTier requiredTier,
  ) {
    final isUnlocked = widget.currentTier.index >= requiredTier.index;
    final tierLabel = requiredTier == SubscriptionTier.free
        ? 'FREE'
        : requiredTier == SubscriptionTier.pro
            ? 'PRO'
            : 'ELITE';
    final tierColor = requiredTier == SubscriptionTier.free
        ? Colors.grey
        : requiredTier == SubscriptionTier.pro
            ? AppColors.primary
            : const Color(0xFFFFD700);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: tierColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: tierColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: tierColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isUnlocked) Icon(Icons.lock, size: 12, color: tierColor),
              if (!isUnlocked) const SizedBox(width: 4),
              Text(
                tierLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: tierColor,
                ),
              ),
            ],
          ),
        ),
        onTap: isUnlocked ? () {} : () => _showUpgradeDialog(requiredTier),
      ),
    );
  }

  void _showUpgradeDialog(SubscriptionTier requiredTier) {
    final tierName = requiredTier == SubscriptionTier.pro ? 'PRO' : 'ELITE';
    final price = requiredTier == SubscriptionTier.pro ? '₹299' : '₹599';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              requiredTier == SubscriptionTier.elite
                  ? Icons.diamond
                  : Icons.star,
              color: requiredTier == SubscriptionTier.elite
                  ? const Color(0xFFFFD700)
                  : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text('Upgrade to $tierName'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unlock this feature and more with $tierName subscription!',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              'Starting at $price/month',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to subscription page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription page coming soon!'),
                ),
              );
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(int index) {
    // Simple color picker using predefined colors
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SizedBox(
          width: 280,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _customColors[index] = color;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: _customColors[index] == color
                        ? Border.all(color: Colors.black, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _addGradientColor() {
    if (_customColors.length < 4) {
      setState(() {
        _customColors.add(Colors.white);
      });
    }
  }

  void _removeGradientColor(int index) {
    if (_customColors.length > 2) {
      setState(() {
        _customColors.removeAt(index);
      });
    }
  }

  void _applyCustomGradient() {
    // Create a custom theme with user-selected colors
    final customTheme = ProfileTheme(
      name: 'Custom',
      gradientColors: List.from(_customColors),
      requiredTier: SubscriptionTier.elite,
      isAnimated: true,
    );
    setState(() {
      _selectedTheme = customTheme;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom gradient applied!')),
    );
  }

  void _saveTheme() {
    // TODO: Save theme to user profile via provider
    Navigator.pop(context, _selectedTheme);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme "${_selectedTheme.name}" saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
