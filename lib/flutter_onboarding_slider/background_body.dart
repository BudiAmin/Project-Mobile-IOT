import 'package:flutter/material.dart';

class BackgroundBody extends StatelessWidget {
  // Parameter utama untuk konfigurasi
  final PageController controller; // Mengontrol perpindahan halaman
  final Function(int) function; // Fungsi callback saat halaman berubah
  final int totalPage; // Total jumlah halaman
  final List<Widget> bodies; // Daftar widget yang ditampilkan di setiap halaman

  // Konstruktor dengan validasi input
  BackgroundBody({
    required this.controller,
    required this.function,
    required this.totalPage,
    required this.bodies,
  }) : assert(
          bodies.length == totalPage,
          'Jumlah widget dalam "bodies" harus sesuai dengan totalPage.',
        );

  @override
  Widget build(BuildContext context) {
    return PageView(
      // Membatasi scroll agar terasa lebih alami (ClampingScrollPhysics)
      physics: const ClampingScrollPhysics(),
      controller: controller, // Menghubungkan dengan PageController
      onPageChanged: (value) {
        function(value); // Memanggil fungsi callback saat halaman berganti
      },
      children: bodies, // Menampilkan widget pada setiap halaman
    );
  }
}
