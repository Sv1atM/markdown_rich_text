part of 'markdown_style_sheet.dart';

/// A style configuration class for customizing the appearance of Markdown tables.
class MarkdownTableStyle {
  /// Creates a `MarkdownTableStyle` with the specified properties.
  const MarkdownTableStyle({
    this.headStyle,
    this.headAlign = TextAlign.center,
    this.headDecoration,
    this.textStyle,
    this.textAlign = TextAlign.left,
    this.decoration,
    this.border,
    this.columnWidths,
    this.defaultColumnWidth = const FlexColumnWidth(),
    this.defaultVerticalAlignment = TableCellVerticalAlignment.middle,
    this.cellsPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.cellsMaxLines,
    this.thumbVisibility,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.only(bottom: 4),
  });

  /// The text style for table header cells.
  final TextStyle? headStyle;

  /// Text alignment for table header cells.
  final TextAlign headAlign;

  /// Decoration applied to table header cells.
  final Decoration? headDecoration;

  /// The text style for table body cells.
  final TextStyle? textStyle;

  /// Text alignment for table body cells.
  final TextAlign textAlign;

  /// Decoration applied to table body cells.
  final Decoration? decoration;

  /// Border applied to the table.
  final TableBorder? border;

  /// Column width overrides keyed by column index.
  final Map<int, TableColumnWidth>? columnWidths;

  /// Default column width used when no override is provided.
  final TableColumnWidth defaultColumnWidth;

  /// Default vertical alignment for table cells.
  final TableCellVerticalAlignment defaultVerticalAlignment;

  /// Inner padding applied to each table cell.
  final EdgeInsets cellsPadding;

  /// Maximum number of lines allowed in a cell.
  final int? cellsMaxLines;

  /// Whether the scrollbar thumb is visible.
  final bool? thumbVisibility;

  /// Outer margin around the table.
  final EdgeInsets margin;

  /// Outer padding around the table inside scrollable area (if exists).
  final EdgeInsets padding;

  /// Merges this `MarkdownTableStyle` with another one.
  MarkdownTableStyle merge(MarkdownTableStyle? other) {
    if (other == null) return this;
    return MarkdownTableStyle(
      headStyle: headStyle?.merge(other.headStyle) ?? other.headStyle,
      headAlign: other.headAlign,
      headDecoration: other.headDecoration ?? headDecoration,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      textAlign: other.textAlign,
      decoration: other.decoration ?? decoration,
      border: other.border ?? border,
      columnWidths: other.columnWidths ?? columnWidths,
      defaultColumnWidth: other.defaultColumnWidth,
      defaultVerticalAlignment: other.defaultVerticalAlignment,
      cellsPadding: other.cellsPadding,
      cellsMaxLines: other.cellsMaxLines ?? cellsMaxLines,
      thumbVisibility: other.thumbVisibility ?? thumbVisibility,
      margin: other.margin,
      padding: other.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownTableStyle &&
        other.headStyle == headStyle &&
        other.headAlign == headAlign &&
        other.headDecoration == headDecoration &&
        other.textStyle == textStyle &&
        other.textAlign == textAlign &&
        other.decoration == decoration &&
        other.border == border &&
        other.columnWidths == columnWidths &&
        other.defaultColumnWidth == defaultColumnWidth &&
        other.defaultVerticalAlignment == defaultVerticalAlignment &&
        other.cellsPadding == cellsPadding &&
        other.cellsMaxLines == cellsMaxLines &&
        other.thumbVisibility == thumbVisibility &&
        other.margin == margin &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hashAll([
        headStyle,
        headAlign,
        headDecoration,
        textStyle,
        textAlign,
        decoration,
        border,
        columnWidths,
        defaultColumnWidth,
        defaultVerticalAlignment,
        cellsPadding,
        cellsMaxLines,
        thumbVisibility,
        margin,
        padding,
      ]);
}
