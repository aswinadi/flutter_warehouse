import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/ui/login_screen.dart';
import '../widgets/main_shell.dart';
import '../../features/purchase_request/ui/pr_list_screen.dart';
import '../../features/purchase_request/ui/pr_approval_screen.dart';
import '../../features/purchase_order/ui/po_list_screen.dart';
import '../../features/packing_list/ui/packing_list_screen.dart';
import '../../features/receiving/ui/receiving_scan_screen.dart';
import '../../features/receiving/ui/receiving_form_screen.dart';
import '../../features/receiving/ui/container_receiving_form_screen.dart';
import '../../features/inventory/ui/inventory_screen.dart';
import '../../features/inventory/ui/stock_mutation_screen.dart';
import '../../features/usage/ui/usage_screen.dart';
import '../../features/usage/ui/feed_log_screen.dart';
import '../../features/dashboard/ui/dashboard_screen.dart';
import '../../features/approvals/ui/approvals_screen.dart';
import '../../features/purchase_request/ui/pr_vendor_approval_screen.dart';
import '../../features/invoice/ui/invoice_approval_screen.dart';
import '../../features/invoice/ui/invoice_list_screen.dart';
import '../../features/payment_request/ui/payment_request_approval_screen.dart';
import '../../features/transfer/ui/transfer_out_screen.dart';
import '../../features/transfer/ui/transfer_in_screen.dart';
import '../../features/finance/ui/payment_transaction_list_screen.dart';
import '../../features/finance/ui/payment_transaction_detail_screen.dart';
import '../../features/purchase_order/ui/po_approval_screen.dart';
import '../../features/notifications/ui/notification_inbox_screen.dart';
import '../widgets/pdf_preview_screen.dart';
import '../../features/inventory/ui/asset_list_screen.dart';
import '../../features/inventory/ui/asset_detail_screen.dart';
import '../../features/inventory/ui/add_asset_screen.dart';
import '../../features/inventory/ui/inventory_adjustment_screen.dart';
import '../../features/inventory/models/inventory.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';
      
      return authState.when(
        data: (state) {
          final isLoggedIn = state.maybeWhen(
            authenticated: (_, __) => true,
            orElse: () => false,
          );

          if (!isLoggedIn && !isLoggingIn) return '/login';
          if (isLoggedIn && isLoggingIn) return '/';
          return null;
        },
        loading: () => null,
        error: (_, __) => '/login',
      );
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationInboxScreen(),
          ),
          GoRoute(
            path: '/pdf-preview',
            builder: (context, state) {
              final title = state.uri.queryParameters['title'] ?? 'PDF Preview';
              final urlPath = state.uri.queryParameters['url_path'];
              final pdfUrl = state.uri.queryParameters['pdf_url'];
              return PdfPreviewScreen(title: title, urlPath: urlPath, pdfUrl: pdfUrl);
            },
          ),
          GoRoute(
            path: '/pr',
            builder: (context, state) => const PRListScreen(),
            routes: [
              GoRoute(
                path: ':id/approve',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return PRApprovalScreen(prId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/approvals',
            builder: (context, state) => const ApprovalsScreen(),
            routes: [
              GoRoute(
                path: 'pr-qty/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return PRApprovalScreen(prId: id);
                },
              ),
              GoRoute(
                path: 'pr-vendor/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return PRVendorApprovalScreen(prId: id);
                },
              ),
              GoRoute(
                path: 'invoice/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return InvoiceApprovalScreen(invoiceId: id);
                },
              ),
              GoRoute(
                path: 'payment-request/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return PaymentRequestApprovalScreen(prId: id);
                },
              ),
              GoRoute(
                path: 'po/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return POApprovalScreen(poId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/po',
            builder: (context, state) => const POListScreen(),
          ),
          GoRoute(
            path: '/packing-list',
            builder: (context, state) => const PackingListScreen(),
          ),
          GoRoute(
            path: '/receiving',
            builder: (context, state) => const ReceivingScanScreen(),
            routes: [
              GoRoute(
                path: 'form',
                builder: (context, state) {
                  final poIdStr = state.uri.queryParameters['po_id'] ?? '';
                  final poId = int.tryParse(poIdStr) ?? 0;
                  return ReceivingFormScreen(poId: poId);
                },
              ),
              GoRoute(
                path: 'container-form',
                builder: (context, state) {
                  final number = state.uri.queryParameters['container_number'] ?? '';
                  return ContainerReceivingFormScreen(containerNumber: number);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/transfer-out',
            builder: (context, state) => const TransferOutScreen(),
          ),
          GoRoute(
            path: '/transfer-in',
            builder: (context, state) => const TransferInScreen(),
          ),
          GoRoute(
            path: '/usage',
            builder: (context, state) => const UsageScreen(),
          ),
          GoRoute(
            path: '/feed-logs',
            builder: (context, state) => const FeedLogScreen(),
          ),
          GoRoute(
            path: '/inventory-adjustments',
            builder: (context, state) {
              final item = state.extra as Inventory?;
              return InventoryAdjustmentScreen(prefilledItem: item);
            },
          ),
          GoRoute(
            path: '/stock-mutation',
            builder: (context, state) => const StockMutationScreen(),
          ),
          GoRoute(
            path: '/purchase-invoices',
            builder: (context, state) => const InvoiceListScreen(),
          ),
          GoRoute(
            path: '/payment-transactions',
            builder: (context, state) => const PaymentTransactionListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return PaymentTransactionDetailScreen(transactionId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/assets',
            builder: (context, state) => const AssetListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddAssetScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AssetDetailScreen(assetId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
