// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'material.dart';

/// Asserts that the given context has a [Material] ancestor.
///
/// Used by many material design widgets to make sure that they are
/// only used in contexts where they can print ink onto some material.
///
/// To call this function, use the following pattern, typically in the
/// relevant Widget's build method:
///
/// ```dart
/// assert(debugCheckHasMaterial(context));
/// ```
///
/// Does nothing if asserts are disabled. Always returns true.
bool debugCheckHasMaterial(BuildContext context) {
  assert(() {
    if (context.widget is! Material && context.ancestorWidgetOfExactType(Material) == null) {
      final StringBuffer message = new StringBuffer();

      const String brightRed = '\u001b[31;1m';
      const String resetColor = '\u001b[0m';
      message.writeln(
        brightRed + '${context.widget.runtimeType} widgets require '
        'a Material widget ancestor, but we couldn\'t find any.' + resetColor + '\n'
      ); // Kandarp: "who" is speaking to the user?
      message.writeln(
        'Explanation'
        '\nIn material design, most widgets are conceptually "printed" on '
        'a sheet of material. In Flutter\'s material library, that '
        'material is represented by the Material widget. It is the '
        'Material widget that renders ink splashes, for instance. '
        'Because of this, many material library widgets require that '
        'there be a Material widget in the tree above them.'
      );
      message.writeln(
        '\nSuggested Fix'
        // Kandarp: we could provide an "error signature" that could be
        // looked up if users want more information
        '\nTo introduce a Material widget, you can either directly '
        'include one, or use a widget that contains Material itself, '
        'such as a Card, Dialog, Drawer, or Scaffold.\n'
      );

      // kkhandwala@: Highlighting the widget.
      const String brightBlue = '\u001b[34;1m'; // must be the same color as in framework.dart
      message.writeln(
        'The specific widget that could not find a Material ancestor was:'
      );
      var parenIndex = '${context.widget}'.indexOf('(');
      message.write(
        '  ' + brightBlue + '${context.widget}'.split('(')[0] + resetColor
      );
      if (parenIndex != -1)
        message.writeln('${context.widget}'.substring(parenIndex));
      else
        message.writeln('');

      final List<Widget> ancestors = <Widget>[];
      context.visitAncestorElements((Element element) {
        ancestors.add(element.widget);
        return true;
      });
      if (ancestors.isNotEmpty) {
        message.write('\nThe ancestors of this widget were:');
        // https://jonasjacek.github.io/colors/
        const String gray78 = '\u001b[38;5;251m';
        int lineCount = 0;
        for (Widget ancestor in ancestors) {
          // kkhandwala@: we do not want to emphasize the parameters.
          var parenthesisIndex = '$ancestor'.indexOf('(');
          message.write('\n  ' + '$ancestor'.split('(')[0]);
          if (parenthesisIndex != -1)
            message.write(
              gray78 + '$ancestor'.substring(parenthesisIndex) + resetColor
            );
          lineCount++;
          if (lineCount == 5)
            break;
        }
        // Kandarp: for the terminal, there could be a verbose mode for errors
        message.writeln('\n  ...');
        // Kandarp: the stack trace is shown by default and may not be relevant here
      } else {
        message.writeln(
          '\nThis widget is the root of the tree, so it has no '
          'ancestors, let alone a "Material" ancestor.'
        );
      }
      throw new FlutterError(message.toString());
    }
    return true;
  }());
  return true;
}
