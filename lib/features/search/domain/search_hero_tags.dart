/// Shared `Hero` tag for the Home hero's search icon ↔ `SearchScreen`'s
/// search bar morph. Its own tiny file (not owned by either
/// `home_hero_section.dart` or `search_screen.dart`) so both features
/// import the same constant without a cross-feature dependency running
/// through one specific screen file.
const String searchMorphHeroTag = 'search-morph';
