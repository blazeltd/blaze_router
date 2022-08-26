import 'dart:async';

void l(Object? message) {
  final isDebug = Zone.current[#debug] as bool? ?? false;
  if (isDebug) {
    Zone.root.print(
      '[$red${DateTime.now()}$reset]:$green $message $reset\n'
      '$yellow<=============================================>$reset',
    );
  }
}

const green = '\u001B[32m';
const red = '\u001B[31m';
const yellow = '\u001B[33m';
const reset = '\u001B[0m';
