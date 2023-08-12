import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mikhuy/theme/theme.dart';

part 'text_theme.dart';

/// Official theme, containing text theme
/// and individual components theme
class AppTheme {
  /// Theme on light mode, currently the only mode.
  /// Applies to colors and individual components.
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      textTheme: _textTheme,

      /// Sets the default size of icons to 32
      iconTheme: const IconThemeData(size: 32),

      /// Sets the primary color to shiraz, in
      /// order to match the design
      primarySwatch: AppColors.flushOrange,
      backgroundColor: AppColors.white,
      scaffoldBackgroundColor: AppColors.white,

      /// Sets the default app bar background color to white, with dark
      /// text and 0.5 of elevation in order to match the design
      appBarTheme: AppBarTheme(
        color: AppColors.white,
        foregroundColor: AppColors.acadia,
        iconTheme: const IconThemeData(size: 32, color: AppColors.acadia),
        elevation: 0.5,
        actionsIconTheme: IconThemeData(
          size: 32,
          color: AppColors.grey.shade300,
        ),
        toolbarTextStyle: _textTheme.titleLarge,
      ),

      /// Sets the default shape, colors, elevation and padding
      /// to match the design, making use of the primary color flushOrange
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButton,
      ),

      /// Sets the default shape and colors to match the design,
      /// using the primary color shiraz for text and its variation
      /// shiraz 100 when it is pressed
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.flushOrange.shade200;
              }
              return AppColors.white;
            },
          ),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          ),
        ),
      ),

      errorColor: AppColors.danger,

      /// Sets the default style of text fields to match
      /// the design. Mainly removes borders and applies a
      /// circular border radius to corners.
      // inputDecorationTheme: InputDecorationTheme(
      //   floatingLabelStyle: AppTextStyle.headline2.copyWith(
      //     color: AppColors.flushOrange.shade700,
      //   ),
      //   labelStyle: AppTextStyle.subtitle2.copyWith(
      //     color: AppColors.grey.shade700,
      //   ),
      //   errorStyle: AppTextStyle.overline.copyWith(
      //     color: AppColors.danger,
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: AppColors.flushOrange.shade300),
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: AppColors.flushOrange.shade500),
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderSide: const BorderSide(color: AppColors.danger),
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderSide: const BorderSide(color: AppColors.danger),
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   contentPadding: const EdgeInsets.symmetric(
      //     vertical: 16,
      //     horizontal: 16,
      //   ),
      //   suffixIconColor: AppColors.grey.shade900,
      //   hintStyle: AppTextStyle.subtitle1.copyWith(
      //     color: AppColors.grey.shade700,
      //   ),
      // ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),

      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        alignment: Alignment.center,
      ),
    );
  }

  static ButtonStyle get primaryButton {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.flushOrange.shade200;
          }

          return AppColors.flushOrange.shade500;
        },
      ),
      foregroundColor: MaterialStateProperty.all(AppColors.white),
      overlayColor: MaterialStateProperty.all(AppColors.flushOrange.shade700),
      elevation: MaterialStateProperty.all(0.5),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  static ButtonStyle get secondaryButton {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.white),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.flushOrange.shade200;
          }
          return AppColors.flushOrange.shade700;
        },
      ),
      overlayColor: MaterialStateProperty.all(AppColors.flushOrange.shade200),
      elevation: MaterialStateProperty.all(0),
      shape: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          );
        }

        if (states.contains(MaterialState.disabled)) {
          return RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: AppColors.flushOrange.shade200),
          );
        }

        return RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColors.flushOrange.shade700),
        );
      }),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
