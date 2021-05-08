import 'package:json_lib/json_lib_extensions.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'json.dart';
import 'models.dart';

void main() {
  group('Can read json', () {
    test('Can read values', () {
      final simpleJson = {'intField': 5, 'stringField': 'foo', 'doubleField': 2.3, 'nullField': null};

      expect(simpleJson.value('intField'), 5);
      expect(simpleJson.value('stringField'), 'foo');
      expect(simpleJson.value('doubleField'), 2.3);

      expect(simpleJson.valueOptional('doubleField'), 2.3);
      expect(simpleJson.valueOptional('stringField'), 'foo');
      expect(simpleJson.valueOptional('nullField'), null);
      expect(simpleJson.valueOptional('missingField'), null);
    });

    test('Can read Jason List Item by index', () {
      final jsonList = [1, 'foo', 3];
      expect(jsonList.listItem(1), 'foo');
      expect(jsonList.listItem(2), 3);
    });

    test('Can read json path', () {
      expect(albumsJson.pathValue([1, 'name']), 'Songs from a Room');
      expect(albumsJson.pathValue([1, 'tracks', 0, 'duration']), 208);
      expect(albumsJson.pathValue([1, 'tracks', 0, 'duration']), 208);
      expect(albumsJson.pathValue([1, 'genre'], tryParseGenre), Genre.Folk);
    });

    test('Can handle invalid path values', () {
      expectThrow(() {
        albumsJson.pathValue([1, 'tracks', 'zzz', 'duration']);
      }, 'Jason data is a List but path value zzz is not an Int. Only Int values accepted as an index of the list');

      expectThrow(() {
        albumsJson.pathValue([1, 'tracks', 10, 'duration']);
      }, 'Value at path [1, tracks, 10] is not found. Use Optional version of the function if value could be missing');

      expectThrow(() {
        albumsJson.pathValue([1, 3]);
      }, 'Jason data is a Map but path value 3 is not a String. Only string values accepted as a json map keys');
    });

    test('Can catch value not found error', () {
      final simpleJson = {'intField': 5, 'stringField': 'foo', 'doubleField': 2.3, 'nullField': null};

      expectThrow(() {
        simpleJson.value('nullField');
      }, 'Value "nullField" is not found. Use Optional version of the function if value could be missing');

      expectThrow(() {
        simpleJson.value('missingField');
      }, 'Value "missingField" is not found. Use Optional version of the function if value could be missing');
    });
  });
}
