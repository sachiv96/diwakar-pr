import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';

class OpportunityDetailScreen extends StatefulWidget {
  final String opportunityId;

  const OpportunityDetailScreen({super.key, required this.opportunityId});

  @override
  State<OpportunityDetailScreen> createState() =>
      _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadOpportunity();
  }

  Future<void> _loadOpportunity() async {
    await context
        .read<OpportunityProvider>()
        .fetchOpportunity(widget.opportunityId);
  }

  @override
  Widget build(BuildContext context) {
    final opportunityProvider = context.watch<OpportunityProvider>();
    final opportunity = opportunityProvider.currentOpportunity;
    final userId = context.read<AuthProvider>().user?.id ?? '';
    final hasApplied = opportunityProvider.applications.any(
        (a) => a.opportunityId == widget.opportunityId && a.userId == userId);

    if (opportunityProvider.isLoading || opportunity == null) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading opportunity...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share opportunity
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark opportunity
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company header
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    image: opportunity.companyLogo != null
                        ? DecorationImage(
                            image: NetworkImage(opportunity.companyLogo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: opportunity.companyLogo == null
                      ? Center(
                          child: Text(
                            opportunity.company[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        opportunity.company,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(opportunity.type, AppColors.primary),
                _buildTag(opportunity.location, AppColors.secondary),
                if (opportunity.isRemote)
                  _buildTag('Remote', AppColors.success),
              ],
            ),
            const SizedBox(height: 24),

            // Quick info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.attach_money,
                    'Stipend',
                    opportunity.stipend > 0
                        ? '\$${opportunity.stipend}/month'
                        : 'Unpaid',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Duration',
                    opportunity.duration,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.event,
                    'Deadline',
                    DateFormat('MMM d, yyyy').format(opportunity.deadline),
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.people,
                    'Openings',
                    '${opportunity.openings} positions',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'About the Role',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              opportunity.description,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Requirements
            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...opportunity.requirements.map((req) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          req,
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Skills
            const Text(
              'Skills Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: opportunity.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Responsibilities
            if (opportunity.responsibilities.isNotEmpty) ...[
              const Text(
                'Responsibilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...opportunity.responsibilities.map((resp) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            resp,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: hasApplied
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      'Application Submitted',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : CustomButton(
                text: 'Apply Now',
                onPressed: () {
                  _showApplyDialog(context, opportunityProvider);
                },
                width: double.infinity,
              ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showApplyDialog(BuildContext context, OpportunityProvider provider) {
    final coverLetterController = TextEditingController();
    final resumeLinkController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apply for this position',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: resumeLinkController,
                decoration: InputDecoration(
                  labelText: 'Resume Link',
                  hintText: 'Paste your resume link (Google Drive, etc.)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: coverLetterController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Cover Letter',
                  hintText: 'Tell us why you\'re a great fit...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Submit Application',
                onPressed: () async {
                  final userId = context.read<AuthProvider>().user?.id ?? '';
                  await provider.applyToOpportunity(
                    userId: userId,
                    opportunityId: widget.opportunityId,
                    coverLetter: coverLetterController.text,
                    resumeUrl: resumeLinkController.text,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Application submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                width: double.infinity,
                isLoading: provider.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
