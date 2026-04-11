# SPEC - Books & Navigation Refactor

## 1. Navigation Refactor
Refactor the app navigation to use a bottom navigation bar instead of a top-level `AppBar` for primary navigation.

### Bottom Navigation Bar Structure
- **Home**: Icon `Icons.home`, tooltip "Home".
- **Books**: Icon `Icons.book`, tooltip "Books".
- **Profile**: 
  - If **Authenticated**: Display `UserProfileIcon` (initials avatar), tooltip "Profile".
  - If **Not Authenticated**: Display `LoginIcon` (person_outline), tooltip "Sign In".

### Implementation Details
- Use `StatefulShellRoute` in `GoRouter` to manage navigation between tabs.
- The `Profile` tab behavior should match the current `HomeAppBar` logic for guest vs authenticated users.
- Individual screens (Home, Books, Me) may still have their own `AppBar` for specific actions (e.g., Search, Title).
- Tooltips and icons must use the `AppClickableAction` atom where appropriate.

---

## 2. Books Feature (`/books`)
Create a screen to browse books with advanced filtering and sorting.

### UI/UX Requirements
- **Layout Modes**: Support both **Grid** (covers with titles) and **List** (detailed rows) views.
- **Search Bar**: Persistent or expandable search bar at the top to filter by title/author.
- **Filter Overlay**: A modal/bottom sheet to refine results.
- **Clear Filters**: A quick action to reset all active filters.

### Functional Requirements
- **Sensitive Content**: Automatically include the current user's `sensitiveContent` preferences in all API requests.
- **Pagination**: Use index-based pagination (`page`, `limit`).
- **Sorting Options**:
  - `orderBy: 'createdAt', order: 'DESC'` (Most Recent Added)
  - `orderBy: 'createdAt', order: 'ASC'` (Oldest Added)
  - `orderBy: 'title', order: 'ASC'` (Alphabetical A-Z)
  - `orderBy: 'title', order: 'DESC'` (Alphabetical Z-A)
  - `orderBy: 'updatedAt', order: 'DESC'` (Most Recent Update)
  - `orderBy: 'updatedAt', order: 'ASC'` (Oldest Update)
  - `orderBy: 'publication', order: 'DESC'` (Most Recent Published)
  - `orderBy: 'publication', order: 'ASC'` (Oldest Published)

### Filter Options (Modal)
The filter overlay should be structured according to the following visual sections:

- **Publication Year (Ano de publicação)**:
  - **Operator**: Dropdown to select the comparison (e.g., "Antes de" - Before, "Depois de" - After, "Igual a" - Equal).
  - **Year**: Numeric input field for the year value.
- **Types (Tipos)**:
  - Selectable chips for: MANGA, MANHWA, MANHUA, COMIC, NOVEL, OTHER.
- **Sensitive Content (Conteúdos sensíveis)**:
  - Selectable chips for specific sensitive content filters (e.g., "Safe").
- **Tags**:
  - **Included Tags (Selecionadas)**: Dropdown or multi-select input to include books containing specific tags (e.g., "Contém QUALQUER tag").
  - **Excluded Tags (Excluídas)**: Dropdown or multi-select input to exclude books containing specific tags (e.g., "Não contém QUALQUER tag").
- **Apply Action**: A primary action button labeled "Aplicar Filtros" (Apply Filters).

---

## 3. Technical Considerations
- **API Endpoint**: `GET /books`.
- **Data Models**: Implement `BookList`, `TypeBook`, and `BookPageOptions` DTOs in Flutter.
- **State Management**: Use `ChangeNotifier` and `Provider` for view models.
- **Dependency Injection**: Register repositories and services in `initDI`.
- **Offline Support**: Integrate with `AuthStorage` for sensitive content preferences and consider future local caching.
