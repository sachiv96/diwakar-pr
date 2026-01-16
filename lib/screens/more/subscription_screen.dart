import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            const Text(
              '💎 Upgrade to Pro',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock your full potential',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),

            // Billing Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggleButton('Monthly', !_isYearly, () {
                    setState(() => _isYearly = false);
                  }),
                  _buildToggleButton('Yearly -30%', _isYearly, () {
                    setState(() => _isYearly = true);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Free Plan
            _buildPlanCard(
              title: 'FREE',
              subtitle: 'Current Plan',
              price: '₹0',
              period: '/month',
              features: [
                _PlanFeature('5 Quizzes/month', true),
                _PlanFeature('Basic courses', true),
                _PlanFeature('Community access', true),
                _PlanFeature('Certificates', false),
                _PlanFeature('AI Assistant', false),
                _PlanFeature('Glow themes', false),
              ],
              isCurrentPlan: true,
              onUpgrade: null,
            ),
            const SizedBox(height: 16),

            // Pro Plan
            _buildPlanCard(
              title: 'PRO',
              subtitle: '⭐ POPULAR',
              price: _isYearly ? '₹209' : '₹299',
              period: '/month',
              originalPrice: _isYearly ? '₹299' : null,
              features: [
                _PlanFeature('Unlimited Quizzes', true),
                _PlanFeature('All premium courses', true),
                _PlanFeature('Verified Certificates', true),
                _PlanFeature('AI Study Assistant', true),
                _PlanFeature('6 Glow themes', true),
                _PlanFeature('No Ads', true),
                _PlanFeature('Offline downloads', true),
              ],
              isPopular: true,
              gradientColors: [AppColors.primary, AppColors.secondary],
              onUpgrade: () => _showUpgradeDialog('PRO'),
            ),
            const SizedBox(height: 16),

            // Elite Plan
            _buildPlanCard(
              title: 'ELITE',
              subtitle: '👑 BEST VALUE',
              price: _isYearly ? '₹419' : '₹599',
              period: '/month',
              originalPrice: _isYearly ? '₹599' : null,
              features: [
                _PlanFeature('Everything in PRO', true),
                _PlanFeature('1-on-1 Mentorship', true),
                _PlanFeature('Mock Interviews', true),
                _PlanFeature('Resume Review', true),
                _PlanFeature('9+ Glow themes', true),
                _PlanFeature('Priority support', true),
              ],
              gradientColors: [Colors.amber.shade700, Colors.orange.shade600],
              onUpgrade: () => _showUpgradeDialog('ELITE'),
            ),
            const SizedBox(height: 24),

            // Guarantees
            _buildGuarantee(Icons.check_circle, 'Cancel anytime'),
            const SizedBox(height: 8),
            _buildGuarantee(Icons.shield, '7-day money-back guarantee'),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required String period,
    String? originalPrice,
    required List<_PlanFeature> features,
    bool isCurrentPlan = false,
    bool isPopular = false,
    List<Color>? gradientColors,
    VoidCallback? onUpgrade,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isPopular
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isPopular
                ? AppColors.primary.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: isPopular ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradientColors != null
                  ? LinearGradient(colors: gradientColors)
                  : null,
              color: gradientColors == null ? Colors.grey.shade100 : null,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (title == 'ELITE')
                      const Text('👑 ', style: TextStyle(fontSize: 20)),
                    if (title == 'PRO')
                      const Text('💎 ', style: TextStyle(fontSize: 20)),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: gradientColors != null
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: gradientColors != null
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: gradientColors != null
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (originalPrice != null) ...[
                      Text(
                        originalPrice,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: gradientColors != null
                              ? Colors.white60
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: gradientColors != null
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 14,
                          color: gradientColors != null
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            feature.included
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 20,
                            color: feature.included
                                ? Colors.green
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            feature.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: feature.included
                                  ? AppColors.textPrimaryLight
                                  : Colors.grey.shade400,
                              decoration: feature.included
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    )),
                if (onUpgrade != null) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onUpgrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPopular
                            ? AppColors.primary
                            : Colors.grey.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Upgrade to $title',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuarantee(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(String plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Upgrade to $plan'),
        content: Text(
          'This will redirect you to the payment page to complete your subscription.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$plan subscription coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _PlanFeature {
  final String text;
  final bool included;

  _PlanFeature(this.text, this.included);
}
