
import 'package:flutter/material.dart';

void errorLog(
    {required String reason,
      required String classError,
      required String methodError}) {
  debugPrint('---ERROR----------------------------------------------------\n'
      'Class where error: $classError\n'
      'Method where error: $methodError\n'
      'Reason: $reason'
      '\n------------------------------------------------------------------');
}