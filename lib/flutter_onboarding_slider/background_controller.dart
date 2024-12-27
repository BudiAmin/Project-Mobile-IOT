import 'package:flutter/material.dart';

class BackgroundController extends StatelessWidget {
  // Parameter utama
  final int currentPage; // Halaman saat ini
  final int totalPage; // Total halaman
  final Color? controllerColor; // Warna indikator
  final bool indicatorAbove; // Posisi indikator di atas atau bawah
  final double indicatorPosition; // Posisi vertikal indikator
  final bool hasFloatingButton; // Apakah tombol floating tersedia

  // Konstruktor dengan validasi input dan nilai default
  BackgroundController({
    required this.currentPage,
    required this.totalPage,
    this.controllerColor = Colors.white, // Default warna putih
    this.indicatorAbove = false, // Default di bawah
    this.hasFloatingButton = false, // Default tanpa tombol floating
    this.indicatorPosition = 20.0, // Default posisi indikator
  }) : assert(
          currentPage < totalPage, // Validasi halaman saat ini
          'currentPage harus kurang dari totalPage.',
        );

  @override
  Widget build(BuildContext context) {
    return indicatorAbove
        ? _buildIndicatorContainer() // Jika indikator di atas
        : (currentPage == totalPage - 1 && hasFloatingButton)
            ? SizedBox
                .shrink() // Jika halaman terakhir dan tombol floating aktif
            : _buildIndicatorContainer(); // Jika indikator di bawah
  }

  /// Widget Container untuk indikator
  Widget _buildIndicatorContainer() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10), // Padding bawah
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageIndicator(),
      ),
    );
  }

  /// Membangun daftar indikator halaman
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < totalPage; i++) {
      list.add(_indicator(
          i == currentPage)); // Aktifkan indikator pada halaman saat ini
    }
    return list;
  }

  /// Widget untuk indikator halaman (aktif atau tidak aktif)
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 150), // Animasi perubahan indikator
      margin: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: indicatorAbove ? indicatorPosition : 28,
      ),
      height: 8.0,
      width: isActive ? 28.0 : 8.0, // Ukuran indikator aktif dan non-aktif
      decoration: BoxDecoration(
        color: isActive
            ? controllerColor // Warna aktif
            : controllerColor
                ?.withOpacity(0.5), // Warna transparan saat non-aktif
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
