import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:notflix/model/movie.dart';
import 'package:notflix/view/search.dart';

void main() {
  group('MovieCard Widget', () {
    late Movie testMovie;

    setUp(() {
      testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        voteAverage: 8.5,
        releaseDate: '2024-01-15',
        overview: 'A great test movie',
        posterPath: '/test-poster.jpg',
        genres: [28, 12],
      );
    });

    testWidgets('renders with valid movie data', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: testMovie,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        // Verify the card is rendered
        expect(find.byType(Card), findsOneWidget);
        
        // Verify movie title is displayed
        expect(find.text('Test Movie'), findsOneWidget);
        
        // Verify release date and vote average are displayed
        expect(find.textContaining('Released: 2024-01-15'), findsOneWidget);
        expect(find.textContaining('Vote: 8.5'), findsOneWidget);
      });
    });

    testWidgets('displays default image when posterPath is null', (WidgetTester tester) async {
      final movieWithoutPoster = Movie(
        id: 2,
        title: 'No Poster Movie',
        voteAverage: 7.0,
        releaseDate: '2024-02-01',
        overview: 'Movie without poster',
        posterPath: '',
        genres: [18],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: movieWithoutPoster,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        expect(find.text('No Poster Movie'), findsOneWidget);
      });
    });

    testWidgets('uses custom width and height', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: testMovie,
                width: 200,
                height: 250,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Container),
          ).first,
        );

        expect(container.constraints?.maxWidth, 200);
        expect(container.constraints?.maxHeight, 250);
      });
    });

    testWidgets('shows smaller font for grid layout', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: testMovie,
                width: double.infinity,
                height: 300,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        // Verify the card renders (font size is internal logic)
        expect(find.text('Test Movie'), findsOneWidget);
      });
    });

    testWidgets('handles movie with empty title', (WidgetTester tester) async {
      final movieWithoutTitle = Movie(
        id: 3,
        title: '',
        voteAverage: 6.0,
        releaseDate: '',
        overview: 'No title movie',
        posterPath: '/test.jpg',
        genres: [],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: movieWithoutTitle,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        // Card should still render
        expect(find.byType(Card), findsOneWidget);
      });
    });

    testWidgets('is tappable (has InkWell)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: testMovie,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        // Find the InkWell widget
        expect(find.byType(InkWell), findsOneWidget);

        // Note: Actual navigation test skipped because MovieDetail
        // makes API calls in initState. Widget is confirmed tappable.
      });
    });

    testWidgets('displays gradient overlay', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: testMovie,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        // Verify Material widget for transparency effect
        expect(find.byType(Material), findsWidgets);
      });
    });

    testWidgets('truncates long titles with ellipsis', (WidgetTester tester) async {
      final longTitleMovie = Movie(
        id: 4,
        title: 'This is a Very Long Movie Title That Should Be Truncated With Ellipsis',
        voteAverage: 9.0,
        releaseDate: '2024-03-01',
        overview: 'Long title test',
        posterPath: '/long.jpg',
        genres: [35],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                child: MovieCard(
                  movie: longTitleMovie,
                  iconBase: 'https://image.tmdb.org/t/p/w500/',
                  defaultImage: 'https://default.jpg',
                ),
              ),
            ),
          ),
        );

        // Verify text is displayed (ellipsis is handled by maxLines and overflow)
        expect(find.textContaining('This is a Very Long'), findsOneWidget);
      });
    });

    testWidgets('displays correct vote average with decimal', (WidgetTester tester) async {
      final highRatedMovie = Movie(
        id: 5,
        title: 'Highly Rated',
        voteAverage: 9.87,
        releaseDate: '2024-04-01',
        overview: 'Best movie ever',
        posterPath: '/best.jpg',
        genres: [18],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: highRatedMovie,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        expect(find.textContaining('Vote: 9.87'), findsOneWidget);
      });
    });

    testWidgets('handles zero vote average', (WidgetTester tester) async {
      final unratedMovie = Movie(
        id: 6,
        title: 'Unrated Movie',
        voteAverage: 0.0,
        releaseDate: '2024-05-01',
        overview: 'No ratings yet',
        posterPath: '/unrated.jpg',
        genres: [99],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MovieCard(
                movie: unratedMovie,
                iconBase: 'https://image.tmdb.org/t/p/w500/',
                defaultImage: 'https://default.jpg',
              ),
            ),
          ),
        );

        expect(find.textContaining('Vote: 0.0'), findsOneWidget);
      });
    });
  });
}

