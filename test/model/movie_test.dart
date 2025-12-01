import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/model/movie.dart';

void main() {
  group('Movie', () {
    group('Constructor', () {
      test('creates Movie with all required fields', () {
        final movie = Movie(
          id: 1,
          title: 'Test Movie',
          voteAverage: 8.5,
          releaseDate: '2024-01-01',
          overview: 'A test movie overview',
          posterPath: '/test-poster.jpg',
          genres: [28, 12],
        );

        expect(movie.id, 1);
        expect(movie.title, 'Test Movie');
        expect(movie.voteAverage, 8.5);
        expect(movie.releaseDate, '2024-01-01');
        expect(movie.overview, 'A test movie overview');
        expect(movie.posterPath, '/test-poster.jpg');
        expect(movie.genres, [28, 12]);
      });
    });

    group('fromJson', () {
      test('parses valid JSON with all fields', () {
        final json = {
          'id': 123,
          'title': 'Action Movie',
          'vote_average': 7.8,
          'release_date': '2024-03-15',
          'overview': 'An action-packed thriller',
          'poster_path': '/action-poster.jpg',
          'genre_ids': [28, 53],
        };

        final movie = Movie.fromJson(json);

        expect(movie.id, 123);
        expect(movie.title, 'Action Movie');
        expect(movie.voteAverage, 7.8);
        expect(movie.releaseDate, '2024-03-15');
        expect(movie.overview, 'An action-packed thriller');
        expect(movie.posterPath, '/action-poster.jpg');
        expect(movie.genres, [28, 53]);
      });

      test('handles null title with empty string default', () {
        final json = {
          'id': 456,
          'title': null,
          'vote_average': 6.5,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [18],
        };

        final movie = Movie.fromJson(json);

        expect(movie.title, '');
      });

      test('handles missing title with empty string default', () {
        final json = {
          'id': 789,
          'vote_average': 5.0,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [35],
        };

        final movie = Movie.fromJson(json);

        expect(movie.title, '');
      });

      test('handles null vote_average with 0.0 default', () {
        final json = {
          'id': 111,
          'title': 'No Rating Movie',
          'vote_average': null,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [99],
        };

        final movie = Movie.fromJson(json);

        expect(movie.voteAverage, 0.0);
      });

      test('handles null release_date with empty string default', () {
        final json = {
          'id': 222,
          'title': 'Unknown Date Movie',
          'vote_average': 7.0,
          'release_date': null,
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [16],
        };

        final movie = Movie.fromJson(json);

        expect(movie.releaseDate, '');
      });

      test('handles null overview with empty string default', () {
        final json = {
          'id': 333,
          'title': 'No Overview Movie',
          'vote_average': 6.0,
          'release_date': '2024-01-01',
          'overview': null,
          'poster_path': '/poster.jpg',
          'genre_ids': [14],
        };

        final movie = Movie.fromJson(json);

        expect(movie.overview, '');
      });

      test('handles null poster_path with empty string default', () {
        final json = {
          'id': 444,
          'title': 'No Poster Movie',
          'vote_average': 5.5,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': null,
          'genre_ids': [27],
        };

        final movie = Movie.fromJson(json);

        expect(movie.posterPath, '');
      });

      test('handles null genre_ids with empty list default', () {
        final json = {
          'id': 555,
          'title': 'No Genres Movie',
          'vote_average': 4.0,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': null,
        };

        final movie = Movie.fromJson(json);

        expect(movie.genres, []);
      });

      test('handles missing genre_ids with empty list default', () {
        final json = {
          'id': 666,
          'title': 'Missing Genres Movie',
          'vote_average': 3.5,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
        };

        final movie = Movie.fromJson(json);

        expect(movie.genres, []);
      });

      test('handles all null/missing optional fields', () {
        final json = {
          'id': 777,
          'title': null,
          'vote_average': null,
          'release_date': null,
          'overview': null,
          'poster_path': null,
          'genre_ids': null,
        };

        final movie = Movie.fromJson(json);

        expect(movie.id, 777);
        expect(movie.title, '');
        expect(movie.voteAverage, 0.0);
        expect(movie.releaseDate, '');
        expect(movie.overview, '');
        expect(movie.posterPath, '');
        expect(movie.genres, []);
      });

      test('handles vote_average as int converted to double', () {
        final json = {
          'id': 888,
          'title': 'Integer Rating Movie',
          'vote_average': 8,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [12],
        };

        final movie = Movie.fromJson(json);

        expect(movie.voteAverage, 8.0);
      });

      test('handles multiple genres', () {
        final json = {
          'id': 999,
          'title': 'Multi-Genre Movie',
          'vote_average': 7.5,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [28, 12, 878, 53],
        };

        final movie = Movie.fromJson(json);

        expect(movie.genres.length, 4);
        expect(movie.genres, [28, 12, 878, 53]);
      });

      test('handles empty genres list', () {
        final json = {
          'id': 1010,
          'title': 'Empty Genres Movie',
          'vote_average': 6.0,
          'release_date': '2024-01-01',
          'overview': 'Test overview',
          'poster_path': '/poster.jpg',
          'genre_ids': [],
        };

        final movie = Movie.fromJson(json);

        expect(movie.genres, []);
      });
    });
  });
}

