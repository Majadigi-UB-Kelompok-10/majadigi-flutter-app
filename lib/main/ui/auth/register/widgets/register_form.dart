import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'register_input_field.dart';

class RegisterForm extends HookWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginRecognizer = useMemoized(() => TapGestureRecognizer());

    useEffect(() {
      loginRecognizer.onTap = () {
        if (context.mounted) {
          context.pop();
        }
      };

      return loginRecognizer.dispose;
    }, [loginRecognizer]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: const [
            Expanded(
              child: RegisterInputField(hintText: 'Nama depan'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: RegisterInputField(hintText: 'Nama belakang'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const RegisterInputField(
          hintText: 'No HP',
          keyboardType: TextInputType.phone,
          prefix: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 6.0),
            child: Icon(Icons.phone_android, color: Color(0xFF5E6B80)),
          ),
        ),
        const SizedBox(height: 12),
        const RegisterInputField(
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefix: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 6.0),
            child: Icon(Icons.email_outlined, color: Color(0xFF5E6B80)),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text.rich(
            TextSpan(
              text: 'Sudah punya akun? ',
              style: const TextStyle(color: Color(0xFF59697F)),
              children: [
                TextSpan(
                  recognizer: loginRecognizer,
                  text: 'Masuk',
                  style: const TextStyle(color: Color(0xFF0A63D2), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2146E4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Selanjutnya',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
