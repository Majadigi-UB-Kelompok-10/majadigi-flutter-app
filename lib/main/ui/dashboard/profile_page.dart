import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import '../../core/http.dart';
import 'widgets/profile_information_screen.dart';
import 'widgets/profile_setting_screen.dart';
import 'widgets/profile_about_screen.dart';
import 'widgets/profile_helpsupport_screen.dart';

enum ProfileSubPage { main, information, settings, help, about }

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPage = useState(ProfileSubPage.main);

    return PopScope(
      canPop: currentPage.value == ProfileSubPage.main,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          currentPage.value = ProfileSubPage.main;
        }
      },
      child: _buildBody(context, currentPage),
    );
  }

  Widget _buildBody(BuildContext context, ValueNotifier<ProfileSubPage> currentPage) {
    switch (currentPage.value) {
      case ProfileSubPage.information:
        return AccountInformationScreen(
          onBack: () => currentPage.value = ProfileSubPage.main,
        );
      case ProfileSubPage.settings:
        return AccountSettingScreen(
          onBack: () => currentPage.value = ProfileSubPage.main,
        );
      case ProfileSubPage.about:
        return AccountAboutScreen(
          onBack: () => currentPage.value = ProfileSubPage.main,
        );
      case ProfileSubPage.help:
        return AccountHelpsupportScreen(
          onBack: () => currentPage.value = ProfileSubPage.main,
        );
      case ProfileSubPage.main:
      default:
        return _MainProfileView(
          onNavigate: (page) => currentPage.value = page,
        );
    }
  }
}

class _MainProfileView extends StatelessWidget {
  final Function(ProfileSubPage) onNavigate;

  const _MainProfileView({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF0652C5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // SECTION FOTO PROFIL
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color.fromARGB(255, 14, 94, 158), width: 4),
                      image: const DecorationImage(
                        image: NetworkImage('https://res.cloudinary.com/duxmv7lnl/image/upload/v1778351337/xgxybbitqdk8gvmkihsj.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Tombol Edit Foto
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF001E60),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // SECTION MENU SETTINGS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(context, Icons.person, 'Account Information', 
                      onTap: () => onNavigate(ProfileSubPage.information), isFirst: true),
                    const _Divider(),
                    _buildProfileItem(context, Icons.settings, 'Settings',
                      onTap: () => onNavigate(ProfileSubPage.settings)),
                    const _Divider(),
                    _buildProfileItem(context, Icons.help_outline, 'Help & Support',
                      onTap: () => onNavigate(ProfileSubPage.help)),
                    const _Divider(),
                    _buildProfileItem(context, Icons.info_outline, 'About',
                      onTap: () => onNavigate(ProfileSubPage.about), isLast: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Logout button cuz someone doesn't make one
            _LogoutButton()
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, {required VoidCallback onTap, bool isFirst = false, bool isLast = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF001E60), size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF001E60),
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF001E60), size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(20) : Radius.zero,
          bottom: isLast ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    );
  }
}

// Widget Pembantu untuk garis pemisah
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: FilledButton(
        onPressed: () async {
          await ref.read(authProvider.notifier).logout();

          // Ensure Auth Middleware is on and toggled
          ref.read(addAuthMiddlewareProvider);
          ref.read(authFeatureToggleProvider.notifier).enableAuth();

          // Disable Guest Mode
          ref.read(guestStatusProvider.notifier).disableGuest();

          if (context.mounted) {
            context.go("/onboarding");
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFDEDED),
          foregroundColor: const Color(0xFFE74C3C),
          minimumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Color(0xFFE74C3C),
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              "Log Out",
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ],
        )
      )
    );
  }
}