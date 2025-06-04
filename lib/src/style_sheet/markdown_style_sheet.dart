import 'package:flutter/cupertino.dart'
    show CupertinoThemeData, CupertinoColors;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'markdown_blockquote_style.dart';
part 'markdown_code_block_style.dart';
part 'markdown_horizontal_rule_style.dart';
part 'markdown_image_style.dart';
part 'markdown_list_style.dart';

/// A class that defines the styles used for rendering Markdown elements.
class MarkdownStyleSheet {
  /// Creates a [MarkdownStyleSheet] with the specified properties.
  MarkdownStyleSheet({
    this.a,
    this.p,
    this.code,
    this.h1,
    this.h2,
    this.h3,
    this.h4,
    this.h5,
    this.h6,
    this.em,
    this.strong,
    this.del,
    this.stylesExtension = const {},
    this.list = const MarkdownListStyle(),
    this.blockquote = const MarkdownBlockquoteStyle(),
    this.codeblock = const MarkdownCodeBlockStyle(),
    this.image = const MarkdownImageStyle(),
    this.horizontalRule = const MarkdownHorizontalRuleStyle(),
    this.blockSpacing = 8,
  }) : textStyles = Map.unmodifiable({
          'a': a,
          'b': strong,
          'blockquote': blockquote.textStyle ?? p,
          'code': code,
          'del': del,
          'em': em,
          'h1': h1,
          'h2': h2,
          'h3': h3,
          'h4': h4,
          'h5': h5,
          'h6': h6,
          'i': em,
          'img': image.textStyle ?? p,
          'li': list.textStyle ?? p,
          'p': p,
          'pre': codeblock.textStyle ?? code,
          's': del,
          'strong': strong,
          ...stylesExtension,
        });

  /// The text style for links.
  final TextStyle? a;

  /// The text style for paragraphs.
  final TextStyle? p;

  /// The text style for inline code.
  final TextStyle? code;

  /// The text style for level 1 headings.
  final TextStyle? h1;

  /// The text style for level 2 headings.
  final TextStyle? h2;

  /// The text style for level 3 headings.
  final TextStyle? h3;

  /// The text style for level 4 headings.
  final TextStyle? h4;

  /// The text style for level 5 headings.
  final TextStyle? h5;

  /// The text style for level 6 headings.
  final TextStyle? h6;

  /// The text style for emphasis.
  final TextStyle? em;

  /// The text style for strong emphasis.
  final TextStyle? strong;

  /// The text style for deleted text.
  final TextStyle? del;

  /// The extension for [TextStyle]s.
  final Map<String, TextStyle?> stylesExtension;

  /// The style for lists.
  final MarkdownListStyle list;

  /// The style for blockquotes.
  final MarkdownBlockquoteStyle blockquote;

  /// The style for code blocks.
  final MarkdownCodeBlockStyle codeblock;

  /// The style for images.
  final MarkdownImageStyle image;

  /// The style for horizontal rules.
  final MarkdownHorizontalRuleStyle horizontalRule;

  /// The spacing between block elements.
  final double blockSpacing;

  /// The text styles Map.
  final Map<String, TextStyle?> textStyles;

  /// Creates a [MarkdownStyleSheet] from the [TextStyle]s in the provided [ThemeData].
  factory MarkdownStyleSheet.fromTheme(ThemeData theme) => MarkdownStyleSheet(
        a: const TextStyle(color: Colors.blue),
        p: theme.textTheme.bodyMedium,
        code: theme.textTheme.bodyMedium!.copyWith(
          fontSize: theme.textTheme.bodySmall!.fontSize,
          fontFamily: 'monospace',
        ),
        h1: theme.textTheme.headlineSmall,
        h2: theme.textTheme.titleLarge,
        h3: theme.textTheme.titleMedium,
        h4: theme.textTheme.bodyLarge,
        h5: theme.textTheme.bodyLarge,
        h6: theme.textTheme.bodyLarge,
        em: const TextStyle(fontStyle: FontStyle.italic),
        strong: const TextStyle(fontWeight: FontWeight.bold),
        del: const TextStyle(decoration: TextDecoration.lineThrough),
        blockquote: MarkdownBlockquoteStyle(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        codeblock: MarkdownCodeBlockStyle(
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        horizontalRule: MarkdownHorizontalRuleStyle(color: theme.dividerColor),
      );

  /// Creates a [MarkdownStyleSheet] from the [TextStyle]s in the provided [CupertinoThemeData].
  factory MarkdownStyleSheet.fromCupertinoTheme(CupertinoThemeData theme) {
    final fontSize = theme.textTheme.textStyle.fontSize ?? 17;
    return MarkdownStyleSheet(
      a: theme.textTheme.textStyle.copyWith(
        color: (theme.brightness == Brightness.dark)
            ? CupertinoColors.link.darkColor
            : CupertinoColors.link.color,
      ),
      p: theme.textTheme.textStyle,
      code: theme.textTheme.textStyle.copyWith(
        fontSize: fontSize * 0.85,
        fontFamily: 'monospace',
      ),
      h1: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize + 10,
      ),
      h2: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize + 8,
      ),
      h3: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize + 6,
      ),
      h4: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize + 4,
      ),
      h5: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize + 2,
      ),
      h6: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
      ),
      em: theme.textTheme.textStyle.copyWith(
        fontStyle: FontStyle.italic,
      ),
      strong: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.bold,
      ),
      del: theme.textTheme.textStyle.copyWith(
        decoration: TextDecoration.lineThrough,
      ),
      blockquote: MarkdownBlockquoteStyle(
        decoration: BoxDecoration(
          color: (theme.brightness == Brightness.dark)
              ? CupertinoColors.systemGrey6.darkColor
              : CupertinoColors.systemGrey6.color,
          border: Border(
            left: BorderSide(
              color: (theme.brightness == Brightness.dark)
                  ? CupertinoColors.systemGrey4.darkColor
                  : CupertinoColors.systemGrey4.color,
              width: 4,
            ),
          ),
        ),
      ),
      codeblock: MarkdownCodeBlockStyle(
        decoration: BoxDecoration(
          color: (theme.brightness == Brightness.dark)
              ? CupertinoColors.systemGrey6.darkColor
              : CupertinoColors.systemGrey6.color,
        ),
      ),
      horizontalRule: MarkdownHorizontalRuleStyle(
        color: (theme.brightness == Brightness.dark)
            ? CupertinoColors.systemGrey4.darkColor
            : CupertinoColors.systemGrey4.color,
      ),
    );
  }

  /// Merges this [MarkdownStyleSheet] with another one.
  MarkdownStyleSheet merge(MarkdownStyleSheet? other) {
    if (other == null) return this;
    return MarkdownStyleSheet(
      a: a!.merge(other.a),
      p: p!.merge(other.p),
      code: code!.merge(other.code),
      h1: h1!.merge(other.h1),
      h2: h2!.merge(other.h2),
      h3: h3!.merge(other.h3),
      h4: h4!.merge(other.h4),
      h5: h5!.merge(other.h5),
      h6: h6!.merge(other.h6),
      em: em!.merge(other.em),
      strong: strong!.merge(other.strong),
      del: del!.merge(other.del),
      stylesExtension: {...stylesExtension, ...other.stylesExtension},
      list: list.merge(other.list),
      blockquote: blockquote.merge(other.blockquote),
      codeblock: codeblock.merge(other.codeblock),
      image: image.merge(other.image),
      horizontalRule: horizontalRule.merge(other.horizontalRule),
      blockSpacing: other.blockSpacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownStyleSheet &&
        other.a == a &&
        other.p == p &&
        other.code == code &&
        other.h1 == h1 &&
        other.h2 == h2 &&
        other.h3 == h3 &&
        other.h4 == h4 &&
        other.h5 == h5 &&
        other.h6 == h6 &&
        other.em == em &&
        other.strong == strong &&
        other.del == del &&
        other.list == list &&
        mapEquals(other.stylesExtension, stylesExtension) &&
        other.blockquote == blockquote &&
        other.codeblock == codeblock &&
        other.image == image &&
        other.horizontalRule == horizontalRule &&
        other.blockSpacing == blockSpacing;
  }

  @override
  int get hashCode => Object.hashAll([
        a,
        p,
        code,
        h1,
        h2,
        h3,
        h4,
        h5,
        h6,
        em,
        strong,
        del,
        list,
        stylesExtension,
        blockquote,
        codeblock,
        image,
        horizontalRule,
        blockSpacing,
      ]);
}
