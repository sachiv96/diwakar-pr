import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/custom_button.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final Set<String> _selectedInterests = {};
  static const int _minRequired = 3;

  final List<InterestOption> _interests = [
    InterestOption(id: 'react', icon: '⚛️', title: 'React'),
    InterestOption(id: 'python', icon: '🐍', title: 'Python'),
    InterestOption(id: 'data_science', icon: '📊', title: 'Data Science'),
    InterestOption(id: 'ai_ml', icon: '🤖', title: 'AI/ML'),
    InterestOption(id: 'cloud', icon: '☁️', title: 'Cloud'),
    InterestOption(id: 'mobile', icon: '📱', title: 'Mobile'),
    InterestOption(id: 'cybersecurity', icon: '🔐', title: 'Cyber Security'),
    InterestOption(id: 'game_dev', icon: '🎮', title: 'Game Dev'),
    InterestOption(id: 'finance', icon: '📈', title: 'Finance'),
    InterestOption(id: 'dsa', icon: '💻', title: 'DSA'),
    InterestOption(id: 'ui_ux', icon: '🎨', title: 'UI/UX Design'),
    InterestOption(id: 'content', icon: '📝', title: 'Content'),
  ];

  void _toggleInterest(String interestId) {
    setState(() {
      if (_selectedInterests.contains(interestId)) {
        _selectedInterests.remove(interestId);
      } else {
        _selectedInterests.add(interestId);
      }
    });
  }

  void _continue() {
    if (_selectedInterests.length >= _minRequired) {
      // TODO: Save interests to user profile/preferences
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _selectedInterests.length >= _minRequired;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Title
              Text(
                'What do you want to learn?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select minimum $_minRequired topics',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),

              // Interest grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _interests.length,
                  itemBuilder: (context, index) {
                    final interest = _interests[index];
                    final isSelected = _selectedInterests.contains(interest.id);
                    return _buildInterestCard(interest, isSelected);
                  },
                ),
              ),

              // Selected count indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isValid
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isValid ? Icons.check_circle : Icons.info_outline,
                          size: 18,
                          color:
                              isValid ? AppColors.success : AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedInterests.length} selected',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isValid ? AppColors.success : AppColors.primary,
                          ),
                        ),
                        if (!isValid) ...[
                          Text(
                            ' (need ${_minRequired - _selectedInterests.length} more)',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: CustomButton(
                  text: 'Continue',
                  onPressed: isValid ? _continue : null,
                  width: double.infinity,
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestCard(InterestOption interest, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleInterest(interest.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    interest.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    interest.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Checkmark indicator
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InterestOption {
  final String id;
  final String icon;
  final String title;

  InterestOption({
    required this.id,
    required this.icon,
    required this.title,
  });
}
