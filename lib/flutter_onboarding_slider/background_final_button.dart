import 'package:flutter/material.dart';

/// Kustomisasi gaya tombol akhir (Finish Button Style)
class FinishButtonStyle {
  final ShapeBorder? shape;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;

  // Konstruktor dengan nilai default
  const FinishButtonStyle({
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    ),
    this.elevation = 0,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
  });
}

/// Widget untuk tombol akhir atau skip
class BackgroundFinalButton extends StatelessWidget {
  // Parameter utama
  final int currentPage; // Halaman saat ini
  final PageController pageController; // Controller untuk berpindah halaman
  final int totalPage; // Total jumlah halaman
  final bool addButton; // Apakah tombol harus ditampilkan
  final Function? onPageFinish; // Fungsi yang dipanggil saat selesai
  final TextStyle buttonTextStyle; // Gaya teks pada tombol
  final String? buttonText; // Teks pada tombol
  final bool hasSkip; // Apakah ada tombol skip
  final Icon skipIcon; // Ikon untuk tombol skip
  final FinishButtonStyle? finishButtonStyle; // Gaya kustom tombol

  // Konstruktor dengan validasi dan nilai default
  BackgroundFinalButton({
    required this.currentPage,
    required this.pageController,
    required this.totalPage,
    this.onPageFinish,
    this.buttonText,
    required this.buttonTextStyle,
    required this.addButton,
    required this.hasSkip,
    required this.skipIcon,
    this.finishButtonStyle = const FinishButtonStyle(),
  }) : assert(currentPage >= 0 && currentPage < totalPage,
            'currentPage harus di antara 0 dan totalPage - 1');

  @override
  Widget build(BuildContext context) {
    // Jika tombol diaktifkan
    return addButton
        ? hasSkip // Jika memiliki tombol Skip
            ? AnimatedContainer(
                // Animasi perubahan ukuran dan padding
                padding: currentPage == totalPage - 1
                    ? EdgeInsets.symmetric(horizontal: 30)
                    : EdgeInsets.all(0),
                width: currentPage == totalPage - 1
                    ? MediaQuery.of(context).size.width - 30
                    : 60,
                duration: Duration(milliseconds: 150),
                child: currentPage == totalPage - 1
                    // Tombol "Finish"
                    ? FloatingActionButton.extended(
                        shape: finishButtonStyle?.shape,
                        elevation: finishButtonStyle?.elevation,
                        focusElevation: finishButtonStyle?.focusElevation,
                        hoverElevation: finishButtonStyle?.hoverElevation,
                        highlightElevation:
                            finishButtonStyle?.highlightElevation,
                        disabledElevation: finishButtonStyle?.disabledElevation,
                        foregroundColor: finishButtonStyle?.foregroundColor,
                        backgroundColor: finishButtonStyle?.backgroundColor,
                        focusColor: finishButtonStyle?.focusColor,
                        hoverColor: finishButtonStyle?.hoverColor,
                        splashColor: finishButtonStyle?.splashColor,
                        onPressed: () => onPageFinish?.call(),
                        label: buttonText == null
                            ? SizedBox.shrink()
                            : Text(
                                buttonText!,
                                style: buttonTextStyle,
                              ),
                      )
                    // Tombol "Skip"
                    : FloatingActionButton(
                        shape: finishButtonStyle?.shape,
                        elevation: finishButtonStyle?.elevation,
                        focusElevation: finishButtonStyle?.focusElevation,
                        hoverElevation: finishButtonStyle?.hoverElevation,
                        highlightElevation:
                            finishButtonStyle?.highlightElevation,
                        disabledElevation: finishButtonStyle?.disabledElevation,
                        foregroundColor: finishButtonStyle?.foregroundColor,
                        backgroundColor: finishButtonStyle?.backgroundColor,
                        focusColor: finishButtonStyle?.focusColor,
                        hoverColor: finishButtonStyle?.hoverColor,
                        splashColor: finishButtonStyle?.splashColor,
                        onPressed: () => _goToNextPage(context),
                        child: skipIcon,
                      ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width - 30,
                child: FloatingActionButton.extended(
                  shape: finishButtonStyle?.shape,
                  elevation: finishButtonStyle?.elevation,
                  focusElevation: finishButtonStyle?.focusElevation,
                  hoverElevation: finishButtonStyle?.hoverElevation,
                  highlightElevation: finishButtonStyle?.highlightElevation,
                  disabledElevation: finishButtonStyle?.disabledElevation,
                  foregroundColor: finishButtonStyle?.foregroundColor,
                  backgroundColor: finishButtonStyle?.backgroundColor,
                  focusColor: finishButtonStyle?.focusColor,
                  hoverColor: finishButtonStyle?.hoverColor,
                  splashColor: finishButtonStyle?.splashColor,
                  onPressed: () => onPageFinish?.call(),
                  label: buttonText == null
                      ? SizedBox.shrink()
                      : Text(
                          buttonText!,
                          style: buttonTextStyle,
                        ),
                ),
              )
        : SizedBox.shrink(); // Tidak menampilkan tombol jika addButton = false
  }

  /// Fungsi untuk berpindah ke halaman berikutnya
  void _goToNextPage(BuildContext context) {
    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
