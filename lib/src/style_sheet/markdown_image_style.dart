part of 'markdown_style_sheet.dart';

/// Defines the style for images in a Markdown document.
class MarkdownImageStyle {
  /// Creates a [MarkdownImageStyle] instance.
  ///
  /// The [alignment] defaults to [PlaceholderAlignment.bottom] if not specified.
  const MarkdownImageStyle({
    this.textStyle,
    this.alignment = PlaceholderAlignment.bottom,
    this.baseline,
  });

  /// The text style to apply to the image's alternative text.
  final TextStyle? textStyle;

  /// The alignment of the image relative to the surrounding text.
  final PlaceholderAlignment alignment;

  /// The baseline alignment for the image.
  final TextBaseline? baseline;

  MarkdownImageStyle merge(MarkdownImageStyle? other) {
    if (other == null) return this;
    return MarkdownImageStyle(
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      alignment: other.alignment,
      baseline: other.baseline ?? baseline,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownImageStyle &&
        other.textStyle == textStyle &&
        other.alignment == alignment &&
        other.baseline == baseline;
  }

  @override
  int get hashCode => Object.hashAll([
        textStyle,
        alignment,
        baseline,
      ]);
}

/// Holds configuration data for an image in a Markdown document.
class MarkdownImageConfig {
  /// Creates a new [MarkdownImageConfig] instance.
  MarkdownImageConfig({
    required this.uri,
    this.title,
    this.alt,
    this.width,
    this.height,
  });

  /// The URI of the image.
  final Uri uri;

  /// The title of the image, displayed on hover.
  final String? title;

  /// The alternative text for the image, displayed if the image cannot be loaded.
  final String? alt;

  /// The desired width of the image.
  final double? width;

  /// The desired height of the image.
  final double? height;
}
