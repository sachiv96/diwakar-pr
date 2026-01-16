import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/opportunity_provider.dart';
import '../../widgets/cards/opportunity_card.dart';
import '../../widgets/common/loading_widget.dart';

class OpportunityScreen extends StatefulWidget {
  const OpportunityScreen({super.key});

  @override
  State<OpportunityScreen> createState() => _OpportunityScreenState();
}

class _OpportunityScreenState extends State<OpportunityScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Internship',
    'Fellowship',
    'Research',
    'Part-time',
  ];

  @override
  Widget build(BuildContext context) {
    final opportunityProvider = context.watch<OpportunityProvider>();
    final opportunities = _selectedFilter == 'All'
        ? opportunityProvider.opportunities
        : opportunityProvider.opportunities
            .where((o) => o.type == _selectedFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search opportunities...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                opportunityProvider.searchOpportunities(value);
              },
            ),
          ),

          // Filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondaryLight,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Opportunities list
          Expanded(
            child: opportunityProvider.isLoading
                ? const LoadingWidget(message: 'Loading opportunities...')
                : opportunities.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.work_outline,
                        title: 'No Opportunities Found',
                        subtitle: 'Check back later for new opportunities!',
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          opportunityProvider.listenToOpportunities();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: opportunities.length,
                          itemBuilder: (context, index) {
                            final opportunity = opportunities[index];
                            return OpportunityCard(
                              opportunity: opportunity,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.opportunityDetail,
                                  arguments: opportunity.id,
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
