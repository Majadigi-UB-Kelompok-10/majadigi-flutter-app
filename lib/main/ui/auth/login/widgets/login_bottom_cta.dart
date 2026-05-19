import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class LoginBottomCta extends HookWidget {
  const LoginBottomCta({super.key});

  @override
  Widget build(BuildContext context) {
    final registerRecognizer = useMemoized(() => TapGestureRecognizer());

    useEffect(() {
      registerRecognizer.onTap = () {
        if (context.mounted) {
          context.push('/register');
        }
      };

      return registerRecognizer.dispose;
    }, [registerRecognizer]);

    return Padding(
      padding: const EdgeInsets.only(top: 250),
      child: Align(
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            text: 'Belum punya akun? ',
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF47586F),
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                recognizer: registerRecognizer,
                text: 'Daftar dulu',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}