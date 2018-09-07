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

      final String brightRed = '\u001b[1;31m';
      final String bold = '\u001b[1m';
      final String resetFormatting = '\u001b[0m';
      message.writeln(
        brightRed + '${context.widget.runtimeType} widgets require '
        'a Material widget ancestor, but we couldn\'t find any.'
        + resetFormatting + '\n'
      );
      message.writeln(
        '${bold}Explanation${resetFormatting}'
        // kkhandwala@: Tabs (\t) are not accounted for properly when wrapping
        // while using spaces causes the entire paragraph to be indented.
        '\n    In material design, most widgets are conceptually "printed" on '
        'a sheet of material. In Flutter\'s material library, that '
        'material is represented by the Material widget. It is the '
        'Material widget that renders ink splashes, for instance. '
        'Because of this, many material library widgets require that '
        'there be a Material widget in the tree above them.\n'
      );
      message.writeln(
        '${bold}Potential Fix${resetFormatting}'
        '\n    To introduce a Material widget, you can either directly '
        'include one, or use a widget that contains Material itself, '
        'such as a Card, Dialog, Drawer, or Scaffold.\n'
      );

      // kkhandwala@: should be the same shade as in framework.dart
      final String boldBlue = '\u001b[34;1m';
      final String gray78 = '\u001b[38;5;251m';
      message.writeln(
        'The specific widget that could not find a Material ancestor was:'
      );
      final String path = '///Users/kkhandwala/development/';
      var location = getCreationLocation(context.widget).toString().replaceAll(path, '');
      // kkhandwala@: Using the default shade of green for now.
      final String green = '\u001b[32m';
      message.writeln(green + location + resetFormatting);
      // kkhandwala@: Highlighting the widget.
      var parenIndex = '${context.widget}'.indexOf('(');
      message.write(
        '  ' + boldBlue + '${context.widget}'.split('(')[0] + resetFormatting
      );
      if (parenIndex != -1)
        message.writeln(gray78 + '${context.widget}'.substring(parenIndex) + resetFormatting);
      else
        message.writeln('');

      final List<Widget> ancestors = <Widget>[];
      context.visitAncestorElements((Element element) {
        ancestors.add(element.widget);
        return true;
      });
      if (ancestors.isNotEmpty) {
        // kkhandwala@: This would ideally be at par with
        // the widget inspector in Android Studio.
        message.write('\nThe ancestors of this widget were:');
        // https://jonasjacek.github.io/colors/
        final String gray78 = '\u001b[38;5;251m';
        int lineCount = 0;
        for (Widget ancestor in ancestors) {
          // kkhandwala@: I don't know if getCreationLocation is intended
          // to be used in this manner, so that's something to check.
          location = getCreationLocation(ancestor).toString().replaceAll(path, '');
          final bool isPackageFlutter = location.contains('packages/flutter/');
          // kkhandwala@: If the ancestors are not user-instantiated widgets,
          // we would ideally show at least some of them.
          if (isPackageFlutter && lineCount > 0) {
            message.writeln('\n  ...');
            break;
          }

          // kkhandwala@: Showing the parameters in gray...
          var parenthesisIndex = '$ancestor'.indexOf('(');
          message.write('\n  ' + '$ancestor'.split('(')[0]);
          if (parenthesisIndex != -1) // ...if there is a parenthesis.
            message.write(
              gray78 + '$ancestor'.substring(parenthesisIndex) + resetFormatting
            );

          if (!isPackageFlutter)
            message.write('\n    ' + green + location + resetFormatting);

          lineCount++;
        }
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
