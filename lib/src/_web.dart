import 'dart:js_interop' show JS, JSString, JSStringToString;

import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'markdown_rich_text.dart' show MarkdownStyleSheetBaseTheme;
import 'style_sheet/markdown_style_sheet.dart';

MarkdownStyleSheet getFallbackStyleSheet({
  required BuildContext context,
  required MarkdownStyleSheetBaseTheme baseTheme,
}) {
  return switch (baseTheme) {
    MarkdownStyleSheetBaseTheme.platform
        when _userAgent.toDart.contains('Mac OS X') =>
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
      final Uri fileUri;

      if (imageDirectory == null) {
        fileUri = config.uri;
      } else {
        try {
          fileUri = Uri.parse(path.join(imageDirectory, config.uri.toString()));
        } catch (_) {
          return const SizedBox.shrink();
        }
      }

      return Image.network(
        switch (fileUri.scheme) {
          'https' || 'http' => fileUri.toString(),
          _ => path.join(path.current, fileUri.toString()),
        },
        width: config.width,
        height: config.height,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
  }
}

@JS('window.navigator.userAgent')
external JSString get _userAgent;
