import 'package:flutter/material.dart';
import '../shared/auth_header.dart';
import 'widgets/login_bottom_cta.dart';
import 'widgets/login_form.dart';
import 'widgets/login_title.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A63D2),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            const _TopBand(),
            Padding(
              padding: const EdgeInsets.only(top: 38),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.sizeOf(context).height,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            OnboardingHeader(showLanguageChip: false),
                            SizedBox(height: 50),
                            LoginTitle(),
                            SizedBox(height: 28),
                            LoginForm(),
                            SizedBox(height: 24),
                            LoginBottomCta(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBand extends StatelessWidget {
  const _TopBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      decoration: const BoxDecoration(
        color: Color(0xFF0A63D2),
      ),
    );
  }
}
