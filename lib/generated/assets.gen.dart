/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/back.svg
  SvgGenImage get back => const SvgGenImage('assets/icons/back.svg');

  /// File path: assets/icons/calc.svg
  SvgGenImage get calc => const SvgGenImage('assets/icons/calc.svg');

  /// File path: assets/icons/calendar.svg
  SvgGenImage get calendar => const SvgGenImage('assets/icons/calendar.svg');

  /// File path: assets/icons/change.svg
  SvgGenImage get change => const SvgGenImage('assets/icons/change.svg');

  /// File path: assets/icons/chevron_down.svg
  SvgGenImage get chevronDown =>
      const SvgGenImage('assets/icons/chevron_down.svg');

  /// File path: assets/icons/close.svg
  SvgGenImage get close => const SvgGenImage('assets/icons/close.svg');

  /// File path: assets/icons/contact_us.svg
  SvgGenImage get contactUs => const SvgGenImage('assets/icons/contact_us.svg');

  /// File path: assets/icons/high.svg
  SvgGenImage get high => const SvgGenImage('assets/icons/high.svg');

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg');

  /// File path: assets/icons/low.svg
  SvgGenImage get low => const SvgGenImage('assets/icons/low.svg');

  /// File path: assets/icons/news.svg
  SvgGenImage get news => const SvgGenImage('assets/icons/news.svg');

  /// File path: assets/icons/privacy.svg
  SvgGenImage get privacy => const SvgGenImage('assets/icons/privacy.svg');

  /// File path: assets/icons/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/icons/settings.svg');

  /// File path: assets/icons/terms.svg
  SvgGenImage get terms => const SvgGenImage('assets/icons/terms.svg');

  /// File path: assets/icons/theme.svg
  SvgGenImage get theme => const SvgGenImage('assets/icons/theme.svg');

  /// File path: assets/icons/time.svg
  SvgGenImage get time => const SvgGenImage('assets/icons/time.svg');

  /// File path: assets/icons/version.svg
  SvgGenImage get version => const SvgGenImage('assets/icons/version.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        back,
        calc,
        calendar,
        change,
        chevronDown,
        close,
        contactUs,
        high,
        home,
        low,
        news,
        privacy,
        settings,
        terms,
        theme,
        time,
        version
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  /// File path: assets/images/onboarding_1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding_1.png');

  /// File path: assets/images/onboarding_2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding_2.png');

  /// File path: assets/images/onboarding_3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/images/onboarding_3.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [icon, onboarding1, onboarding2, onboarding3];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
