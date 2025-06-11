A Markdown RichText widget builder with inline HTML support. Inspired by the original [flutter_markdown](https://pub.dev/packages/flutter_markdown) package and was made as its alternative which has the same base styling.

This package doesn't support all features which the original package has. Also it doesn't have full HTML support.
Which features are supported for now:
- Text styles (`<b>`, `<strong>`, `<i>`, `<em>`, `<s>`, `<del>`, `<code>`)
- Headings (`<h1>`...`<h6>`)
- Links (`<a>`)
- Lists (`<ul>`, `<ol>`, `<li>`)
- Tables (`<table>`, `<thead>`, `<tbody>` `<tr>`, `<th>`, `<td>`)
- Blockquotes (`<blockquote>`)
- Code blocks (`<pre>`, `<code>`)
- Horizontal rules (`<hr>`)
- Images (`<img>`)
- Breaks (`<br>`)

You can simply extend supported HTML styles using a `MarkdownStyleSheet.stylesExtension` set.
Also you can configure the Markdown [syntax extensions](https://pub.dev/packages/markdown#syntax-extensions) and [extension sets](https://pub.dev/packages/markdown#extension-sets) via `MarkdownRichText.settings`.

### How it works

The Markdown text is converted into HTML and then the HTML is mapped into InlineSpans of the RichText. That's how it supports both: the Markdown and HTML styling.
It's built on top of the Dart [markdown](https://pub.dev/packages/markdown) and [html](https://pub.dev/packages/html) packages.

### Usage

```dart
import 'package:markdown_rich_text/markdown_rich_text.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: MarkdownRichText(
          MarkdownTextSpan(
            text: markdownString,
            children: [
              const SpacerTextSpan(), // This will add a space between the text spans
              TextSpan(text: plainText), // This will add a plain text and won't be parsed
            ],
          ),
          styleSheet: MarkdownStyleSheet(), // Optional, you can customize the styles
        ),
      ),
    ),
  );
}
```
