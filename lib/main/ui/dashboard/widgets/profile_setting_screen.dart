import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountSettingScreen extends HookWidget {
  final VoidCallback onBack;

  const AccountSettingScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final gpsEnabled = useState(true);
    final selectedLanguage = useState('English (US)');
    final notificationSetting = useState('Do not Disturb');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('General Settings', 
          style: TextStyle(color: Color(0xFF0652C5), fontWeight: FontWeight.bold, fontSize: 18)),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  children: [
                    _buildSettingItem(
                      icon: Icons.location_on,
                      title: 'GPS Location',
                      subtitle: gpsEnabled.value ? 'On' : 'Off',
                      isToggle: true,
                      value: gpsEnabled.value,
                      onChanged: (value) {
                        gpsEnabled.value = value;
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onTap: () => _showLanguageDialog(context, selectedLanguage),
                      child: _buildSettingItem(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: selectedLanguage.value,
                      ),
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onTap: () => _showNotificationDialog(context, notificationSetting),
                      child: _buildSettingItem(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: notificationSetting.value,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showDeleteAccountDialog(context),
                child: _buildDeleteAccountButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isToggle = false,
    bool value = false,
    Function(bool)? onChanged,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF001E60),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF001E60),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isToggle)
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF0652C5),
            )
          else
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(color: Colors.grey.withOpacity(0.2), height: 1),
    );
  }

  Widget _buildDeleteAccountButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEDED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE74C3C),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE74C3C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, ValueNotifier<String> notificationSetting) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Biar tinggi pop-up ngikutin isi
            children: [
              // HEADER BIRU
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF0652C5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Notification Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 24), // Spacer biar title tetep di tengah
                  ],
                ),
              ),
              
              // ISI OPSI
              _buildDialogOption(
                context,
                'On',
                'We’ll notify you about important updates and activities.',
                isBlue: notificationSetting.value == 'On',
                onTap: () => notificationSetting.value = 'On',
              ),
              const Divider(height: 1),
              _buildDialogOption(
                context,
                'Off',
                'You won’t receive updates, reminders, or announcements.',
                isBlue: notificationSetting.value == 'Off',
                onTap: () => notificationSetting.value = 'Off',
              ),
              const Divider(height: 1),
              _buildDialogOption(
                context,
                'Do not Disturb',
                'All notifications will be silenced during this period.',
                isBlue: notificationSetting.value == 'Do not Disturb',
                onTap: () => notificationSetting.value = 'Do not Disturb',
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, ValueNotifier<String> selectedLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Biar tinggi pop-up ngikutin isi
            children: [
              // HEADER BIRU
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF0652C5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Language Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 24), // Spacer biar title tetep di tengah
                  ],
                ),
              ),
              
              // ISI OPSI
              _buildDialogOption(
                context,
                'English (US)',
                'Default language for the app interface.',
                isBlue: selectedLanguage.value == 'English (US)',
                onTap: () => selectedLanguage.value = 'English (US)',
              ),
              const Divider(height: 1),
              _buildDialogOption(
                context,
                'Indonesian',
                'Language for the app interface.',
                isBlue: selectedLanguage.value == 'Indonesian',
                onTap: () => selectedLanguage.value = 'Indonesian',
              ),
              const Divider(height: 1),
              _buildDialogOption(
                context,
                'English (UK)',
                'Language for the app interface.',
                isBlue: selectedLanguage.value == 'English (UK)',
                onTap: () => selectedLanguage.value = 'English (UK)',
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Widget pembantu untuk baris opsi di dalam dialog
  Widget _buildDialogOption(BuildContext context, String title, String desc, {bool isBlue = false, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isBlue ? const Color(0xFF0652C5) : Colors.black87,
        ),
      ),
      subtitle: Text(desc, style: TextStyle(fontSize: 12, color: isBlue ? const Color(0xFF0652C5) : Colors.grey)),
      onTap: () { 
        onTap();
        Navigator.pop(context); // Tutup dialog setelah pilih
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFBF0036),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 80),
            ),
          title: const Text(
            textAlign: TextAlign.center,
            'Are You Sure?',
            style: TextStyle(
              color: Color(0xFFBF0036),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            textAlign: TextAlign.center,
            'This action is permanent and cannot be undone. All your data, including profile information, activity history, and saved content will be permanently removed.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implementasikan logika delete account di sini
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion process started')),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFBF0036)),
              ),
            ),
          ],
        );
      },
    );
  }
}