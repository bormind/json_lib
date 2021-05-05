import 'package:json_lib/json_lib.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'json.dart';
import 'models.dart';

void main() {
  group('Can read json', () {
    test('Can read values', () {
      final simpleJson = {'intField': 5, 'stringField': 'foo', 'doubleField': 2.3, 'nullField': null};

      expect(jsonValue('intField', simpleJson), 5);
      expect(jsonValue('stringField', simpleJson), 'foo');
      expect(jsonValue('doubleField', simpleJson), 2.3);

      expect(jsonValueOptional('doubleField', simpleJson), 2.3);
      expect(jsonValueOptional('stringField', simpleJson), 'foo');
      expect(jsonValueOptional('nullField', simpleJson), null);
      expect(jsonValueOptional('missingField', simpleJson), null);
    });

    test('Can convert json list to list', () {
      final jsonList = <dynamic>[1, 2, 3];
      expect(asJsonList(jsonList), [1, 2, 3]);
    });

    test('Can read Jason List Item by index', () {
      final jsonList = [1, 'foo', 3];
      expect(jsonListItem(1, jsonList), 'foo');
      expect(jsonListItem(2, jsonList), 3);
    });

    test('Can read json path', () {
      expect(jsonPathValue([1, 'name'], albumsJson), 'Songs from a Room');
      expect(jsonPathValue([1, 'tracks', 0, 'duration'], albumsJson), 208);
    });

    test('Can handle invalid path values', () {
      expectThrow(() {
        jsonPathValue([1, 'tracks', 'zzz', 'duration'], albumsJson);
      }, 'Jason data is a List but path value zzz is not an Int. Only Int values accepted as an index of the list');

      expectThrow(() {
        jsonPathValue([1, 'tracks', 10, 'duration'], albumsJson);
      }, 'Value at path [1, tracks, 10] is not found. Use Optional version of the function if value could be missing');

      expectThrow(() {
        jsonPathValue([1, 3], albumsJson);
      }, 'Jason data is a Map but path value 3 is not a String. Only string values accepted as a json map keys');
    });

    test('Can catch value not found error', () {
      final simpleJson = {'intField': 5, 'stringField': 'foo', 'doubleField': 2.3, 'nullField': null};

      expectThrow(() {
        jsonValue('nullField', simpleJson);
      }, 'Value "nullField" is not found. Use Optional version of the function if value could be missing');

      expectThrow(() {
        jsonValue('missingField', simpleJson);
      }, 'Value "missingField" is not found. Use Optional version of the function if value could be missing');
    });

    test('Can deserialize nested Json Data', () {
      final albums = asJsonList(albumsJson, Album.deserialize);

      expect(albums.length == 2, true);
      expect(albums[1].artist.name, 'Leonard Cohen');
      expect(albums[0].artist.founded, 1982);
      expect(albums[1].artist.founded, null);
      expect(albums[1].tracks[1].name, 'Story of Isaac');
    });
  });
}
