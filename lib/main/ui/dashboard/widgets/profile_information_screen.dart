import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/profile/profile_provider.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

class AccountInformationScreen extends HookConsumerWidget {
  final VoidCallback onBack;

  const AccountInformationScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileProvider);
    final nameController = useTextEditingController(text: "Not Set");
    final emailController = useTextEditingController(text: "Not Set");
    final phoneController = useTextEditingController(text: "Not Set");
    final locationController = useTextEditingController(text: "Not Set");

    return profileData.when(
      error: (error, stackTrace) => Center(child: Text("Error: ${error.toString()}")),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (userProfile) {
        if (userProfile == null) {
          return Center(child: Text("Failed to Fetch Profile Data"));
        }

        if (userProfile.firstName != null && userProfile.lastName != null) {
          nameController.text = "${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}".trim();
        }

        if (userProfile.email != null) {
          emailController.text = userProfile.email ?? '';
        }

        if (userProfile.phone != null) {
          phoneController.text = userProfile.phone ?? '';
        }

        if (userProfile.address != null) {
          locationController.text = userProfile.address ?? '';
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Account Information', style: TextStyle(color: Color(0xFF0652C5), fontWeight: FontWeight.bold, fontSize: 18)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.reply, color: Color(0xFF0652C5)),
              onPressed: onBack,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildInputField('Name', nameController),
                  _buildInputField('Email', emailController),
                  _buildInputField('Phone', phoneController),
                  _buildInputField('Location', locationController),
                  const SizedBox(height: 20),
                  _buildSaveButton(() async {
                    // Split Name
                    final fullName = nameController.text;
                    final nameParts = fullName.trim().split(' ');
                    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
                    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

                    // Create the profile entity
                    final entity = ProfileEntity(
                      authId: userProfile.authId,
                      firstName: firstName,
                      lastName: lastName,
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      address: locationController.text.trim(),
                      isActive: userProfile.isActive
                    );

                    // Determine online or offline/guest
                    final isGuest = await ref.read(guestStatusProvider.future);

                    // Update the profile
                    if (isGuest) {
                      await ref.read(profileProvider.notifier).updateOfflineProfile(entity);
                    } else {
                      await ref.read(profileProvider.notifier).updateProfile(entity);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully')),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF0652C5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      )
    );
  }
}