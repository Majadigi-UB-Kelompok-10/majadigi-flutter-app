import 'package:flutter/material.dart';

class ExpandableTextBox extends StatefulWidget {
  final String text;
  final int? maxLines;
  final double? padding;
  const ExpandableTextBox({super.key, required this.text, this.maxLines = 4, this.padding = 16.0});

  @override
  State<ExpandableTextBox> createState() => _ExpandableTextBoxState();
}

class _ExpandableTextBoxState extends State<ExpandableTextBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: DefaultTextStyle.of(context).style,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.maxLines,
        );

        textPainter.layout(maxWidth: constraints.maxWidth - (widget.padding! * 2));

        final isExpandable = textPainter.didExceedMaxLines;

        // --- THE SHORT TEXT SCENARIO ---
        if (!isExpandable) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.padding!),
            child: Text(
              widget.text,
              textAlign: TextAlign.justify,
            ),
          );
        }

        // --- THE LONG TEXT SCENARIO (Animated) ---
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.padding!),
            child: Column(
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.topCenter,
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    widget.text,
                    textAlign: TextAlign.justify,
                    maxLines: widget.maxLines,
                    overflow: TextOverflow.clip,
                  ),
                  secondChild: Text(
                    widget.text,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 4.0),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
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