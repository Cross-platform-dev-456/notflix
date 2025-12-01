import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/model/episode.dart';

void main() {
  group('Episode', () {
    group('Constructor', () {
      test('creates Episode with all required fields', () {
        final episode = Episode(
          id: 1,
          name: 'Test Episode',
          overview: 'A test episode overview',
          episodeNumber: 5,
          seasonNumber: 2,
          airDate: '2024-01-15',
          stillPath: '/test-still.jpg',
          voteAverage: 8.5,
          runtime: 45,
        );

        expect(episode.id, 1);
        expect(episode.name, 'Test Episode');
        expect(episode.overview, 'A test episode overview');
        expect(episode.episodeNumber, 5);
        expect(episode.seasonNumber, 2);
        expect(episode.airDate, '2024-01-15');
        expect(episode.stillPath, '/test-still.jpg');
        expect(episode.voteAverage, 8.5);
        expect(episode.runtime, 45);
      });

      test('creates Episode with null stillPath', () {
        final episode = Episode(
          id: 2,
          name: 'Episode without Still',
          overview: 'Test overview',
          episodeNumber: 1,
          seasonNumber: 1,
          airDate: '2024-01-01',
          stillPath: null,
          voteAverage: 7.0,
          runtime: 30,
        );

        expect(episode.stillPath, null);
      });
    });

    group('fromJson', () {
      test('parses valid JSON with all fields', () {
        final json = {
          'id': 123,
          'name': 'The Beginning',
          'overview': 'The story begins',
          'episode_number': 1,
          'season_number': 1,
          'air_date': '2024-03-15',
          'still_path': '/episode-still.jpg',
          'vote_average': 8.2,
          'runtime': 60,
        };

        final episode = Episode.fromJson(json);

        expect(episode.id, 123);
        expect(episode.name, 'The Beginning');
        expect(episode.overview, 'The story begins');
        expect(episode.episodeNumber, 1);
        expect(episode.seasonNumber, 1);
        expect(episode.airDate, '2024-03-15');
        expect(episode.stillPath, '/episode-still.jpg');
        expect(episode.voteAverage, 8.2);
        expect(episode.runtime, 60);
      });

      test('handles null name with empty string default', () {
        final json = {
          'id': 456,
          'name': null,
          'overview': 'Test overview',
          'episode_number': 2,
          'season_number': 1,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 7.0,
          'runtime': 45,
        };

        final episode = Episode.fromJson(json);

        expect(episode.name, '');
      });

      test('handles missing name with empty string default', () {
        final json = {
          'id': 789,
          'overview': 'Test overview',
          'episode_number': 3,
          'season_number': 1,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 6.5,
          'runtime': 40,
        };

        final episode = Episode.fromJson(json);

        expect(episode.name, '');
      });

      test('handles null overview with empty string default', () {
        final json = {
          'id': 111,
          'name': 'No Overview Episode',
          'overview': null,
          'episode_number': 4,
          'season_number': 1,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 7.5,
          'runtime': 50,
        };

        final episode = Episode.fromJson(json);

        expect(episode.overview, '');
      });

      test('handles null episode_number with 0 default', () {
        final json = {
          'id': 222,
          'name': 'Special Episode',
          'overview': 'Test overview',
          'episode_number': null,
          'season_number': 0,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 8.0,
          'runtime': 90,
        };

        final episode = Episode.fromJson(json);

        expect(episode.episodeNumber, 0);
      });

      test('handles null season_number with 0 default', () {
        final json = {
          'id': 333,
          'name': 'Pilot',
          'overview': 'Test overview',
          'episode_number': 0,
          'season_number': null,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 7.0,
          'runtime': 60,
        };

        final episode = Episode.fromJson(json);

        expect(episode.seasonNumber, 0);
      });

      test('handles null air_date with empty string default', () {
        final json = {
          'id': 444,
          'name': 'Unaired Episode',
          'overview': 'Test overview',
          'episode_number': 5,
          'season_number': 2,
          'air_date': null,
          'still_path': '/still.jpg',
          'vote_average': 6.0,
          'runtime': 45,
        };

        final episode = Episode.fromJson(json);

        expect(episode.airDate, '');
      });

      test('handles null still_path', () {
        final json = {
          'id': 555,
          'name': 'No Image Episode',
          'overview': 'Test overview',
          'episode_number': 6,
          'season_number': 2,
          'air_date': '2024-01-01',
          'still_path': null,
          'vote_average': 7.5,
          'runtime': 42,
        };

        final episode = Episode.fromJson(json);

        expect(episode.stillPath, null);
      });

      test('handles missing still_path', () {
        final json = {
          'id': 666,
          'name': 'Missing Image Episode',
          'overview': 'Test overview',
          'episode_number': 7,
          'season_number': 2,
          'air_date': '2024-01-01',
          'vote_average': 8.0,
          'runtime': 48,
        };

        final episode = Episode.fromJson(json);

        expect(episode.stillPath, null);
      });

      test('handles null vote_average with 0.0 default', () {
        final json = {
          'id': 777,
          'name': 'Unrated Episode',
          'overview': 'Test overview',
          'episode_number': 8,
          'season_number': 2,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': null,
          'runtime': 55,
        };

        final episode = Episode.fromJson(json);

        expect(episode.voteAverage, 0.0);
      });

      test('handles null runtime with 0 default', () {
        final json = {
          'id': 888,
          'name': 'Unknown Runtime Episode',
          'overview': 'Test overview',
          'episode_number': 9,
          'season_number': 2,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 7.0,
          'runtime': null,
        };

        final episode = Episode.fromJson(json);

        expect(episode.runtime, 0);
      });

      test('handles missing runtime with 0 default', () {
        final json = {
          'id': 999,
          'name': 'Missing Runtime Episode',
          'overview': 'Test overview',
          'episode_number': 10,
          'season_number': 2,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 6.5,
        };

        final episode = Episode.fromJson(json);

        expect(episode.runtime, 0);
      });

      test('handles all null/missing optional fields', () {
        final json = {
          'id': 1010,
          'name': null,
          'overview': null,
          'episode_number': null,
          'season_number': null,
          'air_date': null,
          'still_path': null,
          'vote_average': null,
          'runtime': null,
        };

        final episode = Episode.fromJson(json);

        expect(episode.id, 1010);
        expect(episode.name, '');
        expect(episode.overview, '');
        expect(episode.episodeNumber, 0);
        expect(episode.seasonNumber, 0);
        expect(episode.airDate, '');
        expect(episode.stillPath, null);
        expect(episode.voteAverage, 0.0);
        expect(episode.runtime, 0);
      });

      test('handles vote_average as int converted to double', () {
        final json = {
          'id': 1111,
          'name': 'Integer Rating Episode',
          'overview': 'Test overview',
          'episode_number': 11,
          'season_number': 3,
          'air_date': '2024-01-01',
          'still_path': '/still.jpg',
          'vote_average': 9,
          'runtime': 60,
        };

        final episode = Episode.fromJson(json);

        expect(episode.voteAverage, 9.0);
      });

      test('handles various episode numbers', () {
        final json = {
          'id': 1212,
          'name': 'Mid Season Finale',
          'overview': 'Exciting cliffhanger',
          'episode_number': 12,
          'season_number': 5,
          'air_date': '2024-06-15',
          'still_path': '/mid-season.jpg',
          'vote_average': 9.5,
          'runtime': 90,
        };

        final episode = Episode.fromJson(json);

        expect(episode.episodeNumber, 12);
        expect(episode.seasonNumber, 5);
      });

      test('handles season 0 (specials)', () {
        final json = {
          'id': 1313,
          'name': 'Behind the Scenes',
          'overview': 'A look behind the scenes',
          'episode_number': 1,
          'season_number': 0,
          'air_date': '2024-12-25',
          'still_path': '/special.jpg',
          'vote_average': 7.0,
          'runtime': 30,
        };

        final episode = Episode.fromJson(json);

        expect(episode.seasonNumber, 0);
        expect(episode.episodeNumber, 1);
      });

      test('handles long runtime for special episodes', () {
        final json = {
          'id': 1414,
          'name': 'Two Hour Special',
          'overview': 'Extended episode',
          'episode_number': 1,
          'season_number': 1,
          'air_date': '2024-01-01',
          'still_path': '/special.jpg',
          'vote_average': 8.5,
          'runtime': 120,
        };

        final episode = Episode.fromJson(json);

        expect(episode.runtime, 120);
      });

      test('handles short runtime for webisodes', () {
        final json = {
          'id': 1515,
          'name': 'Mini Episode',
          'overview': 'Quick recap',
          'episode_number': 1,
          'season_number': 1,
          'air_date': '2024-01-01',
          'still_path': '/mini.jpg',
          'vote_average': 6.0,
          'runtime': 5,
        };

        final episode = Episode.fromJson(json);

        expect(episode.runtime, 5);
      });
    });
  });
}

