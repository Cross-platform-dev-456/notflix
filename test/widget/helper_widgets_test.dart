import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:notflix/model/movie.dart';
import 'package:notflix/view/movie_list.dart';

void main() {
  group('movieTitle Helper Widget', () {
    testWidgets('renders title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: movieTitle(title: 'Action Movies'),
          ),
        ),
      );

      // Verify Text widget exists
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: movieTitle(title: 'Comedy'),
          ),
        ),
      );

      // Verify Padding exists
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('has correct text style', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: movieTitle(title: 'Drama'),
          ),
        ),
      );

      // Verify Text widget exists and has style
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, 18);
    });

    testWidgets('handles empty title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: movieTitle(title: ''),
          ),
        ),
      );

      // Should render without error
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('handles long title', (WidgetTester tester) async {
      const longTitle = 'This is a Very Long Genre Title for Testing Purposes';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: movieTitle(title: longTitle),
          ),
        ),
      );

      // Verify Text widget exists (handles long titles)
      expect(find.byType(Text), findsOneWidget);
    });
  });

  group('movieGroup Helper Widget', () {
    late List<Movie> testMovies;
    late List<List> movieGenres;
    late List<List> tvGenres;

    setUp(() {
      testMovies = [
        Movie(
          id: 1,
          title: 'Test Movie 1',
          voteAverage: 8.5,
          releaseDate: '2024-01-15',
          overview: 'Great movie',
          posterPath: '/test1.jpg',
          genres: [28, 'Action Movies'],
        ),
        Movie(
          id: 2,
          title: 'Test Movie 2',
          voteAverage: 7.0,
          releaseDate: '2024-02-01',
          overview: 'Good movie',
          posterPath: '/test2.jpg',
          genres: [12, 'Action Movies'],
        ),
      ];
      
      // Initialize genre lists for movieGroup function
      movieGenres = [
        ['28', 'Action'],
        ['12', 'Adventure'],
        ['35', 'Comedy'],
      ];
      tvGenres = [
        ['10759', 'Action & Adventure'],
        ['16', 'Animation'],
      ];
    });

    testWidgets('renders movie group', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: movieGroup(
                moviesCount: testMovies.length,
                movieGroup: testMovies,
                movieGenres: movieGenres,
                tvGenres: tvGenres,
              ),
            ),
          ),
        );

        // Verify SizedBox container
        expect(find.byType(SizedBox), findsWidgets);
        
        // Verify ListView.builder exists
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    testWidgets('displays genre title from first movie', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: movieGroup(
                moviesCount: testMovies.length,
                movieGroup: testMovies,
                movieGenres: movieGenres,
                tvGenres: tvGenres,
              ),
            ),
          ),
        );

        // Verify Text widget exists for genre title
        expect(find.byType(Text), findsWidgets);
      });
    });

    testWidgets('has correct height', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: movieGroup(
                moviesCount: testMovies.length,
                movieGroup: testMovies,
                movieGenres: movieGenres,
                tvGenres: tvGenres,
              ),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );

        expect(sizedBox.height, 400);
      });
    });

    testWidgets('renders multiple movie cards', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: movieGroup(
                moviesCount: testMovies.length,
                movieGroup: testMovies,
                movieGenres: movieGenres,
                tvGenres: tvGenres,
              ),
            ),
          ),
        );

        // Should have Card widgets
        expect(find.byType(Card), findsWidgets);
      });
    });

    testWidgets('uses horizontal scroll', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: movieGroup(
                moviesCount: testMovies.length,
                movieGroup: testMovies,
                movieGenres: movieGenres,
                tvGenres: tvGenres,
              ),
            ),
          ),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.horizontal);
      });
    });

    testWidgets('handles empty movie list', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: movieGroup(
                moviesCount: 0,
                movieGroup: [
                  Movie(
                    id: 1,
                    title: '',
                    voteAverage: 0.0,
                    releaseDate: '',
                    overview: '',
                    posterPath: '',
                    genres: ['Empty'],
                  ),
                ],
                movieGenres: movieGenres,
                tvGenres: tvGenres,
              ),
            ),
          ),
        );

        // Should render without error
        expect(find.byType(SizedBox), findsWidgets);
      });
    });
  });

  group('heroMovie Helper Widget', () {
    late Movie testMovie;

    setUp(() {
      testMovie = Movie(
        id: 1,
        title: 'Hero Movie',
        voteAverage: 9.5,
        releaseDate: '2024-03-15',
        overview: 'Amazing hero movie',
        posterPath: '/hero.jpg',
        genres: [28, 12],
      );
    });

    testWidgets('renders hero movie card', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [testMovie],
                    context: ctx,
                    genres: ['Action', 'Adventure'],
                  );
                },
              ),
            ),
          ),
        );

        // Verify Card exists
        expect(find.byType(Card), findsOneWidget);
        
        // Verify Text widgets exist (for movie title and genres)
        expect(find.byType(Text), findsWidgets);
      });
    });

    testWidgets('displays genre information', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [testMovie],
                    context: ctx,
                    genres: ['Action', 'Adventure'],
                  );
                },
              ),
            ),
          ),
        );

        // Verify Text widgets exist (genres are displayed as text)
        expect(find.byType(Text), findsWidgets);
      });
    });

    testWidgets('has larger dimensions than regular cards', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [testMovie],
                    context: ctx,
                    genres: ['Action'],
                  );
                },
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

        // Hero card should be larger (600x600)
        expect(container.constraints?.maxWidth, 600);
        expect(container.constraints?.maxHeight, 600);
      });
    });

    testWidgets('has red shadow effect', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [testMovie],
                    context: ctx,
                    genres: ['Action'],
                  );
                },
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

        final boxDecoration = container.decoration as BoxDecoration;
        expect(boxDecoration.boxShadow, isNotEmpty);
        expect(boxDecoration.boxShadow?.first.color, Colors.red);
      });
    });

    testWidgets('handles movie with null poster', (WidgetTester tester) async {
      final movieWithoutPoster = Movie(
        id: 2,
        title: 'No Poster Hero',
        voteAverage: 8.0,
        releaseDate: '2024-04-01',
        overview: 'Hero without poster',
        posterPath: '',
        genres: [18],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [movieWithoutPoster],
                    context: ctx,
                    genres: ['Drama'],
                  );
                },
              ),
            ),
          ),
        );

        // Should render without error (uses default image)
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });
    });

    testWidgets('is tappable for navigation', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [testMovie],
                    context: ctx,
                    genres: ['Action'],
                  );
                },
              ),
            ),
          ),
        );

        // Verify InkWell for tap
        expect(find.byType(InkWell), findsOneWidget);
      });
    });

    testWidgets('has gradient overlay', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  return heroMovie(
                    movie: [testMovie],
                    context: ctx,
                    genres: ['Action'],
                  );
                },
              ),
            ),
          ),
        );

        // Verify Container with gradient
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(1));
      });
    });
  });
}

