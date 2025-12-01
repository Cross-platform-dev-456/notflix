import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/model/movie.dart';
import 'package:notflix/model/tvShow.dart';
import 'package:notflix/view/movie_detail.dart';

// NOTE: MovieDetail makes API calls in initState(), limiting testable UI.
// These tests verify initial rendering and structure.

void main() {
  group('MovieDetail Widget with Movie', () {
    late Movie testMovie;

    setUp(() {
      testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        voteAverage: 8.5,
        releaseDate: '2024-01-15',
        overview: 'A great test movie for our unit tests',
        posterPath: '/test-movie.jpg',
        genres: [28, 12],
      );
    });

    testWidgets('renders with movie data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(testMovie),
        ),
      );

      // Should render without immediate crash
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Should have AppBar with movie title
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(testMovie),
        ),
      );

      // Should show loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('has proper AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(testMovie),
        ),
      );

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify title in AppBar
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Test Movie'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('creates with movie item', (WidgetTester tester) async {
      final widget = MovieDetail(testMovie);
      
      await tester.pumpWidget(
        MaterialApp(
          home: widget,
        ),
      );

      expect(find.byWidget(widget), findsOneWidget);
    });
  });

  group('MovieDetail Widget with TV Show', () {
    late TvShow testTvShow;

    setUp(() {
      testTvShow = TvShow(
        id: 100,
        title: 'Test TV Show',
        voteAverage: 9.0,
        releaseDate: '2024-02-01',
        overview: 'An amazing test TV show',
        posterPath: '/test-show.jpg',
        genres: [18, 10765],
      );
    });

    testWidgets('renders with TV show data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(testTvShow),
        ),
      );

      // Should render without crash
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Should have AppBar with show title
      expect(find.text('Test TV Show'), findsOneWidget);
    });

    testWidgets('shows loading indicator for TV show', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(testTvShow),
        ),
      );

      // Should show loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('MovieDetail Constructor', () {
    testWidgets('accepts movie item parameter', (WidgetTester tester) async {
      final movie = Movie(
        id: 1,
        title: 'Param Test',
        voteAverage: 7.5,
        releaseDate: '2024-03-01',
        overview: 'Testing parameters',
        posterPath: '/param.jpg',
        genres: [35],
      );

      final widget = MovieDetail(movie);
      
      expect(widget.item, movie);
    });

    testWidgets('has correct imgPath constant', (WidgetTester tester) async {
      final movie = Movie(
        id: 1,
        title: 'Path Test',
        voteAverage: 6.0,
        releaseDate: '2024-04-01',
        overview: 'Testing image path',
        posterPath: '/path.jpg',
        genres: [99],
      );

      final widget = MovieDetail(movie);
      
      expect(widget.imgPath, 'https://image.tmdb.org/t/p/w500/');
    });
  });

  group('MovieDetail Widget Lifecycle', () {
    testWidgets('handles multiple builds', (WidgetTester tester) async {
      final movie = Movie(
        id: 1,
        title: 'Lifecycle Test',
        voteAverage: 8.0,
        releaseDate: '2024-05-01',
        overview: 'Testing lifecycle',
        posterPath: '/lifecycle.jpg',
        genres: [16],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(movie),
        ),
      );

      // Pump multiple frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should still be valid
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('maintains state during pumps', (WidgetTester tester) async {
      final movie = Movie(
        id: 1,
        title: 'State Test',
        voteAverage: 7.0,
        releaseDate: '2024-06-01',
        overview: 'Testing state',
        posterPath: '/state.jpg',
        genres: [53],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetail(movie),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      // Should still have valid scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

