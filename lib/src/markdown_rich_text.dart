import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' show parseFragment;
import 'package:markdown/markdown.dart'
    show Document, ExtensionSet, renderToHtml;

import '_io.dart' if (dart.library.js_interop) '_web.dart';
import 'markdown_settings.dart';
import 'style_sheet/markdown_style_sheet.dart';

enum MarkdownStyleSheetBaseTheme {
  /// Creates a MarkdownStyleSheet based on MaterialTheme.
  material,

  /// Creates a MarkdownStyleSheet based on CupertinoTheme.
  cupertino,

  /// Creates a MarkdownStyleSheet whose theme is based on the current platform.
  platform,
}

enum MarkdownListType {
  /// Ordered list (numbered).
  ordered,

  /// Unordered list (bulleted).
  unordered,
}

/// A specialized `TextSpan` for use with Markdown rendering.
///
/// This class allows for additional semantic meaning or customization
/// when building rich text trees from Markdown content.
class MarkdownTextSpan extends TextSpan {
  /// Creates a `MarkdownTextSpan`.
  ///
  /// The `text` parameter must not be null.
  const MarkdownTextSpan({
    required String super.text,
    super.children,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.semanticsIdentifier,
    super.locale,
    super.spellOut,
  });
}

/// A `TextSpan` that acts as a spacer in the Markdown rendering process.
class SpacerTextSpan extends TextSpan {
  /// Creates a `SpacerTextSpan`.
  const SpacerTextSpan();
}

/// A widget that renders a `MarkdownTextSpan` as rich text with optional styling and interaction.
///
/// This widget allows for custom Markdown styling, theming, and tap handling.
class MarkdownRichText extends StatefulWidget {
  /// Creates a `MarkdownRichText` widget.
  ///
  /// The `textSpan` parameter must not be null.
  const MarkdownRichText(
    this.textSpan, {
    this.settings = const MarkdownSettings(),
    this.styleSheet,
    this.styleSheetTheme = MarkdownStyleSheetBaseTheme.material,
    this.onLinkTap,
    this.imageBuilder,
    this.imageDirectory,
    this.strutStyle,
    this.textAlign = TextAlign.left,
    this.textDirection,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  });

  /// The text to display as a `InlineSpan`.
  final InlineSpan textSpan;

  /// The Markdown parser settings.
  final MarkdownSettings settings;

  /// Optional custom `MarkdownStyleSheet` to merge with default styles.
  final MarkdownStyleSheet? styleSheet;

  /// The base theme to use for the `MarkdownStyleSheet`.
  final MarkdownStyleSheetBaseTheme styleSheetTheme;

  /// Callback invoked when a link is tapped, with the link's URL string.
  final void Function(String)? onLinkTap;

  /// A custom builder for rendering the image widget.
  ///
  /// If provided, this function is used to build the image widget
  /// using the given `MarkdownImageConfig`.
  final Widget Function(MarkdownImageConfig)? imageBuilder;

  /// The base directory holding images referenced by Img tags with local or network file paths.
  final String? imageDirectory;

  /// Optional `StrutStyle` for text layout.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The text direction to use for rendering.
  final TextDirection? textDirection;

  /// The overflow strategy for text that exceeds the available space.
  final TextOverflow? overflow;

  /// The `TextScaler` to use for scaling text.
  final TextScaler? textScaler;

  /// The maximum number of lines to display before truncating.
  final int? maxLines;

  /// An alternative semantics label for this text.
  final String? semanticsLabel;

  /// A unique identifier for the semantics node for this widget.
  final String? semanticsIdentifier;

  /// The strategy to use for determining the width of the text.
  final TextWidthBasis? textWidthBasis;

  /// The strategy to use for determining the height of the text.
  final TextHeightBehavior? textHeightBehavior;

  /// The color to use for text selection highlights.
  final Color? selectionColor;

  @override
  State<MarkdownRichText> createState() => _MarkdownRichTextState();
}

class _MarkdownRichTextState extends State<MarkdownRichText> {
  final _gestureRecognisers = <TapGestureRecognizer>[];

  late TextScaler _textScaler;
  late DefaultTextStyle _defaultStyle;
  late Document _document;
  late MarkdownStyleSheet _styleSheet;

  double get _scaleFactor => _textScaler.scale(1);

  List<html.Node> _parseMarkdown(String text) {
    final leadingSpaces = RegExp(r'^ +').firstMatch(text)?.group(0)?.length;
    final trailingSpaces = RegExp(r' +$').firstMatch(text)?.group(0)?.length;
    final input = [
      if (leadingSpaces != null) ' ' * leadingSpaces,
      renderToHtml(
        _document.parse(text),
        enableTagfilter: widget.settings.enableTagfilter,
      ),
      if (trailingSpaces != null) ' ' * trailingSpaces,
    ].join();
    return parseFragment(input).nodes;
  }

  void _createDocument() {
    _document = Document(
      blockSyntaxes: widget.settings.blockSyntaxes,
      inlineSyntaxes: widget.settings.inlineSyntaxes,
      extensionSet: widget.settings.extensionSet ?? ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    );
  }

  void _createStyleSheet() {
    final fallbackStyleSheet = getFallbackStyleSheet(
      context: context,
      baseTheme: widget.styleSheetTheme,
    );
    _styleSheet = fallbackStyleSheet.merge(widget.styleSheet);
  }

  @override
  void initState() {
    super.initState();
    _createDocument();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textScaler = widget.textScaler ?? MediaQuery.textScalerOf(context);
    _defaultStyle = DefaultTextStyle.of(context);
    _createStyleSheet();
  }

  @override
  void didUpdateWidget(covariant MarkdownRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) _createDocument();
    if (oldWidget.styleSheet != widget.styleSheet ||
        oldWidget.styleSheetTheme != widget.styleSheetTheme) {
      _createStyleSheet();
    }
  }

  @override
  void dispose() {
    for (final recogniser in _gestureRecognisers) {
      recogniser.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = _styleSheet.blockSpacing / _scaleFactor;
    final blockSpacer = TextSpan(
      text: '\n',
      style: TextStyle(fontSize: spacing, height: 1),
    );

    for (final recogniser in _gestureRecognisers) {
      recogniser.dispose();
    }
    _gestureRecognisers.clear();

    return _buildRichTextWidget(
      textScaler: _textScaler,
      style: _styleSheet.p,
      overflow: widget.overflow,
      maxLines: widget.maxLines,
      children: _mapChildren(
        [widget.textSpan],
        blockSpacer: blockSpacer,
      ),
    );
  }

  Widget _buildRichTextWidget({
    String? text,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    TextScaler textScaler = TextScaler.noScaling,
    int? maxLines,
    List<InlineSpan>? children,
  }) {
    return Text.rich(
      TextSpan(text: text, children: children),
      style: style,
      strutStyle: widget.strutStyle,
      textAlign: textAlign ?? widget.textAlign,
      textDirection: widget.textDirection,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: widget.semanticsLabel,
      semanticsIdentifier: widget.semanticsIdentifier,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );
  }

  Widget _buildTableWidget(
    List<html.Node> nodes, {
    required MarkdownTableStyle tableStyle,
    required InlineSpan blockSpacer,
    required int columnsCount,
    required TextStyle headStyle,
    required TextStyle bodyStyle,
  }) {
    final rows = nodes.whereType<html.Element>();
    final cells = rows.map((row) => row.nodes.whereType<html.Element>());
    final cellPadding = tableStyle.cellsPadding / _scaleFactor;
    final headDecoration = tableStyle.headDecoration?.scale(_scaleFactor);
    final bodyDecoration = tableStyle.decoration?.scale(_scaleFactor);
    final fallbackDecoration = tableStyle.applyToAll ? bodyDecoration : null;
    return Table(
      columnWidths: tableStyle.columnWidths,
      defaultColumnWidth: tableStyle.defaultColumnWidth,
      border: tableStyle.border,
      defaultVerticalAlignment: tableStyle.defaultVerticalAlignment,
      children: [
        for (var i = 0; i < rows.length; i++)
          TableRow(
            decoration: switch (i) {
              0 => headDecoration ?? fallbackDecoration,
              _ => i.isEven ? bodyDecoration : fallbackDecoration,
            },
            children: List.generate(columnsCount, (j) {
              final element = cells.elementAt(i).elementAtOrNull(j);
              if (element == null) return const SizedBox.shrink();
              final textAlign = switch (element.attributes['align']) {
                'left' => TextAlign.left,
                'center' => TextAlign.center,
                'right' => TextAlign.right,
                _ => null,
              };
              if (i == 0) {
                return TableCell(
                  verticalAlignment: tableStyle.headVerticalAlignment,
                  child: Padding(
                    padding: cellPadding,
                    child: _buildRichTextWidget(
                      style: headStyle,
                      textAlign: textAlign ?? tableStyle.headAlign,
                      maxLines: tableStyle.cellsMaxLines,
                      children: _buildRichTextTree(
                        element.nodes,
                        blockSpacer: blockSpacer,
                      ).toList(),
                    ),
                  ),
                );
              }
              return TableCell(
                child: Padding(
                  padding: cellPadding,
                  child: _buildRichTextWidget(
                    style: bodyStyle,
                    textAlign: textAlign ?? tableStyle.textAlign,
                    maxLines: tableStyle.cellsMaxLines,
                    children: _buildRichTextTree(
                      element.nodes,
                      blockSpacer: blockSpacer,
                    ).toList(),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  List<InlineSpan>? _mapChildren(
    Iterable<InlineSpan>? children, {
    required InlineSpan blockSpacer,
  }) {
    if (children == null) return null;
    return [
      for (final child in children)
        if (child is MarkdownTextSpan)
          TextSpan(
            mouseCursor: child.mouseCursor,
            onEnter: child.onEnter,
            onExit: child.onExit,
            semanticsLabel: child.semanticsLabel,
            semanticsIdentifier: child.semanticsIdentifier,
            locale: child.locale,
            spellOut: child.spellOut,
            children: [
              ..._buildRichTextTree(
                _parseMarkdown(child.text!),
                blockSpacer: blockSpacer,
              ),
              ...?_mapChildren(
                child.children,
                blockSpacer: blockSpacer,
              ),
            ],
          )
        else if (child is SpacerTextSpan) ...[
          const TextSpan(text: '\n'),
          blockSpacer,
        ] else if (child is TextSpan)
          TextSpan(
            text: child.text,
            style: child.style,
            recognizer: child.recognizer,
            mouseCursor: child.mouseCursor,
            onEnter: child.onEnter,
            onExit: child.onExit,
            semanticsLabel: child.semanticsLabel,
            semanticsIdentifier: child.semanticsIdentifier,
            locale: child.locale,
            spellOut: child.spellOut,
            children: _mapChildren(
              child.children,
              blockSpacer: blockSpacer,
            ),
          )
        else
          child,
    ];
  }

  Iterable<InlineSpan> _buildRichTextTree(
    List<html.Node> nodes, {
    required InlineSpan blockSpacer,
    TextStyle? style,
    int level = 0,
    VoidCallback? onTap,
    EdgeInsets padding = EdgeInsets.zero,
  }) sync* {
    for (final node in nodes) {
      switch (node) {
        case html.Element():
          switch (_styleSheet.buildersExtension[node.localName]) {
            case null:
              switch (node.localName) {
                case 'br':
                  yield const TextSpan(text: '\n');

                case 'ol' || 'ul':
                  yield* _buildListSpans(
                    node.nodes,
                    blockSpacer: blockSpacer,
                    textStyle: _styleSheet.textStyles['li']!,
                    type: switch (node.localName) {
                      'ol' => MarkdownListType.ordered,
                      _ => MarkdownListType.unordered,
                    },
                    level: level,
                    start: int.parse(node.attributes['start'] ?? '1'),
                  );

                case 'table':
                  yield _buildTableSpan(
                    node.nodes,
                    blockSpacer: blockSpacer,
                    headStyle: _styleSheet.textStyles['th']!,
                    bodyStyle: _styleSheet.textStyles['td']!,
                  );

                case 'blockquote':
                  yield _buildBlockquoteSpan(
                    node.nodes,
                    blockSpacer: blockSpacer,
                    textStyle: _styleSheet.textStyles[node.localName]!,
                  );

                case 'pre':
                  yield _buildCodeBlockSpan(
                    node.text,
                    textStyle: _styleSheet.textStyles[node.localName]!,
                  );

                case 'hr':
                  yield _buildHorizontalRuleSpan();

                case 'img':
                  final src = node.attributes['src']?.split('#');
                  if (src?.firstOrNull?.isEmpty ?? true) continue;
                  var dimensions = src!.elementAtOrNull(1)?.split('x');
                  if (dimensions?.length != 2) {
                    dimensions = [
                      node.attributes['width'].toString(),
                      node.attributes['height'].toString(),
                    ];
                  }
                  final imageSize = dimensions!.map(double.tryParse);
                  yield _buildImageSpan(
                    config: MarkdownImageConfig(
                      uri: Uri.parse(src.first),
                      title: node.attributes['title'],
                      alt: node.attributes['alt'],
                      width: imageSize.elementAt(0),
                      height: imageSize.elementAt(1),
                    ),
                    textStyle: _styleSheet.textStyles[node.localName]!,
                  );

                case 'input':
                  final textStyle = _styleSheet.textStyles[node.localName]!;
                  final child = switch (node.attributes['type']) {
                    'checkbox' => Icon(
                        (node.attributes['checked'] == 'true')
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: textStyle.fontSize,
                        color: textStyle.color,
                      ),
                    _ => null,
                  };
                  if (child == null) continue;
                  yield WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(padding: padding, child: child),
                  );

                default:
                  final textStyle = _styleSheet.textStyles[node.localName];
                  yield* _buildRichTextTree(
                    node.nodes,
                    blockSpacer: blockSpacer,
                    style: style?.merge(textStyle) ?? textStyle,
                    level: level,
                    onTap: switch (node.localName) {
                      'a' => () => widget.onLinkTap?.call(
                            node.attributes['href'] as String,
                          ),
                      _ => null,
                    },
                  );
              }

            case final builder:
              final textStyle = _styleSheet.textStyles[node.localName];
              final mdNode = MarkdownNode(
                element: node,
                styleSheet: _styleSheet,
                textStyle:
                    style?.merge(textStyle) ?? textStyle ?? _styleSheet.p,
                nestLevel: level,
                parseChildren: (nodes, {int? nestLevel}) {
                  assert(
                    nestLevel == null || !nestLevel.isNegative,
                    '"nestLevel" must be non-negative',
                  );
                  return _buildRichTextTree(
                    nodes,
                    blockSpacer: blockSpacer,
                    style: style,
                    level: nestLevel ?? level,
                    onTap: onTap,
                  ).toList();
                },
              );
              yield* _mapChildren(
                builder.call(mdNode),
                blockSpacer: blockSpacer,
              )!;
          }

        case html.Text():
          final recognizer = switch (onTap) {
            null => null,
            _ => TapGestureRecognizer()..onTap = onTap,
          };
          if (recognizer != null) _gestureRecognisers.add(recognizer);
          yield TextSpan(
            text: node.text,
            style: style,
            recognizer: recognizer,
          );
          if (node.text == '\n') yield blockSpacer;
      }
    }
  }

  Iterable<InlineSpan> _buildListSpans(
    List<html.Node> nodes, {
    required InlineSpan blockSpacer,
    required MarkdownListType type,
    required TextStyle textStyle,
    required int level,
    int start = 1,
  }) sync* {
    final listStyle = _styleSheet.list;
    final items = nodes.whereType<html.Element>();
    final bulletStyle = textStyle.merge(
      switch (type) {
        MarkdownListType.ordered => listStyle.numberStyle,
        MarkdownListType.unordered => listStyle.bulletStyle,
      },
    );
    final digitsCount = (start + items.length - 1).toString().length;
    final bulletConstraints = BoxConstraints(
      minWidth: (listStyle.shrinkWrap || type != MarkdownListType.unordered)
          ? 0
          : List.generate(10, (i) {
              final text = i.toString() * digitsCount + '.';
              return TextPainter(
                text: TextSpan(text: text, style: bulletStyle),
                textDirection: TextDirection.ltr,
              )..layout();
            }).reduce((a, b) => a.width > b.width ? a : b).width,
    );
    final bulletPadding = switch (type) {
      MarkdownListType.unordered => listStyle.bulletPadding / _scaleFactor,
      MarkdownListType.ordered => listStyle.numberPadding / _scaleFactor,
    };
    final indent = SizedBox(width: listStyle.indent / _scaleFactor);
    for (var i = 0; i < items.length; i++) {
      final element = items.elementAt(i);
      if (i > 0 || level > 0) yield blockSpacer;
      yield WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: _defaultStyle.style.textBaseline,
          children: [
            indent,
            switch (element.querySelector('input')) {
              null => Padding(
                  padding: bulletPadding,
                  child: ConstrainedBox(
                    constraints: bulletConstraints,
                    child: _buildRichTextWidget(
                      text: switch (type) {
                        MarkdownListType.ordered => '${start + i}.',
                        MarkdownListType.unordered => listStyle.bullet,
                      },
                      style: bulletStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              final input => _buildRichTextWidget(
                  children: _buildRichTextTree(
                    [input.remove()],
                    level: level,
                    blockSpacer: blockSpacer,
                    style: bulletStyle,
                    padding: bulletPadding,
                  ).toList(),
                ),
            },
            Flexible(
              child: _buildRichTextWidget(
                children: _buildRichTextTree(
                  element.nodes.where((e) => e.text != '\n').toList(),
                  blockSpacer: blockSpacer,
                  level: level + 1,
                  style: textStyle,
                ).toList(),
              ),
            ),
          ],
        ),
      );
    }
  }

  InlineSpan _buildTableSpan(
    List<html.Node> nodes, {
    required InlineSpan blockSpacer,
    required TextStyle headStyle,
    required TextStyle bodyStyle,
  }) {
    final tableStyle = _styleSheet.table;
    final tableRows = nodes
        .whereType<html.Element>()
        .expand(
          (e) => e.nodes
              .whereType<html.Element>()
              .where((e) => e.localName == 'tr'),
        )
        .toList();
    final columnsCount = tableRows.first.nodes.whereType<html.Element>().length;
    final columnWidths = List.generate(
      columnsCount,
      (i) => tableStyle.columnWidths?[i] ?? tableStyle.defaultColumnWidth,
    );
    final tableWidget = _buildTableWidget(
      tableRows,
      tableStyle: tableStyle,
      blockSpacer: blockSpacer,
      columnsCount: columnsCount,
      headStyle: headStyle,
      bodyStyle: bodyStyle,
    );
    const scrollableTypes = {FixedColumnWidth, IntrinsicColumnWidth};
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: tableStyle.margin / _scaleFactor,
        child: columnWidths.any((e) => !scrollableTypes.contains(e.runtimeType))
            ? tableWidget
            : _ScrollControllerProvider(
                builder: (context, controller) => Scrollbar(
                  controller: controller,
                  thumbVisibility: tableStyle.thumbVisibility,
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    padding: tableStyle.padding,
                    child: tableWidget,
                  ),
                ),
              ),
      ),
    );
  }

  InlineSpan _buildBlockquoteSpan(
    List<html.Node> nodes, {
    required InlineSpan blockSpacer,
    required TextStyle textStyle,
  }) {
    final blockStyle = _styleSheet.blockquote;
    while (nodes.firstOrNull?.text == '\n') {
      nodes.removeAt(0);
    }
    while (nodes.lastOrNull?.text == '\n') {
      nodes.removeLast();
    }
    if (nodes.isEmpty) return const TextSpan();
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        constraints: switch (widget.textAlign != TextAlign.justify) {
          true when blockStyle.shrinkWrap => const BoxConstraints(),
          _ => const BoxConstraints(minWidth: double.infinity),
        },
        decoration: blockStyle.decoration?.scale(_scaleFactor),
        alignment: blockStyle.alignment,
        padding: blockStyle.padding / _scaleFactor,
        margin: blockStyle.margin / _scaleFactor,
        child: _buildRichTextWidget(
          style: textStyle,
          children: _buildRichTextTree(
            nodes,
            blockSpacer: blockSpacer,
          ).toList(),
        ),
      ),
    );
  }

  InlineSpan _buildCodeBlockSpan(
    String text, {
    required TextStyle textStyle,
  }) {
    final blockStyle = _styleSheet.codeblock;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        constraints: switch (widget.textAlign != TextAlign.justify) {
          true when blockStyle.shrinkWrap => const BoxConstraints(),
          _ => const BoxConstraints(minWidth: double.infinity),
        },
        decoration: blockStyle.decoration?.scale(_scaleFactor),
        alignment: blockStyle.alignment,
        margin: blockStyle.margin / _scaleFactor,
        child: _ScrollControllerProvider(
          builder: (context, controller) => Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding: blockStyle.padding / _scaleFactor,
              child: _buildRichTextWidget(
                text: (text.characters.lastOrNull == '\n')
                    ? text.substring(0, text.length - 1)
                    : text,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  InlineSpan _buildHorizontalRuleSpan() {
    final lineStyle = _styleSheet.horizontalRule;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Divider(
        color: lineStyle.color,
        thickness: lineStyle.thickness,
        height: lineStyle.thickness,
      ),
    );
  }

  InlineSpan _buildImageSpan({
    required MarkdownImageConfig config,
    required TextStyle textStyle,
  }) {
    final imageStyle = _styleSheet.image;
    return WidgetSpan(
      alignment: imageStyle.alignment,
      baseline: imageStyle.baseline,
      child: DefaultTextStyle.merge(
        style: textStyle,
        child: widget.imageBuilder?.call(config) ??
            buildImageWidget(
              config,
              imageDirectory: widget.imageDirectory,
            ),
      ),
    );
  }
}

class _ScrollControllerProvider extends StatefulWidget {
  const _ScrollControllerProvider({
    required this.builder,
  });

  final Widget Function(BuildContext, ScrollController) builder;

  @override
  State<_ScrollControllerProvider> createState() =>
      _ScrollControllerProviderState();
}

class _ScrollControllerProviderState extends State<_ScrollControllerProvider> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

extension _DecorationScaling on Decoration {
  Decoration scale(double scaleFactor) {
    final decoration = this;
    final scale = 1 / scaleFactor;
    if (decoration is BoxDecoration) {
      return decoration.copyWith(
        border: decoration.border?.scale(scale) as BoxBorder?,
        boxShadow: decoration.boxShadow?.map((e) => e.scale(scale)).toList(),
        gradient: decoration.gradient?.scale(scale),
      );
    }
    if (decoration is ShapeDecoration) {
      return ShapeDecoration(
        color: decoration.color,
        image: decoration.image,
        gradient: decoration.gradient?.scale(scale),
        shadows: decoration.shadows?.map((e) => e.scale(scale)).toList(),
        shape: decoration.shape.scale(scale),
      );
    }
    return decoration;
  }
}
