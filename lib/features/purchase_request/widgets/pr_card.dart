import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/purchase_request.dart';

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
          letterSpacing: 0.5,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x140F0F0F),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {
            context.push('/pr/${pr.id}/approve');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF0F172A), // Midnight Navy
                            ),
                          ),
                          if (pr.companyName != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              pr.companyName!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4F46E5), // Indigo Accent
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
                  'Date: ${pr.requestDate}',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Requested by: ${pr.requestByName ?? "-"}',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                ),
                if (pr.notes != null && pr.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Notes: ${pr.notes}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
