import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExpandableTextBox extends HookWidget {
  final String text;
  final int? maxLines;
  final double? padding;
  const ExpandableTextBox({super.key, required this.text, this.maxLines = 4, this.padding = 16.0});

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: text,
          style: DefaultTextStyle.of(context).style,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );

        textPainter.layout(maxWidth: constraints.maxWidth - (padding! * 2));

        final isExpandable = textPainter.didExceedMaxLines;

        // --- THE SHORT TEXT SCENARIO ---
        if (!isExpandable) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding!),
            child: Text(
              text,
              textAlign: TextAlign.justify,
            ),
          );
        }

        // --- THE LONG TEXT SCENARIO (Animated) ---
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding!),
            child: Column(
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.topCenter,
                  crossFadeState: isExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    text,
                    textAlign: TextAlign.justify,
                    maxLines: maxLines,
                    overflow: TextOverflow.clip,
                  ),
                  secondChild: Text(
                    text,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 4.0),
                AnimatedRotation(
                  turns: isExpanded.value ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}