part of 'markdown_style_sheet.dart';

/// Defines the style properties for blockquote elements in Markdown rendering.
class MarkdownBlockquoteStyle {
  /// Creates a [MarkdownBlockquoteStyle] with the specified properties.
  const MarkdownBlockquoteStyle({
    this.textStyle,
    this.decoration,
    this.alignment,
    this.padding = const EdgeInsets.all(8),
    this.margin = EdgeInsets.zero,
  });

  /// The text style to apply to blockquote content.
  final TextStyle? textStyle;

  /// The decoration to apply around the blockquote.
  final Decoration? decoration;

  /// The alignment of the blockquote content.
  final AlignmentGeometry? alignment;

  /// The padding inside the blockquote.
  final EdgeInsets padding;

  /// The margin around the blockquote.
  final EdgeInsets margin;

  MarkdownBlockquoteStyle merge(MarkdownBlockquoteStyle? other) {
    if (other == null) return this;
    return MarkdownBlockquoteStyle(
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      decoration: other.decoration ?? decoration,
      alignment: other.alignment ?? alignment,
      padding: other.padding,
      margin: other.margin,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownBlockquoteStyle &&
        other.textStyle == textStyle &&
        other.decoration == decoration &&
        other.alignment == alignment &&
        other.padding == padding &&
        other.margin == margin;
  }

  @override
  int get hashCode => Object.hashAll([
        textStyle,
        decoration,
        alignment,
        padding,
        margin,
      ]);
}
