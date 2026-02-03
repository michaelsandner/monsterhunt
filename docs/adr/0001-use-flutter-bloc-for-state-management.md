# ADR-0001: Use flutter_bloc for State Management

## Status

Accepted

## Date

2026-02-03

## Context

The Monster Challenge application requires a robust and scalable state management solution to handle:
- Monster state and properties
- API call states (loading, success, error)
- User interactions and property updates
- Separation between business logic and UI

The application follows Clean Architecture principles with distinct layers (domain, data, presentation), requiring a state management solution that supports this architectural approach.

## Decision

We will use **flutter_bloc** (BLoC pattern with Cubit) for state management throughout the application.

## Alternatives Considered

### Riverpod
- **Pros:**
  - Modern, compile-safe provider implementation
  - Good developer experience with code generation
  - Strong community support
  - Excellent for dependency injection
- **Cons:**
  - Team has limited experience with Riverpod
  - Learning curve for new patterns and best practices
  - Different mental model compared to BLoC

### Provider (vanilla)
- **Pros:**
  - Simple and lightweight
  - Official Flutter recommendation
  - Easy to learn
- **Cons:**
  - Less structured for complex state management
  - No built-in pattern for business logic separation
  - Harder to maintain in larger applications

## Rationale

The decision to use flutter_bloc was primarily driven by:

1. **Team Experience**: The development team has extensive experience with flutter_bloc, which enables:
   - Faster development velocity
   - Better code quality due to familiarity
   - Reduced onboarding time for new team members
   - Known patterns and best practices

2. **Clean Architecture Alignment**: flutter_bloc naturally supports Clean Architecture with:
   - Clear separation between business logic (Cubit) and UI
   - Structured state management with distinct state classes
   - Easy integration with use cases from the domain layer

3. **Testability**: BLoC pattern provides excellent testability:
   - Business logic can be tested independently of UI
   - Clear input (events/methods) and output (states)
   - Comprehensive testing utilities provided by the bloc_test package

4. **Maturity and Ecosystem**: flutter_bloc is:
   - Battle-tested in production applications
   - Well-documented with extensive examples
   - Actively maintained
   - Large community support

5. **Predictable State Management**: 
   - Unidirectional data flow
   - Single source of truth for each feature
   - Easy to debug with BlocObserver

## Consequences

### Positive
- Faster initial development due to team familiarity
- Consistent patterns across the application
- Strong separation between business logic and UI
- Excellent debugging capabilities with bloc observers
- Well-tested architecture with proven patterns

### Negative
- Slightly more boilerplate compared to some alternatives
- Learning curve for developers new to BLoC pattern
- Potential over-engineering for very simple state scenarios

### Neutral
- Committed to bloc ecosystem (bloc_test, hydrated_bloc if needed)
- Standard BLoC patterns must be followed consistently

## Notes

- We use **Cubit** (simplified BLoC) where events are not necessary
- State classes use **Equatable** for easy state comparison
- All Cubits follow the naming convention `<Feature>Cubit`
- BlocListener and BlocConsumer are used for side effects (navigation, snackbars)

## References

- [flutter_bloc Documentation](https://bloclibrary.dev/)
- [Clean Architecture with Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [BLoC Pattern Official Documentation](https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/)
