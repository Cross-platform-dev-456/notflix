import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/model/tvShow.dart';

void main() {
  group('TvShow', () {
    group('Constructor', () {
      test('creates TvShow with all required fields', () {
        final tvShow = TvShow(
          id: 1,
          title: 'Test TV Show',
          voteAverage: 8.5,
          releaseDate: '2024-01-01',
          overview: 'A test TV show overview',
          posterPath: '/test-poster.jpg',
          genres: [18, 10765],
        );

        expect(tvShow.id, 1);
        expect(tvShow.title, 'Test TV Show');
        expect(tvShow.voteAverage, 8.5);
        expect(tvShow.releaseDate, '2024-01-01');
        expect(tvShow.overview, 'A test TV show overview');
        expect(tvShow.posterPath, '/test-poster.jpg');
        expect(tvShow.genres, [18, 10765]);
      });
    });

    group('fromJson', () {
      test('parses valid JSON with all fields', () {
        final json = {
          'id': 123,
          'name': 'Drama Series',
          'vote_average': 7.8,
          'first_air_date': '2024-03-15',
          'overview': 'A dramatic TV series',
          'backdrop_path': '/drama-backdrop.jpg',
          'genre_ids': [18, 80],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.id, 123);
        expect(tvShow.title, 'Drama Series');
        expect(tvShow.voteAverage, 7.8);
        expect(tvShow.releaseDate, '2024-03-15');
        expect(tvShow.overview, 'A dramatic TV series');
        expect(tvShow.posterPath, '/drama-backdrop.jpg');
        expect(tvShow.genres, [18, 80]);
      });

      test('uses "name" field for title (not "title")', () {
        final json = {
          'id': 456,
          'name': 'Comedy Show',
          'vote_average': 6.5,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [35],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.title, 'Comedy Show');
      });

      test('uses "first_air_date" for releaseDate', () {
        final json = {
          'id': 789,
          'name': 'New Series',
          'vote_average': 7.0,
          'first_air_date': '2024-12-25',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [10765],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.releaseDate, '2024-12-25');
      });

      test('uses "backdrop_path" for posterPath', () {
        final json = {
          'id': 111,
          'name': 'Mystery Show',
          'vote_average': 8.0,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/custom-backdrop.jpg',
          'genre_ids': [9648],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.posterPath, '/custom-backdrop.jpg');
      });

      test('handles null name with empty string default', () {
        final json = {
          'id': 456,
          'name': null,
          'vote_average': 6.5,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [18],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.title, '');
      });

      test('handles missing name with empty string default', () {
        final json = {
          'id': 789,
          'vote_average': 5.0,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [35],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.title, '');
      });

      test('handles null vote_average with 0.0 default', () {
        final json = {
          'id': 111,
          'name': 'No Rating Show',
          'vote_average': null,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [99],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.voteAverage, 0.0);
      });

      test('handles null first_air_date with empty string default', () {
        final json = {
          'id': 222,
          'name': 'Unknown Date Show',
          'vote_average': 7.0,
          'first_air_date': null,
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [16],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.releaseDate, '');
      });

      test('handles null overview with empty string default', () {
        final json = {
          'id': 333,
          'name': 'No Overview Show',
          'vote_average': 6.0,
          'first_air_date': '2024-01-01',
          'overview': null,
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [14],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.overview, '');
      });

      test('handles null backdrop_path with empty string default', () {
        final json = {
          'id': 444,
          'name': 'No Backdrop Show',
          'vote_average': 5.5,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': null,
          'genre_ids': [27],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.posterPath, '');
      });

      test('handles null genre_ids with empty list default', () {
        final json = {
          'id': 555,
          'name': 'No Genres Show',
          'vote_average': 4.0,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': null,
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.genres, []);
      });

      test('handles missing genre_ids with empty list default', () {
        final json = {
          'id': 666,
          'name': 'Missing Genres Show',
          'vote_average': 3.5,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.genres, []);
      });

      test('handles all null/missing optional fields', () {
        final json = {
          'id': 777,
          'name': null,
          'vote_average': null,
          'first_air_date': null,
          'overview': null,
          'backdrop_path': null,
          'genre_ids': null,
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.id, 777);
        expect(tvShow.title, '');
        expect(tvShow.voteAverage, 0.0);
        expect(tvShow.releaseDate, '');
        expect(tvShow.overview, '');
        expect(tvShow.posterPath, '');
        expect(tvShow.genres, []);
      });

      test('handles vote_average as int converted to double', () {
        final json = {
          'id': 888,
          'name': 'Integer Rating Show',
          'vote_average': 8,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [10759],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.voteAverage, 8.0);
      });

      test('handles multiple genres', () {
        final json = {
          'id': 999,
          'name': 'Multi-Genre Show',
          'vote_average': 7.5,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [10759, 16, 35, 10765],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.genres.length, 4);
        expect(tvShow.genres, [10759, 16, 35, 10765]);
      });

      test('handles empty genres list', () {
        final json = {
          'id': 1010,
          'name': 'Empty Genres Show',
          'vote_average': 6.0,
          'first_air_date': '2024-01-01',
          'overview': 'Test overview',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [],
        };

        final tvShow = TvShow.fromJson(json);

        expect(tvShow.genres, []);
      });
    });
  });
}

