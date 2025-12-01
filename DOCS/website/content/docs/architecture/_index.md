---
title: "Architecture Overview"
date: 2025-01-01
draft: false
---

# Notflix Architecture Overview

Developer Guide & Technical Documentation

## System Overview

**Notflix** is a cross-platform Flutter application for discovering movies and TV shows.

**Core Functionality:**
- Browse content by genre and category
- Search movies and TV shows
- View detailed information and trailers
- User authentication and watch lists
- Personalized recommendations

**Platform Support:**
- Android
- iOS
- Web
- Windows
- macOS
- Linux

## Technology Stack

### Frontend
- **Flutter** (Dart SDK 3.9.0+)
- **Material Design** with custom Netflix-inspired theme

### Backend Services
- **The Movie Database (TMDB) API** - Content data
- **PocketBase** - User authentication and watch lists

### Key Dependencies
- `http` - REST API calls
- `pocketbase` - Backend database
- `youtube_player_iframe` - Trailer playback
- `carousel_slider` - UI components

## Architecture Patterns

### MVC (Model-View-Controller)
- **Models**: `Movie`, `TvShow`, `Episode`
- **Views**: Screen widgets (`MovieList`, `Search`, `MovieDetail`)
- **Controllers**: State management via `StatefulWidget`

### Repository Pattern
- `APIRunner` - API abstraction layer
- `DbConnection` - Database abstraction layer

### Widget Composition
- Reusable components (`MovieCard`, `WatchListButtons`)

## Project Structure

```
lib/
├── main.dart              # App entry point & theme
├── model/                 # Data models
│   ├── movie.dart
│   ├── tvShow.dart
│   └── episode.dart
├── util/                 # Utilities
│   ├── api.dart          # TMDB API client
│   └── db.dart           # PocketBase client
└── view/                 # UI screens
    ├── movie_list.dart   # Home screen
    ├── search.dart       # Search screen
    ├── movie_detail.dart # Details screen
    ├── signup_page.dart
    └── user_page/
        ├── log_in.dart
        └── profile.dart
```

## Data Models

### Movie Model
```dart
class Movie {
  int id;
  String title;
  double voteAverage;
  String releaseDate;
  String overview;
  String posterPath;
  List genres;
}
```

### TvShow Model
Similar structure to Movie with additional TV-specific fields.

### Episode Model
Contains episode number, name, air date, runtime, overview, and still path.

## API Integration

### TMDB API
**Base URL:** `https://api.themoviedb.org/3`

**Key Endpoints:**
- `/discover/movie` - Discover movies
- `/discover/tv` - Discover TV shows
- `/search/movie` - Search movies
- `/movie/{id}/videos` - Movie trailers
- `/tv/{id}/videos` - TV show trailers
- `/tv/{id}` - TV show details
- `/tv/{id}/season/{season}` - Season episodes
- `/genre/movie/list` - Movie genres
- `/genre/tv/list` - TV genres

**APIRunner Class Responsibilities:**
- Authentication with Bearer token
- Endpoint management
- JSON parsing to models
- Error handling

**Key Methods:**
- `getUpcoming()` - Popular content
- `getGenre()` - Genre-based content
- `searchMovie()` - Search functionality
- `getTrailerKey()` - Video trailers
- `getTvShowDetails()` - TV show metadata
- `getTvSeasonEpisodes()` - Episode data

## Database Design

### PocketBase Collections

**users**
- `username` (String)
- `email` (String, unique)
- `password` (String, hashed)

**user_watch_lists**
- `user` (Relation to users)
- `recently_watched` (JSON object)
- `watch_later` (JSON object)

**Storage Format:**
- Watch lists stored as JSON maps
- Key: Show ID (String)
- Value: Show data (Map)

### Database Operations

**Authentication:**
- `logInUser()` - User login
- `createUser()` - User registration
- `logoutUser()` - Clear session
- `checkUserLogStatus()` - Check auth state

**Watch Lists:**
- `addShowToWatchList()` - Add to list
- `removeShowFromWatchList()` - Remove from list
- `getWatchLaterShows()` - Retrieve watch later
- `getRecentlyWatchedShows()` - Retrieve watched
- `checkShowInWatchList()` - Check if in list

## Key Components

### Home Screen (MovieList Widget)
- Main entry point
- Manages state for categories/genres
- Fetches and displays content
- Hero movie display
- Horizontal scrolling rows

**Features:**
- Category filtering (All/Movies/TV Shows)
- Genre filtering
- Dynamic content loading
- Loading states

### Search Screen (Search Widget)
- Real-time search functionality
- Grid layout for results
- Personalized recommendations (when logged in)
- "Because You Watched" section
- Upcoming movies section

**Search Logic:**
- Debounced input handling
- API call on text change
- Results displayed in grid
- Clear search functionality

### Details Screen (MovieDetail Widget)
- Displays movie/TV show information
- YouTube trailer integration
- Episode list for TV shows
- Season selector
- Watch list buttons

**Features:**
- Conditional rendering (Movie vs TV Show)
- Async data loading
- Trailer playback
- Episode browsing

## Data Flow

### Content Browsing Flow
```
User Action
    ↓
MovieList Widget
    ↓
APIRunner.getUpcoming()
    ↓
TMDB API Request
    ↓
JSON Response
    ↓
Movie.fromJson() / TvShow.fromJson()
    ↓
Widget State Update
    ↓
UI Rendering
```

### User Authentication Flow
```
User Login
    ↓
DbConnection.logInUser()
    ↓
PocketBase Authentication
    ↓
Auth Token Stored
    ↓
Session Management
    ↓
Personalized Features Enabled
```

## State Management

**Current Approach:**
- `StatefulWidget` with `setState()`
- Local state management
- No external state management library

**State Variables:**
- Loading states (`isLoading`)
- Content lists (`movies`, `moviesTvShows`)
- Filter selections (`_typeValue`, `_genreValue`)
- User authentication state

## Theme & Styling

**Custom Theme (Netflix-inspired):**
- Dark background (`#141414`)
- Netflix red primary (`#E50914`)
- Dark surface (`#181818`)
- White text with opacity variations

**Defined in:** `lib/main.dart`

**Components:**
- AppBar theme
- Text theme
- Button theme
- Card theme

## Development Setup

### Prerequisites
- Flutter SDK 3.9.0+
- Dart SDK
- PocketBase server (local)

### Setup Steps
1. Clone repository
2. Run `flutter pub get`
3. Start PocketBase: `cd server/pocketbase && .\start-pocketbase.ps1`
4. Configure API key in `lib/util/api.dart`
5. Run `flutter run`

### PocketBase Setup
**Local Development:**
- PocketBase binary in `server/pocketbase/`
- Start script: `start-pocketbase.ps1`
- Default URL: `http://localhost:8090`
- Android emulator: `http://10.0.2.2:8090`

**Collections Setup:**
- Create `users` collection
- Create `user_watch_lists` collection
- Configure field types and relations

## Testing Strategy

**Test Structure:**
- Unit tests: `test/` directory
- Widget tests: `test/widget/`
- Integration tests: `integration_test/`

**Test Coverage:**
- Model parsing (`movie_test.dart`, `tv_show_test.dart`)
- Database operations (`db_test.dart`)
- Widget rendering (`movie_card_test.dart`)
- API integration (mocked)

## Error Handling

**API Errors:**
- HTTP status code checking
- Try-catch blocks
- Null safety handling
- Default values for missing data

**Database Errors:**
- Connection error handling
- Authentication error messages
- User-friendly error display

**UI Error States:**
- Loading indicators
- Error messages
- Fallback images

## Image Loading

**Image Sources:**
- TMDB CDN: `https://image.tmdb.org/t/p/w500/`
- Poster paths from API
- Default fallback image
- Network image widgets with error handling

**Sizes Used:**
- `w500` - Standard posters
- `w780` - Hero images

## Performance Considerations

**Optimizations:**
- Lazy loading of content rows
- Image caching (Flutter default)
- Pagination for large lists
- Debounced search input

**Areas for Improvement:**
- Implement proper pagination
- Add image caching strategy
- Optimize list rendering
- Consider state management library

## Security Considerations

**Current Security:**
- Password hashing (PocketBase)
- HTTPS for API calls
- Bearer token authentication

**Recommendations:**
- Implement API rate limiting
- Add input validation
- Secure storage for sensitive data
- Regular security audits
- Move API keys to environment variables

## Resources & References

**Documentation:**
- [Flutter Documentation](https://flutter.dev/docs)
- [TMDB API Documentation](https://developers.themoviedb.org)
- [PocketBase Documentation](https://pocketbase.io/docs)

**Project Files:**
- `README.md` - Project overview
- `TEAM_RULES.md` - Team guidelines
- `pubspec.yaml` - Dependencies

