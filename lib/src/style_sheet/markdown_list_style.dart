part of 'markdown_style_sheet.dart';

/// A style configuration class for customizing the appearance of Markdown list items.
class MarkdownListStyle {
  /// Creates a [MarkdownListStyle] with the specified properties.
  const MarkdownListStyle({
    this.indent = 8,
    this.textStyle,
    this.bullet = '•',
    this.bulletStyle,
    this.bulletPadding = const EdgeInsets.only(right: 13),
    this.numberStyle,
    this.numberPadding = const EdgeInsets.only(right: 4),
  });

  /// The indentation for list items.
  final double indent;

  /// The text style for list items.
  final TextStyle? textStyle;

  /// The bullet character for unordered lists.
  final String bullet;

  /// The text style for the bullet in unordered lists.
  final TextStyle? bulletStyle;

  /// The padding applied to the bullet in unordered lists.
  final EdgeInsetsGeometry bulletPadding;

  /// The text style for the number in ordered lists.
  final TextStyle? numberStyle;

  /// The padding applied to the number in ordered lists.
  final EdgeInsetsGeometry numberPadding;

  /// Merges this [MarkdownListStyle] with another one.
  MarkdownListStyle merge(MarkdownListStyle? other) {
    if (other == null) return this;
    return MarkdownListStyle(
      indent: other.indent,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      bullet: other.bullet,
      bulletStyle: other.bulletStyle ?? bulletStyle,
      bulletPadding: other.bulletPadding,
      numberStyle: other.numberStyle ?? numberStyle,
      numberPadding: other.numberPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownListStyle &&
        other.indent == indent &&
        other.textStyle == textStyle &&
        other.bullet == bullet &&
        other.bulletStyle == bulletStyle &&
        other.bulletPadding == bulletPadding &&
        other.numberStyle == numberStyle &&
        other.numberPadding == numberPadding;
  }

  @override
  int get hashCode => Object.hashAll([
        indent,
        textStyle,
        bullet,
        bulletStyle,
        bulletPadding,
        numberStyle,
        numberPadding,
      ]);
}
