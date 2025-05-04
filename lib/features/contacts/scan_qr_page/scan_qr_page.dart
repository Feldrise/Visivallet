import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/error_snackbar.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/features/contacts/database/repositories/contact_repository.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/services/contact_sharing_service.dart';

class ScanQRPage extends ConsumerStatefulWidget {
  const ScanQRPage({super.key});

  @override
  ConsumerState<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends ConsumerState<ScanQRPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processQRCode(String data) async {
    // Prevent multiple processing of the same QR code
    if (_isProcessing) return;

    _isProcessing = true;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    setState(() {});

    try {
      final contactSharingService = ref.read(contactSharingServiceProvider);
      final Contact? contact = contactSharingService.parseContactQRData(data);

      if (contact == null) {
        if (mounted) {
          ErrorSnackbar.show(context, "QR code invalide ou incompatible");
        }
        return;
      }

      // Save the contact using the repository's createContact method
      final contactRepository = ref.read(contactRepositoryProvider);
      await contactRepository.createContact(contact);

      if (mounted) {
        SuccessSnackbar.show(context, "Contact ajouté avec succès");
        Navigator.of(context).pop(contact);
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.show(context, "Erreur lors de l'ajout du contact: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner un QR Code"),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                );
              },
            ),
            onPressed: () => _scannerController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.cameraFacingState,
              builder: (context, state, child) {
                return Icon(
                  state == CameraFacing.front ? Icons.camera_front : Icons.camera_rear,
                );
              },
            ),
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;

              final String? qrData = capture.barcodes.first.rawValue;
              if (qrData != null) {
                _processQRCode(qrData);
              }
            },
          ),
          // QR Scan Overlay
          _QRScannerOverlay(
            overlayColor: Colors.black.withOpacity(0.5),
          ),
          // Processing indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text(
                          "Ajout du contact...",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Scanning instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Text(
                "Placez le QR Code à l'intérieur du cadre pour le scanner",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QRScannerOverlay extends StatelessWidget {
  final Color overlayColor;

  const _QRScannerOverlay({
    required this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;

    // Calculate scan area size (70% of the smallest dimension)
    final scanAreaSize = size.width < size.height ? size.width * 0.7 : size.height * 0.7;

    // Calculate positions
    final scanAreaLeft = (size.width - scanAreaSize) / 2;
    final scanAreaTop = (size.height - scanAreaSize) / 2;

    return Stack(
      children: [
        // Background overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColor,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              // This is the hole for scanner
              Positioned(
                left: scanAreaLeft,
                top: scanAreaTop,
                child: Container(
                  height: scanAreaSize,
                  width: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scanner Border
        Positioned(
          left: scanAreaLeft,
          top: scanAreaTop,
          child: Container(
            height: scanAreaSize,
            width: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Corner indicators
        _buildCornerIndicator(scanAreaLeft, scanAreaTop, true, true, scanAreaSize),
        _buildCornerIndicator(scanAreaLeft + scanAreaSize, scanAreaTop, false, true, scanAreaSize),
        _buildCornerIndicator(scanAreaLeft, scanAreaTop + scanAreaSize, true, false, scanAreaSize),
        _buildCornerIndicator(scanAreaLeft + scanAreaSize, scanAreaTop + scanAreaSize, false, false, scanAreaSize),
      ],
    );
  }

  Widget _buildCornerIndicator(double left, double top, bool isLeft, bool isTop, double scanAreaSize) {
    final cornerSize = scanAreaSize * 0.1;

    return Positioned(
      left: isLeft ? left - 1.5 : left - cornerSize + 1.5,
      top: isTop ? top - 1.5 : top - cornerSize + 1.5,
      child: Container(
        width: cornerSize,
        height: cornerSize,
        decoration: BoxDecoration(
          border: Border(
            left: isLeft ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            top: isTop ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
