import 'package:flutter/foundation.dart';
import 'package:markdown/markdown.dart';

export 'package:markdown/markdown.dart'
    show
        AlertBlockSyntax,
        AutolinkExtensionSyntax,
        BlockSyntax,
        ColorSwatchSyntax,
        EmojiSyntax,
        ExtensionSet,
        FencedCodeBlockSyntax,
        FootnoteDefSyntax,
        HeaderWithIdSyntax,
        InlineHtmlSyntax,
        InlineSyntax,
        OrderedListWithCheckboxSyntax,
        SetextHeaderWithIdSyntax,
        StrikethroughSyntax,
        TableSyntax,
        UnorderedListWithCheckboxSyntax;

class MarkdownSettings {
  const MarkdownSettings({
    this.blockSyntaxes = const [],
    this.inlineSyntaxes = const [],
    this.extensionSet,
    this.enableTagfilter = false,
  });

  final Iterable<BlockSyntax> blockSyntaxes;
  final Iterable<InlineSyntax> inlineSyntaxes;
  final ExtensionSet? extensionSet;
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
