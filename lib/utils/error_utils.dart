import 'dart:io';

import 'package:graphql/client.dart';
import 'package:space_x/resources/app_strings.dart';

abstract class ErrorUtils {
  static String getErrorMessage(Object exception) {
    if (exception is OperationException) {
      return _processOperationException(exception);
    } else {
      return AppString.defaultError;
    }
  }

  static String _processOperationException(OperationException exception) {
    final graphqlErrors = exception.graphqlErrors;
    final linkException = exception.linkException;

    if (graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.map((error) => error.message).join('.');
    } else if (linkException != null) {
      final originalException = linkException.originalException;
      if (originalException is SocketException) {
        return AppString.noInternetConnectionError;
      }
    }
    return AppString.defaultError;
  }
}
