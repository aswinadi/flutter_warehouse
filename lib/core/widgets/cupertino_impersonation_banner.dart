import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/impersonation_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'cupertino_glass_container.dart';

class CupertinoImpersonationBanner extends ConsumerWidget {
  const CupertinoImpersonationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impersonationState = ref.watch(impersonationProvider);
    final authState = ref.watch(authProvider);

    final isImpersonating = impersonationState.valueOrNull?.isImpersonating ?? false;

    if (!isImpersonating) return const SizedBox.shrink();

    final activeUser = authState.valueOrNull?.maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );

    if (activeUser == null) return const SizedBox.shrink();

    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    // Specular border with active orange highlighting to signal the impersonate mode
    final borderGlow = isDark 
        ? const Color(0x66FF9F0A) // Glow orange on dark mode
        : const Color(0x55FF9500); // Glow orange on light mode

    return Positioned(
      bottom: 74, // Positioned nicely above the bottom tab bar on mobile, and at the bottom on desktop
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: CupertinoGlassContainer(
            borderRadius: 9999.0, // Rounded pill shape (radius.full)
            blurSigma: 20.0,      // Level 3 (Floating)
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            borderColor: borderGlow,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Info icon with warning/impersonating style
                const Icon(
                  CupertinoIcons.person_crop_circle_badge_exclam,
                  color: CupertinoColors.activeOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                
                // Text description
                Flexible(
                  child: Text(
                    'Menyamar: ${activeUser.name} (${activeUser.roles.join(", ")})',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: isDark ? CupertinoColors.white : CupertinoColors.black,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Exit button
                GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Keluar Impersonasi'),
                        content: const Text('Apakah Anda yakin ingin keluar dari sesi impersonasi ini?'),
                        actions: [
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(impersonationProvider.notifier).stopImpersonating();
                            },
                            child: const Text('Keluar'),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0x33FF453A) : const Color(0x15FF3B30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.systemRed.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: const Text(
                      'Keluar',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.destructiveRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
