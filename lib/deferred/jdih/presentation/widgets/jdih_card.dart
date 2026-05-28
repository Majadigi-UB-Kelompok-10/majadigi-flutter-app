import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class JdihCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? status;
  final String? date;
  final String? views;
  final String? category;
  final double? width;
  final VoidCallback? onTap;
  final CardLayout layout;
  final Color? badgeColor;

  const JdihCard({
    super.key,
    required this.title,
    this.description,
    this.status,
    this.date,
    this.views,
    this.category,
    this.width,
    this.onTap,
    this.layout = CardLayout.horizontal,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: layout == CardLayout.horizontal
          ? _buildHorizontalCard()
          : _buildVerticalCard(),
    );
  }

  Widget _buildHorizontalCard() {
    return Container(
      width: width ?? 330,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgGray,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowGray,
            blurRadius: 10,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BAGIAN BADGE (TYPE & STATUS) JADI KANAN KIRI ---
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (category != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppTheme.accentBlue,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    category!.toUpperCase(),
                    style: TextStyle(
                      color: badgeColor != null ? Colors.white : AppTheme.darkBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],

              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppTheme.accentGreen.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status!.toUpperCase(),
                    style: TextStyle(
                      color: badgeColor != null ? Colors.white : AppTheme.accentGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          // ---------------------------------------------------

          // Jarak setelah Row Badge
          if (category != null || status != null) const SizedBox(height: 16),
          
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF101217),
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          if (date != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.black.withValues(alpha: 0.25),
                ),
                const SizedBox(width: 10),
                Text(
                  date!,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.23),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

Widget _buildVerticalCard() {
  return Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE4E8EF)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BAGIAN ATAS (BADGES & VIEWS)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Row untuk Badge-badge
            Row(
              children: [
                if (category != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9E8FF), // Sesuaikan warna background biru muda
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      category!.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.jdihBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), 
                ],

                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Warna background hijau muda (Berlaku)
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            
            // Views di pojok kanan
            if (views != null)
              Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFFA8B0BD)),
                  const SizedBox(width: 4),
                  Text(views!, style: const TextStyle(color: Color(0xFFA8B0BD), fontSize: 12)),
                ],
              ),
          ],
        ),

        const SizedBox(height: 12),
        
        // Judul (Title)
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),

        const SizedBox(height: 16),
        const Divider(color: Color(0xFFF1F5F9), thickness: 1),
        const SizedBox(height: 12),

        // BAGIAN BAWAH (DATE & PDF)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (date != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFFA8B0BD)),
                  const SizedBox(width: 8),
                  Text(
                    date!,
                    style: const TextStyle(color: Color(0xFF8D97A6), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            
            // Tombol PDF
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.picture_as_pdf, size: 18, color: AppTheme.jdihBlue),
                  SizedBox(width: 6),
                  Text(
                    'PDF',
                    style: TextStyle(color: AppTheme.jdihBlue, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}

enum CardLayout { horizontal, vertical }
