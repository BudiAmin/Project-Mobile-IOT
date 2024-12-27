import 'package:flutter/material.dart';
import 'page_offset_provider.dart';
import 'package:provider/provider.dart';

class BackgroundImage extends StatelessWidget {
  // Parameter utama
  final int id; // ID halaman saat ini
  final Widget background; // Widget background yang ditampilkan
  final double imageVerticalOffset; // Offset vertikal background
  final double speed; // Kecepatan paralaks
  final double imageHorizontalOffset; // Offset horizontal background
  final bool centerBackground; // Apakah background di tengah layar

  // Konstruktor dengan validasi dan nilai default
  BackgroundImage({
    required this.id,
    this.speed = 1.0, // Default kecepatan paralaks
    required this.background,
    this.imageVerticalOffset = 0.0, // Default offset vertikal
    this.centerBackground = false, // Default tidak di tengah
    this.imageHorizontalOffset = 0.0, // Default offset horizontal
  }) : assert(id > 0, 'ID harus lebih besar dari 0.');

  @override
  Widget build(BuildContext context) {
    // Menggunakan Provider untuk mendapatkan offset halaman
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        // Posisi gambar dengan efek paralaks
        double position = MediaQuery.of(context).size.width *
                ((id - 1) * speed) - // Menghitung posisi awal
            speed * notifier.offset + // Efek paralaks berdasarkan offset
            (centerBackground ? 0 : imageHorizontalOffset);

        return Stack(
          children: [
            // Menempatkan gambar dengan posisi dinamis
            Positioned(
              top: imageVerticalOffset, // Offset vertikal
              left: position, // Posisi horizontal
              child: centerBackground
                  ? Container(
                      width: MediaQuery.of(context).size.width, // Lebar penuh
                      child: child!, // Menampilkan background
                    )
                  : child!, // Menampilkan background tanpa lebar penuh
            ),
          ],
        );
      },
      // Widget background sebagai child
      child: Container(
        child: background,
      ),
    );
  }
}
