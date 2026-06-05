import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterSecondForm extends HookWidget {
  final TextEditingController nikController;
  final TextEditingController addressController;
  final TextEditingController birthController;
  final TextEditingController genderController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String?> onGenderChanged;
  const RegisterSecondForm({
    super.key,
    required this.nikController,
    required this.addressController,
    required this.birthController,
    required this.genderController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onGenderChanged
  });

  @override
  Widget build(BuildContext context) {
    final isPasswordHidden = useState(true);
    final isConfirmPasswordHidden = useState(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // NIK
        const _FieldLabel('NIK (16 Digit)'),
        const SizedBox(height: 6),
        _FormInput(
          controller: nikController,
          hintText: 'Masukkan 16 digit NIK Anda',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          formatter: FilteringTextInputFormatter.digitsOnly,
        ),

        // Alamat
        const SizedBox(height: 14),
        const _FieldLabel('Alamat Lengkap'),
        const SizedBox(height: 6),
        _FormInput(
          controller: addressController,
          hintText: 'Contoh: Jl. Merdeka No. 123...',
          prefixIcon: Icons.location_on_outlined,
          minLines: 3,
          maxLines: 3,
          keyboardType: TextInputType.streetAddress,
          alignLabelToTop: true,
        ),
        const SizedBox(height: 14),

        // Tanggal Lahir dan Jenis Kelamin
        const Row(
          children: [
            Expanded(child: _FieldLabel('Tanggal Lahir')),
            SizedBox(width: 12),
            Expanded(child: _FieldLabel('Jenis Kelamin')),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [

            // Tanggal Lahir
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF0A63D2), // Matches your focused border color
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    // You can format this however you like (e.g., DD/MM/YYYY)
                    birthController.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                  }
                },
                child: AbsorbPointer(
                  child: _FormInput(
                    controller: birthController,
                    hintText: 'Tanggal Lahir',
                    readOnly: true,
                    suffixIcon: Icons.calendar_today_outlined,
                  ),
                ),
              ),
            ),

            // Jenis Kelamin
            const SizedBox(width: 12),
            Expanded(
              child: DropdownMenu(
                controller: genderController,
                hintText: 'Pilih Jenis Kelamin',
                expandedInsets: EdgeInsets.zero,
                leadingIcon: const Icon(Icons.transgender_outlined),
                trailingIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6A768C), size: 20),
                selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up, color: Color(0xFF0A63D2), size: 20),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFFF3F5FA),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                  hintStyle: const TextStyle(color: Color(0xFF8B96A8), fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFD3D9E6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0A63D2), width: 1.2),
                  ),
                ),
                dropdownMenuEntries: const <DropdownMenuEntry>[
                  DropdownMenuEntry(value: 'LAKI_LAKI', label: 'Laki-laki'),
                  DropdownMenuEntry(value: 'PEREMPUAN', label: 'Perempuan'),
                ],
                onSelected: (value) {
                  if (value != null) {
                    onGenderChanged(value.toString());
                  }
                },
              ),
            ),
          ],
        ),

        // Kata Sandi
        const SizedBox(height: 14),
        const _FieldLabel('Kata Sandi'),
        const SizedBox(height: 6),
        _FormInput(
          controller: passwordController,
          hintText: 'Minimal 8 karakter',
          prefixIcon: Icons.lock_outline,
          suffixIcon: isPasswordHidden.value
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          onSuffixTap: () {
            isPasswordHidden.value = !isPasswordHidden.value;
          },
          obscureText: isPasswordHidden.value,
        ),
        const SizedBox(height: 14),

        // Konfirmasi Kata Sandi
        const _FieldLabel('Ulangi Kata Sandi'),
        const SizedBox(height: 6),
        _FormInput(
          controller: confirmPasswordController,
          hintText: 'Ulangi kata sandi',
          prefixIcon: Icons.lock_reset_outlined,
          suffixIcon: isConfirmPasswordHidden.value
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          onSuffixTap: () {
            isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
          },
          obscureText: isConfirmPasswordHidden.value,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF3E4B5C),
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  const _FormInput({
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType,
    this.formatter,
    this.minLines,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.alignLabelToTop = false,
  });

  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;
  final TextInputFormatter? formatter;
  final int? minLines;
  final int maxLines;
  final bool obscureText;
  final bool readOnly;
  final bool alignLabelToTop;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF8B96A8), fontSize: 15),
        filled: true,
        fillColor: const Color(0xFFF3F5FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        alignLabelWithHint: alignLabelToTop,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD3D9E6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0A63D2), width: 1.2),
        ),
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: const Color(0xFF6A768C), size: 20),
        suffixIcon: suffixIcon == null ? null :
          IconButton(
            icon: Icon(suffixIcon),
            color: const Color(0xFF6A768C),
            iconSize: 20,
            onPressed: onSuffixTap,
            splashRadius: 24,
          ),
      ),
    );
  }
}