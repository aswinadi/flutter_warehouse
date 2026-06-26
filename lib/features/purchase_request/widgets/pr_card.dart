import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../models/purchase_request.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class PRStatusChip extends StatelessWidget {
  final String status;
  const PRStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
      case 'vendor_approved':
      case 'po_created':
        color = const Color(0xFF10B981); // Emerald Mint
        break;
      case 'pending':
      case 'submitted':
        color = const Color(0xFFF59E0B); // Amber Gold
        break;
      case 'rejected':
        color = const Color(0xFFEF4444); // Coral Crimson
        break;
      case 'waiting_bod_approval':
      case 'waiting_comparison':
        color = const Color(0xFF6366F1); // Indigo
        break;
      default:
        color = const Color(0xFF64748B); // Slate
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PRCard extends StatelessWidget {
  final PurchaseRequest pr;
  final VoidCallback? onTap;
  final bool isSelected;

  const PRCard({
    super.key,
    required this.pr,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: onTap ?? () {
        context.push('/pr/${pr.id}/approve');
      },
      child: CupertinoGlassContainer(
        borderRadius: CupertinoSpacing.cardRadius,
        borderColor: isSelected ? CupertinoColors.activeBlue : null,
        backgroundColor: isSelected ? CupertinoColors.activeBlue.withValues(alpha: 0.08) : null,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pr.code,
                        style: context.callout.copyWith(
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                      if (pr.companyName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          pr.companyName!,
                          style: context.footnote.copyWith(
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PRStatusChip(status: pr.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tanggal: ${pr.requestDate}',
              style: context.footnote.copyWith(color: secondaryLabel),
            ),
            const SizedBox(height: 4),
            Text(
              'Diajukan oleh: ${pr.requestByName ?? "-"}',
              style: context.subhead.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (pr.notes != null && pr.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Catatan: ${pr.notes}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.footnote.copyWith(
                  fontStyle: FontStyle.italic,
                  color: secondaryLabel,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
