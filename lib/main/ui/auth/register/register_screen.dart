import 'package:flutter/material.dart';
import '../shared/auth_header.dart';
import 'widgets/register_title.dart';
import 'widgets/register_form.dart';
import 'widgets/register_progress.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                            SizedBox(height: 24),
                            RegisterTitle(),
                            SizedBox(height: 18),
                            RegisterProgress(),
                            SizedBox(height: 16),
                            RegisterForm(),
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
