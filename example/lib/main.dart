import 'package:material_ui/material_ui.dart';
import 'package:markdown_rich_text/markdown_rich_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final testInput = [
      for (var i = 1; i <= 6; i++) '${'#' * i} H$i\n',
      'Link: [Google](https://www.google.com)',
      'Image link: ![Simpsons](scratchpad/images/b/bd/Homer_Simpson.png#33x44 "Homer Simpson")',
      '**Bold text**',
      '_Italic text_',
      '***Bold italic text***',
      '~~Strikethrough text~~',
      'Code: `print("Hello, World!")`',
      '\n```dart\nvoid main() {\n\tfinal value = sqrt(pow(a, 2) + pow(b, 2));\n}\n```\n',
      [
        'List examples:',
        '1. Item 1',
        '2. Item 2',
        'New line',
        '\t* Item 2.1',
        '\t\t* Item 2.1.1',
        '3. Item 3',
        '\t* Item 3.1',
        '- Unordered list item',
        '- [x] Done',
        '- [ ] Undone',
        '\t- [x] Nested item',
      ].join('\n'),
      '\n---\n',
      [
        '| Name | Value1 | Value2 | Value3 | Value4 | Value5 |',
        '|------|--------|--------|--------|--------|--------|',
        '| Item 1 | 10   | 15     | 20     | 30     | 50     |',
        '| Item 2 | 20   | 25     | 30     | 40     | 60     |',
      ].join('\n'),
      '\n\nEmojies: :smile::scream: :hankey:',
      '\n> Blockquote example with a **link**: *[Google](https://www.google.com)*',
      '\n>> This is a nested blockquote.',
      '\n<sub>subscript</sub> and <sup>superscript</sup> text.',
      '\n\n<custom label="label">and text</custom>',
    ].join(' ');

    const imagesDirectory = 'https://static.wikia.nocookie.net/';

    return MaterialApp(
      theme: ThemeData(cardColor: Colors.grey.shade300),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: MarkdownRichText(
              MarkdownTextSpan(text: testInput),
              settings: const MarkdownSettings(),
              styleSheet: MarkdownStyleSheet(
                stylesExtension: const {
                  'sub': TextStyle(fontFeatures: [FontFeature.subscripts()]),
                  'sup': TextStyle(fontFeatures: [FontFeature.superscripts()]),
                },
                buildersExtension: {
                  'custom': (e) sync* {
                    yield WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.ac_unit,
                        size: e.textStyle?.fontSize,
                        color: e.textStyle?.color,
                      ),
                    );
                    yield TextSpan(
                      text: e.element.attributes['label'],
                      style: const TextStyle(
                        letterSpacing: -1,
                        fontFeatures: [FontFeature.subscripts()],
                      ),
                    );
                    yield const TextSpan(text: ' ');
                    // Reuse existing builders to parse child nodes
                    yield* e.parseChildren(e.element.nodes);
                  },
                },
                blockSpacing: 4,
              ),
              onLinkTap: print,
              imageDirectory: imagesDirectory,
            ),
          ),
        ),
      ),
    );
  }
}
