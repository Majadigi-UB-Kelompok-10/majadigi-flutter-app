import 'package:flutter/material.dart';
import './onboarding_indicator.dart';

class OnboardingHeroCard extends StatefulWidget {
  const OnboardingHeroCard({super.key});

  static const String _heroImageUrl = 'https://res.cloudinary.com/duxmv7lnl/image/upload/v1779115843/ovpo22g0dwhssefswboa.png';

  @override
  State<OnboardingHeroCard> createState() => _OnboardingHeroCardState();
}

class _OnboardingHeroCardState extends State<OnboardingHeroCard> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDDE7F2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C5AA0).withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PUBLIC SERVICES',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F4EAB),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Simplify. Connect. Grow',
                  style: TextStyle(
                    fontSize: 8.5,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7B8AA2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 1.93,
              child: PageView.builder(
                controller: _controller,
                itemCount: 4,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, index) {
                  return Image.network(
                    OnboardingHeroCard._heroImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFEAF1FF),
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFEAF1FF),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF7893B6)),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: OnboardingIndicator(activeIndex: _current, itemCount: 4)),
        ],
      ),
    );
  }
}