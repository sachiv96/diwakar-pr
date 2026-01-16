import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _graduationYearController;
  late TextEditingController _currentGoalController;

  List<String> _skills = [];
  List<String> _interests = [];
  List<SocialLink> _socialLinks = [];

  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().currentProfile;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _institutionController =
        TextEditingController(text: profile?.institution ?? '');
    _degreeController = TextEditingController(text: profile?.degree ?? '');
    _graduationYearController =
        TextEditingController(text: profile?.graduationYear?.toString() ?? '');
    _currentGoalController =
        TextEditingController(text: profile?.currentGoal ?? '');

    _skills = List.from(profile?.skills ?? []);
    _interests = List.from(profile?.interests ?? []);
    _socialLinks = List.from(profile?.socialLinks ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _institutionController.dispose();
    _degreeController.dispose();
    _graduationYearController.dispose();
    _currentGoalController.dispose();
    _skillController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            const SizedBox(height: 24),

            // Basic Info Section
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _bioController,
              label: 'Bio',
              icon: Icons.info_outline,
              maxLines: 3,
              hint: 'Tell us about yourself...',
            ),
            const SizedBox(height: 24),

            // Education Section
            _buildSectionTitle('Education'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _institutionController,
              label: 'Institution',
              icon: Icons.school,
              hint: 'e.g., IIT Delhi',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _degreeController,
              label: 'Degree / Course',
              icon: Icons.book,
              hint: 'e.g., B.Tech Computer Science',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _graduationYearController,
              label: 'Expected Graduation Year',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
              hint: 'e.g., 2026',
            ),
            const SizedBox(height: 24),

            // Goals Section
            _buildSectionTitle('Goals'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _currentGoalController,
              label: 'Current Goal',
              icon: Icons.flag,
              hint: 'e.g., Clear JEE Advanced 2025',
            ),
            const SizedBox(height: 24),

            // Skills Section
            _buildSectionTitle('Skills'),
            const SizedBox(height: 12),
            _buildTagInput(
              controller: _skillController,
              label: 'Add Skill',
              tags: _skills,
              onAdd: (skill) {
                if (skill.isNotEmpty && !_skills.contains(skill)) {
                  setState(() => _skills.add(skill));
                }
              },
              onRemove: (skill) {
                setState(() => _skills.remove(skill));
              },
            ),
            const SizedBox(height: 24),

            // Interests Section
            _buildSectionTitle('Interests'),
            const SizedBox(height: 12),
            _buildTagInput(
              controller: _interestController,
              label: 'Add Interest',
              tags: _interests,
              onAdd: (interest) {
                if (interest.isNotEmpty && !_interests.contains(interest)) {
                  setState(() => _interests.add(interest));
                }
              },
              onRemove: (interest) {
                setState(() => _interests.remove(interest));
              },
            ),
            const SizedBox(height: 24),

            // Social Links Section
            _buildSectionTitle('Social Links'),
            const SizedBox(height: 12),
            _buildSocialLinksSection(),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    final profile = context.watch<ProfileProvider>().currentProfile;

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey.shade100,
                  child: profile?.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profile!.avatarUrl!,
                            width: 112,
                            height: 112,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          profile?.initials ?? 'U',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _pickImage,
            child: Text(
              'Change Photo',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildTagInput({
    required TextEditingController controller,
    required String label,
    required List<String> tags,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: Icon(Icons.add, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onSubmitted: (value) {
                  onAdd(value.trim());
                  controller.clear();
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                onAdd(controller.text.trim());
                controller.clear();
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => onRemove(tag),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSocialLinksSection() {
    final platforms = [
      {'name': 'LinkedIn', 'icon': '🔗'},
      {'name': 'GitHub', 'icon': '💻'},
      {'name': 'Twitter', 'icon': '🐦'},
      {'name': 'Instagram', 'icon': '📸'},
      {'name': 'Website', 'icon': '🌐'},
    ];

    return Column(
      children: [
        ...platforms.map((platform) {
          final existingLink = _socialLinks.firstWhere(
            (link) => link.platform == platform['name'],
            orElse: () => SocialLink(platform: platform['name']!, url: ''),
          );
          final controller = TextEditingController(text: existingLink.url);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: platform['name'],
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(platform['icon']!,
                      style: const TextStyle(fontSize: 20)),
                ),
                hintText: 'Enter ${platform['name']} URL',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _socialLinks
                      .removeWhere((link) => link.platform == platform['name']);
                  if (value.isNotEmpty) {
                    _socialLinks.add(SocialLink(
                      platform: platform['name']!,
                      url: value,
                    ));
                  }
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera capture
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery picker
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.delete, color: Colors.red.shade600),
              ),
              title: Text('Remove Photo',
                  style: TextStyle(color: Colors.red.shade600)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement photo removal
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ProfileProvider>();
      final currentProfile = provider.currentProfile;

      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          name: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          institution: _institutionController.text.trim(),
          degree: _degreeController.text.trim(),
          graduationYear: int.tryParse(_graduationYearController.text.trim()),
          currentGoal: _currentGoalController.text.trim(),
          skills: _skills,
          interests: _interests,
          socialLinks: _socialLinks,
        );

        await provider.updateProfile(updatedProfile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Profile updated successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
