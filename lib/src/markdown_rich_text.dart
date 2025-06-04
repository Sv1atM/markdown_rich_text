import 'dart:io' show File, Platform;

import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' show parseFragment;
import 'package:markdown/markdown.dart' hide Text;

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
  /// Unordered list (bulleted).
  unordered,

  /// Ordered list (numbered).
  ordered,
}

/// A specialized [TextSpan] for use with Markdown rendering.
///
/// This class allows for additional semantic meaning or customization
/// when building rich text trees from Markdown content.
class MarkdownTextSpan extends TextSpan {
  /// Creates a [MarkdownTextSpan].
  ///
  /// The [text] parameter must not be null.
  const MarkdownTextSpan({
    required String super.text,
    super.children,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  });
}

/// A [TextSpan] that acts as a spacer in the Markdown rendering process.
class SpacerTextSpan extends TextSpan {
  /// Creates a [SpacerTextSpan].
  const SpacerTextSpan();
}

/// A widget that renders a [MarkdownTextSpan] as rich text with optional styling and interaction.
///
/// This widget allows for custom Markdown styling, theming, and tap handling.
class MarkdownRichText extends StatefulWidget {
  /// Creates a [MarkdownRichText] widget.
  ///
  /// The [textSpan] parameter must not be null.
  const MarkdownRichText(
    this.textSpan, {
    this.settings = const MarkdownSettings(),
    this.styleSheet,
    this.styleSheetTheme = MarkdownStyleSheetBaseTheme.material,
    this.onLinkTap,
    this.imageDirectory,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  });

  /// The text to display as a [InlineSpan].
  final InlineSpan textSpan;

  /// The Markdown parser settings.
  final MarkdownSettings settings;

  /// Optional custom [MarkdownStyleSheet] to merge with default styles.
  final MarkdownStyleSheet? styleSheet;

  /// The base theme to use for the [MarkdownStyleSheet].
  final MarkdownStyleSheetBaseTheme styleSheetTheme;

  /// Callback invoked when a link is tapped, with the link's URL string.
  final void Function(String)? onLinkTap;

  /// The base directory holding images referenced by Img tags with local or network file paths.
  final String? imageDirectory;

  /// Optional [StrutStyle] for text layout.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The text direction to use for rendering.
  final TextDirection? textDirection;

  /// The [TextScaler] to use for scaling text.
  final TextScaler? textScaler;

  /// The maximum number of lines to display before truncating.
  final int? maxLines;

  /// An optional semantic label for accessibility.
  final String? semanticsLabel;

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
  late Document _document;
  late MarkdownStyleSheet _styleSheet;

  List<html.Node> _parseMarkdown(String text) {
    final input = renderToHtml(
      _document.parse(text),
      enableTagfilter: widget.settings.enableTagfilter,
    );
    return parseFragment(input).nodes;
  }

  void _createDocument() {
    _document = Document(
      blockSyntaxes: widget.settings.blockSyntaxes,
      inlineSyntaxes: widget.settings.inlineSyntaxes,
      extensionSet: widget.settings.extensionSet ?? ExtensionSet.gitHubFlavored,
    );
  }

  void _createStyleSheet() {
    final fallbackStyleSheet = switch (widget.styleSheetTheme) {
      MarkdownStyleSheetBaseTheme.material =>
        MarkdownStyleSheet.fromTheme(Theme.of(context)),
      MarkdownStyleSheetBaseTheme.cupertino =>
        MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)),
      MarkdownStyleSheetBaseTheme.platform =>
        (Platform.isIOS || Platform.isMacOS)
            ? MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context))
            : MarkdownStyleSheet.fromTheme(Theme.of(context)),
    };
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
  Widget build(BuildContext context) {
    final blockSpacer = TextSpan(
      text: '\n',
      style: TextStyle(fontSize: _styleSheet.blockSpacing, height: 1),
    );

    return _buildRichTextWidget(
      textScaler: widget.textScaler ?? MediaQuery.textScalerOf(context),
      style: _styleSheet.p,
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
    TextScaler? textScaler,
    int? maxLines,
    List<InlineSpan>? children,
  }) {
    return Text.rich(
      TextSpan(text: text, children: children),
      style: style,
      strutStyle: widget.strutStyle,
      textAlign: textAlign ?? widget.textAlign,
      textDirection: widget.textDirection,
      textScaler: textScaler ?? TextScaler.noScaling,
      maxLines: maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );
  }

  Widget _buildImageWidget(MarkdownImageConfig config) {
    switch (config.uri.scheme) {
      case 'https':
      case 'http':
        return Image.network(
          config.uri.toString(),
          width: config.width,
          height: config.height,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        );

      case 'resource':
        return Image.asset(
          config.uri.path,
          width: config.width,
          height: config.height,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        );

      case 'data':
        final data = config.uri.data!;
        if (data.mimeType.startsWith('image/')) {
          return Image.memory(
            data.contentAsBytes(),
            width: config.width,
            height: config.height,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          );
        }
        if (data.mimeType.startsWith('text/')) {
          return Text(data.contentAsString());
        }
        return const SizedBox.shrink();

      default:
        final fileUri = Uri.parse(
          [widget.imageDirectory ?? '', config.uri].join(),
        );
        if (fileUri.scheme == 'https' || fileUri.scheme == 'http') {
          return Image.network(
            fileUri.toString(),
            width: config.width,
            height: config.height,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          );
        } else {
          try {
            return Image.file(
              File.fromUri(fileUri),
              width: config.width,
              height: config.height,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            );
          } catch (_) {
            return const SizedBox.shrink();
          }
        }
    }
  }

  List<InlineSpan>? _mapChildren(
    List<InlineSpan>? children, {
    required InlineSpan blockSpacer,
  }) {
    if (children == null) return null;
    return [
      for (final child in children)
        if (child is MarkdownTextSpan)
          TextSpan(
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
    int listLevel = 0,
    VoidCallback? onTap,
  }) sync* {
    for (final node in nodes) {
      if (node is html.Element) {
        switch (node.localName) {
          case 'br':
            yield const TextSpan(text: '\n');

          case 'ol' || 'ul':
            yield* _buildListSpans(
              node.nodes,
              blockSpacer: blockSpacer,
              textStyle: _styleSheet.textStyles['li'],
              type: (node.localName == 'ul')
                  ? MarkdownListType.unordered
                  : MarkdownListType.ordered,
              level: listLevel,
              start: int.parse(node.attributes['start'] ?? '1'),
            );

          case 'blockquote':
            yield _buildBlockquoteSpan(
              node.nodes,
              blockSpacer: blockSpacer,
              textStyle: _styleSheet.textStyles[node.localName],
            );

          case 'pre':
            yield _buildCodeBlockSpan(
              node.text,
              textStyle: _styleSheet.textStyles[node.localName],
            );

          case 'hr':
            yield _buildHorizontalRuleSpan();

          case 'img':
            yield _buildImageSpan(
              config: MarkdownImageConfig(
                uri: Uri.parse(node.attributes['src']!),
                title: node.attributes['title'],
                alt: node.attributes['alt'],
                width: double.tryParse(node.attributes['width'] ?? ''),
                height: double.tryParse(node.attributes['height'] ?? ''),
              ),
              textStyle: _styleSheet.textStyles[node.localName],
            );

          default:
            final textStyle = _styleSheet.textStyles[node.localName];
            yield* _buildRichTextTree(
              node.nodes,
              blockSpacer: blockSpacer,
              style: style?.merge(textStyle) ?? textStyle,
              listLevel: listLevel,
              onTap: switch (node.localName) {
                'a' => () => widget.onLinkTap?.call(
                      node.attributes['href'] as String,
                    ),
                _ => null,
              },
            );
        }
      } else {
        yield TextSpan(
          text: node.text,
          style: style,
          recognizer: (onTap != null) ? TapGestureRecognizer() : null
            ?..onTap = onTap,
        );
        if (node.text == '\n') yield blockSpacer;
      }
    }
  }

  Iterable<InlineSpan> _buildListSpans(
    List<html.Node> nodes, {
    required InlineSpan blockSpacer,
    required MarkdownListType type,
    required TextStyle? textStyle,
    required int level,
    int start = 1,
  }) sync* {
    final listStyle = _styleSheet.list;
    final listItems = nodes
        .whereType<html.Element>()
        .where((element) => element.localName == 'li')
        .toList();
    final bulletStyle = (textStyle ?? const TextStyle()).merge(
      switch (type) {
        MarkdownListType.unordered => listStyle.bulletStyle,
        MarkdownListType.ordered => listStyle.numberStyle,
      },
    );
    final bulletTextPainter = TextPainter(
      text: TextSpan(
        text: switch (type) {
          MarkdownListType.unordered => listStyle.bullet,
          MarkdownListType.ordered => '${listItems.length}.',
        },
        style: bulletStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final bulletWidth = switch (type) {
      MarkdownListType.unordered => bulletTextPainter.width,
      MarkdownListType.ordered => bulletTextPainter.width.ceil() + 2.0,
    };
    final bulletPadding = switch (type) {
      MarkdownListType.unordered => listStyle.bulletPadding,
      MarkdownListType.ordered => listStyle.numberPadding,
    };
    final indentPadding = EdgeInsets.only(left: listStyle.indent);

    for (final node in nodes) {
      if (node is html.Element) {
        final index = listItems.indexOf(node);
        if (index > 0 || level > 0) yield blockSpacer;
        yield WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: indentPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Padding(
                  padding: bulletPadding,
                  child: SizedBox(
                    width: bulletWidth,
                    child: index.isNegative
                        ? null
                        : _buildRichTextWidget(
                            text: switch (type) {
                              MarkdownListType.unordered => listStyle.bullet,
                              MarkdownListType.ordered => '${start + index}.',
                            },
                            style: bulletStyle,
                            textAlign: TextAlign.right,
                          ),
                  ),
                ),
                Flexible(
                  child: _buildRichTextWidget(
                    style: textStyle,
                    children: _buildRichTextTree(
                      (node.nodes.lastOrNull?.text == '\n')
                          ? node.nodes.sublist(0, node.nodes.length - 1)
                          : node.nodes,
                      blockSpacer: blockSpacer,
                      listLevel: level + 1,
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (node != nodes.first && node != nodes.last) {
        yield TextSpan(text: node.text); // '\n' symbol
      }
    }
  }

  InlineSpan _buildBlockquoteSpan(
    List<html.Node> nodes, {
    required InlineSpan blockSpacer,
    required TextStyle? textStyle,
  }) {
    final blockStyle = _styleSheet.blockquote;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        decoration: blockStyle.decoration,
        alignment: blockStyle.alignment,
        padding: blockStyle.padding,
        margin: blockStyle.margin,
        child: _buildRichTextWidget(
          style: textStyle,
          textAlign: TextAlign.left,
          children: _buildRichTextTree(
            (nodes.length < 2)
                ? nodes
                : [
                    if (nodes.firstOrNull?.text != '\n') nodes.first,
                    ...nodes.sublist(1, nodes.length - 1),
                    if (nodes.lastOrNull?.text != '\n') nodes.last,
                  ],
            blockSpacer: blockSpacer,
          ).toList(),
        ),
      ),
    );
  }

  InlineSpan _buildCodeBlockSpan(
    String text, {
    required TextStyle? textStyle,
  }) {
    final blockStyle = _styleSheet.codeblock;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        decoration: blockStyle.decoration,
        alignment: blockStyle.alignment,
        padding: blockStyle.padding,
        margin: blockStyle.margin,
        child: _buildRichTextWidget(
          text: (text.characters.lastOrNull == '\n')
              ? text.substring(0, text.length - 1)
              : text,
          style: textStyle,
          textAlign: TextAlign.left,
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
    required TextStyle? textStyle,
  }) {
    final imageStyle = _styleSheet.image;
    return WidgetSpan(
      alignment: imageStyle.alignment,
      baseline: imageStyle.baseline,
      child: DefaultTextStyle.merge(
        style: textStyle,
        child: imageStyle.builder?.call(config) ?? _buildImageWidget(config),
      ),
    );
  }
}
