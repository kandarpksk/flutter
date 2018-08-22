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

      const String brightRed = '\u001b[1;31m';
      const String bold = '\u001b[1m';
      const String resetFormatting = '\u001b[0m';
      message.writeln(
        brightRed + '${context.widget.runtimeType} widgets require '
        'a Material widget ancestor, but we couldn\'t find any.' + resetFormatting + '\n'
      ); // Kandarp: "who" is speaking to the user?
      message.writeln(
        '${bold}Explanation${resetFormatting}'
        '\nIn material design, most widgets are conceptually "printed" on '
        'a sheet of material. In Flutter\'s material library, that '
        'material is represented by the Material widget. It is the '
        'Material widget that renders ink splashes, for instance. '
        'Because of this, many material library widgets require that '
        'there be a Material widget in the tree above them.\n'
        // Kandarp: Filip's suggestions of adding links could apply here.
      );
      message.writeln(
        '${bold}Suggested Fix${resetFormatting}'
        '\nTo introduce a Material widget, you can either directly '
        'include one, or use a widget that contains Material itself, '
        'such as a Card, Dialog, Drawer, or Scaffold.\n'
      );

      const String boldBlue = '\u001b[34;1m'; // must be the same color as in framework.dart
      message.writeln(
        'The specific widget that could not find a Material ancestor was:'
      );
      // kkhandwala@: Highlighting the widget.
      var parenIndex = '${context.widget}'.indexOf('(');
      message.write(
        '  ' + boldBlue + '${context.widget}'.split('(')[0] + resetFormatting
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
        // kkhandwala@: This would ideally be at par with the Android Studio
        // widget inspector. TODO: Highlight user-instantiated widgets
        // (while graying out platform/internal system widgets)
        message.write('\nThe ancestors of this widget were:');
        // https://jonasjacek.github.io/colors/
        const String gray78 = '\u001b[38;5;251m';
        int lineCount = 0;
        for (Widget ancestor in ancestors) {
          // kkhandwala@: Showing the parameters in gray.
          var parenthesisIndex = '$ancestor'.indexOf('(');
          message.write('\n  ' + '$ancestor'.split('(')[0]);
          if (parenthesisIndex != -1)
            message.write(
              gray78 + '$ancestor'.substring(parenthesisIndex) + resetFormatting
            );
          lineCount++;
          if (lineCount == 5)
            break;
        }
        message.writeln('\n  ...');
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
