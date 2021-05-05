import '../json_lib.dart' as json_lib;

extension JsonMapExtensions on Map<String, dynamic> {
  T pathValue<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValue(path, this, valueMapper);
  }

  T? pathValueOptional<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValueOptional<T>(path, this, valueMapper);
  }

  T value<T>(String fieldName, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonValue(fieldName, this, valueMapper);
  }

  T? valueOptional<T>(
    String fieldName, [
    T Function(dynamic)? valueMapper,
  ]) {
    return json_lib.jsonValueOptional(fieldName, this, valueMapper);
  }

  List<T> valueList<T>(String fieldName, [T Function(dynamic)? listItemMapper]) {
    return json_lib.jsonValueList(fieldName, this, listItemMapper);
  }

  List<T>? valueListOptional<T>(String fieldName, [T Function(dynamic)? listItemMapper]) {
    return json_lib.jsonValueListOptional(fieldName, this, listItemMapper);
  }
}

extension JsonListExtensions on List<dynamic> {
  T pathValue<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValue(path, this, valueMapper);
  }

  T? pathValueOptional<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValueOptional<T>(path, this, valueMapper);
  }

  T listItem<T>(int index, [T Function(dynamic)? listItemMapper]) {
    return json_lib.jsonListItem(index, this, listItemMapper);
  }

  T? listItemOptional<T>(int index, [T Function(dynamic)? listItemMapper]) {
    return json_lib.jsonListItemOptional(index, this, listItemMapper);
  }
}
