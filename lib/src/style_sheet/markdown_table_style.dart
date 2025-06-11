part of 'markdown_style_sheet.dart';

class MarkdownTableStyle {
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

  final TextStyle? headStyle;
  final TextAlign headAlign;
  final Decoration? headDecoration;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final Decoration? decoration;
  final TableBorder? border;
  final Map<int, TableColumnWidth>? columnWidths;
  final TableColumnWidth defaultColumnWidth;
  final TableCellVerticalAlignment defaultVerticalAlignment;
  final EdgeInsets cellsPadding;
  final int? cellsMaxLines;
  final bool? thumbVisibility;
  final EdgeInsets margin;
  final EdgeInsets padding;

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
