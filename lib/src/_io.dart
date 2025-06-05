import 'dart:io' show File, Platform;

import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';

import 'markdown_rich_text.dart' show MarkdownStyleSheetBaseTheme;
import 'style_sheet/markdown_style_sheet.dart';

MarkdownStyleSheet getFallbackStyleSheet({
  required BuildContext context,
  required MarkdownStyleSheetBaseTheme baseTheme,
}) {
  return switch (baseTheme) {
    MarkdownStyleSheetBaseTheme.platform
        when (Platform.isIOS || Platform.isMacOS) =>
      MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)),
    MarkdownStyleSheetBaseTheme.cupertino =>
      MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)),
    _ => MarkdownStyleSheet.fromTheme(Theme.of(context)),
  };
}

Widget buildImageWidget(
  MarkdownImageConfig config, {
  String? imageDirectory,
}) {
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
      final fileUri = Uri.parse([imageDirectory ?? '', config.uri].join());
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
