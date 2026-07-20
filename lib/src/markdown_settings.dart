import 'package:flutter/foundation.dart' show listEquals;
import 'package:markdown/markdown.dart'
    show BlockSyntax, ExtensionSet, InlineSyntax;

export 'package:markdown/src/block_syntaxes/alert_block_syntax.dart';
export 'package:markdown/src/block_syntaxes/block_syntax.dart';
export 'package:markdown/src/block_syntaxes/blockquote_syntax.dart';
export 'package:markdown/src/block_syntaxes/code_block_syntax.dart';
export 'package:markdown/src/block_syntaxes/dummy_block_syntax.dart';
export 'package:markdown/src/block_syntaxes/empty_block_syntax.dart';
export 'package:markdown/src/block_syntaxes/fenced_blockquote_syntax.dart';
export 'package:markdown/src/block_syntaxes/fenced_code_block_syntax.dart';
export 'package:markdown/src/block_syntaxes/footnote_def_syntax.dart';
export 'package:markdown/src/block_syntaxes/header_syntax.dart';
export 'package:markdown/src/block_syntaxes/header_with_id_syntax.dart';
export 'package:markdown/src/block_syntaxes/horizontal_rule_syntax.dart';
export 'package:markdown/src/block_syntaxes/html_block_syntax.dart';
export 'package:markdown/src/block_syntaxes/link_reference_definition_syntax.dart';
export 'package:markdown/src/block_syntaxes/list_syntax.dart';
export 'package:markdown/src/block_syntaxes/ordered_list_syntax.dart';
export 'package:markdown/src/block_syntaxes/ordered_list_with_checkbox_syntax.dart';
export 'package:markdown/src/block_syntaxes/paragraph_syntax.dart';
export 'package:markdown/src/block_syntaxes/setext_header_syntax.dart';
export 'package:markdown/src/block_syntaxes/setext_header_with_id_syntax.dart';
export 'package:markdown/src/block_syntaxes/table_syntax.dart';
export 'package:markdown/src/block_syntaxes/unordered_list_syntax.dart';
export 'package:markdown/src/block_syntaxes/unordered_list_with_checkbox_syntax.dart';
export 'package:markdown/src/extension_set.dart';
export 'package:markdown/src/inline_syntaxes/autolink_extension_syntax.dart';
export 'package:markdown/src/inline_syntaxes/autolink_syntax.dart';
export 'package:markdown/src/inline_syntaxes/code_syntax.dart';
export 'package:markdown/src/inline_syntaxes/color_swatch_syntax.dart';
export 'package:markdown/src/inline_syntaxes/decode_html_syntax.dart';
export 'package:markdown/src/inline_syntaxes/delimiter_syntax.dart';
export 'package:markdown/src/inline_syntaxes/email_autolink_syntax.dart';
export 'package:markdown/src/inline_syntaxes/emoji_syntax.dart';
export 'package:markdown/src/inline_syntaxes/emphasis_syntax.dart';
export 'package:markdown/src/inline_syntaxes/escape_html_syntax.dart';
export 'package:markdown/src/inline_syntaxes/escape_syntax.dart';
export 'package:markdown/src/inline_syntaxes/image_syntax.dart';
export 'package:markdown/src/inline_syntaxes/inline_html_syntax.dart';
export 'package:markdown/src/inline_syntaxes/inline_syntax.dart';
export 'package:markdown/src/inline_syntaxes/line_break_syntax.dart';
export 'package:markdown/src/inline_syntaxes/link_syntax.dart';
export 'package:markdown/src/inline_syntaxes/soft_line_break_syntax.dart';
export 'package:markdown/src/inline_syntaxes/strikethrough_syntax.dart';
export 'package:markdown/src/inline_syntaxes/text_syntax.dart';

/// Configuration options for Markdown parsing behavior used by this package.
class MarkdownSettings {
  /// Creates a set of Markdown parser settings.
  ///
  /// Custom block and inline syntaxes can be supplied to extend or override the
  /// default parser behavior.
  const MarkdownSettings({
    this.blockSyntaxes = const [],
    this.inlineSyntaxes = const [],
    this.extensionSet,
    this.enableTagfilter = false,
  });

  /// Additional block-level syntaxes to use while parsing Markdown.
  final Iterable<BlockSyntax> blockSyntaxes;

  /// Additional inline syntaxes to use while parsing Markdown.
  final Iterable<InlineSyntax> inlineSyntaxes;

  /// The Markdown extension set that controls enabled syntax extensions.
  final ExtensionSet? extensionSet;

  /// Whether HTML tag filtering should be enabled during parsing.
  final bool enableTagfilter;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownSettings &&
        listEquals(other.blockSyntaxes.toList(), blockSyntaxes.toList()) &&
        listEquals(other.inlineSyntaxes.toList(), inlineSyntaxes.toList()) &&
        other.extensionSet == extensionSet &&
        other.enableTagfilter == enableTagfilter;
  }

  @override
  int get hashCode => Object.hashAll([
        blockSyntaxes,
        inlineSyntaxes,
        extensionSet,
        enableTagfilter,
      ]);
}
