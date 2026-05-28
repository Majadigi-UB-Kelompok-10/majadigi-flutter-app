import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../register_input_field.dart';

class RegisterFirstForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  const RegisterFirstForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RegisterInputField(
                hintText: 'Nama depan',
                controller: firstNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RegisterInputField(
                hintText: 'Nama belakang',
                controller: lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RegisterInputField(
          hintText: 'No HP',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          formatter: FilteringTextInputFormatter.digitsOnly,
          prefix: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 6.0),
            child: Icon(Icons.phone_android, color: Color(0xFF5E6B80)),
          ),
        ),
        const SizedBox(height: 12),
        RegisterInputField(
          hintText: 'Email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefix: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 6.0),
            child: Icon(Icons.email_outlined, color: Color(0xFF5E6B80)),
          ),
        ),
      ],
    );
  }
}