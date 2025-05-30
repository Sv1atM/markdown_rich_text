part of 'markdown_style_sheet.dart';

/// Defines the style for a horizontal rule in Markdown rendering.
class MarkdownHorizontalRuleStyle {
  /// Creates a [MarkdownHorizontalRuleStyle] with the specified properties.
  const MarkdownHorizontalRuleStyle({
    this.thickness = 5,
    this.color,
  });

  /// The thickness of the horizontal rule.
  final double thickness;

  /// The color of the horizontal rule.
  final Color? color;

  /// Merges this [MarkdownHorizontalRuleStyle] with another one.
  MarkdownHorizontalRuleStyle merge(MarkdownHorizontalRuleStyle? other) {
    if (other == null) return this;
    return MarkdownHorizontalRuleStyle(
      thickness: other.thickness,
      color: other.color ?? color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownHorizontalRuleStyle &&
        other.thickness == thickness &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hashAll([
        thickness,
        color,
      ]);
}
