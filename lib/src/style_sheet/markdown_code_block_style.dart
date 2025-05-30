part of 'markdown_style_sheet.dart';

/// Defines the style for code blocks in Markdown rendering.
class MarkdownCodeBlockStyle {
  /// Creates a [MarkdownCodeBlockStyle] with the specified properties.
  const MarkdownCodeBlockStyle({
    this.textStyle,
    this.decoration,
    this.alignment,
    this.padding = const EdgeInsets.all(8),
    this.margin = EdgeInsets.zero,
  });

  /// The text style to use for code block content.
  final TextStyle? textStyle;

  /// The decoration to apply to the code block container.
  final Decoration? decoration;

  /// The alignment of the code block within its container.
  final AlignmentGeometry? alignment;

  /// The padding inside the code block container.
  final EdgeInsets padding;

  /// The margin outside the code block container.
  final EdgeInsets margin;

  MarkdownCodeBlockStyle merge(MarkdownCodeBlockStyle? other) {
    if (other == null) return this;
    return MarkdownCodeBlockStyle(
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
    return other is MarkdownCodeBlockStyle &&
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
