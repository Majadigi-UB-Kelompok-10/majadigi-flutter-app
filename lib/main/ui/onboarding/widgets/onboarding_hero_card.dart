import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import './onboarding_indicator.dart';

const String _heroImageUrl = 'https://res.cloudinary.com/duxmv7lnl/image/upload/v1779115843/ovpo22g0dwhssefswboa.png';

class OnboardingHeroCard extends HookConsumerWidget {
  const OnboardingHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController();
    final currentPage = useState(0);

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
                controller: controller,
                itemCount: 4,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => currentPage.value = i,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: _heroImageUrl,
                    fit: BoxFit.cover,
                    useOldImageOnUrlChange: true,
                    placeholder: (context, url) {
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
                    errorWidget: (context, url, error) {
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

          Center(child: OnboardingIndicator(activeIndex: currentPage.value, itemCount: 4)),
        ],
      ),
    );
  }
}