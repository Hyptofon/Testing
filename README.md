# 🧪 Тестування Flutter додатків (Testing)

Цей проєкт є виконанням лабораторної роботи **LR14: Тестування Flutter додатків**.

У додатку реалізовано Todo List з повним покриттям автоматичними тестами: Unit тести для бізнес-логіки, Widget тести для UI компонентів, Mock тести для імітації API, а також бонусні Integration, Golden та Performance тести.

🌐 **Live Demo:** [https://testing-2a564.web.app](https://testing-2a564.web.app)

---

## 🎯 Мета роботи

Навчитись писати автоматичні тести для Flutter додатків:

- Unit tests для моделей, провайдерів, сервісів та валідаторів;
- Widget tests для UI-компонентів (пошук віджетів, натискання кнопок, перевірка тексту);
- Mock тести для імітації зовнішніх залежностей (HTTP API) з використанням `mockito`;
- Integration tests для перевірки повного flow додатку;
- Golden tests для скріншот-порівняння UI-компонентів;
- Performance tests для перевірки швидкості операцій зі списком.

---

## ✅ Виконані обов'язкові завдання

### 1. Unit тести — Task Model (fromJson, toJson)

- Створено модель `Task` з полями `id`, `title`, `isCompleted`, `createdAt`.
- Реалізовано `fromJson`, `toJson`, `copyWith` з Fail-Fast валідацією.
- Тести покривають: створення, trim, порожній title, fromJson, toJson, copyWith.

### 2. Unit тести — Task Validation

- Конструктор `Task` кидає `ArgumentError` при порожньому `title`.
- `fromJson` кидає `FormatException` при відсутніх обов'язкових полях.
- Клас `Validators` має методи `validateTitle`, `validateEmail`, `isTaskOverdue`, `compose`.

### 3. Unit тести — Task List Operations (add, remove, toggle)

- `TaskProvider` реалізує `addTask`, `removeTask`, `toggleTask`, `createTask`.
- Тести перевіряють додавання, видалення, toggle completed, сповіщення listeners.
- Публічні списки задач є immutable (`UnmodifiableListView`).

### 4. Unit тести — Filter Logic (all, active, completed)

- `TaskProvider.setFilter()` фільтрує задачі за `TaskFilter.all`, `TaskFilter.active`, `TaskFilter.completed`.
- Тест перевіряє коректність фільтрації та підрахунок `totalCount`, `activeCount`, `completedCount`.

### 5. Widget тест — TaskListWidget відображає список

- `TaskListWidget` відображає `ListView` з `TaskCard` елементами.
- Тест перевіряє правильну кількість карточок та текст кожної задачі.

### 6. Widget тест — EmptyState показується коли список порожній

- `EmptyStateWidget` показує іконку, заголовок та підзаголовок.
- Тести перевіряють дефолтний текст та кастомні параметри.

### 7. Widget тест — Checkbox toggle працює

- Натискання на `Checkbox` в `TaskCard` викликає callback `onToggle`.
- В `HomeScreen` натискання на `Checkbox` оновлює стан задачі через `TaskProvider`.

### 8. Widget тест — Кнопка Delete видаляє задачу

- Натискання на `IconButton(Icons.delete_outline)` в `TaskCard` викликає callback `onDelete`.
- В `HomeScreen` кнопка Delete видаляє задачу зі списку та показує `EmptyState`.

### 9. Widget тест — Form валідація

- `AddTaskForm` показує помилку при порожньому title.
- Показує помилку при короткому title (< 3 символів).
- Приймає текстовий ввід, обрізає пробіли, очищає поле після submit.

### 10. Widget тест — Navigation між екранами

- Натискання кнопки навігації переходить на `DetailsScreen`.
- Кнопка `BackButton` повертає на `HomeScreen`.
- Використано `tester.pumpAndSettle()` для очікування анімацій.

---

## 🧰 Використані технології тестування

| Інструмент | Призначення |
|---|---|
| `flutter_test` | Widget тести, `testWidgets`, `WidgetTester` |
| `test` | Unit тести, `group`, `setUp`, `tearDown` |
| `mockito` | Мокування HTTP Client: `when`, `verify`, `verifyNever`, `captureAnyNamed` |
| `provider` | State management через `ChangeNotifierProvider` |
| `http` | HTTP клієнт для API запитів |

---

## 📊 Результати тестування

| Метрика | Значення |
|---|---|
| Всього тестів | **68** |
| Unit тестів | 41 |
| Widget тестів | 27 |
| Всі тести зелені | ✅ |
| Test coverage | **87.2%** |
| `flutter analyze` | No issues found |

---

## 🖼️ Структура тестів

```
test/
├── fixtures/
│   └── task_fixtures.dart            # Централізовані тестові дані (Fixtures)
├── unit/
│   ├── models/
│   │   └── task_test.dart            # 8 тестів: fromJson, toJson, copyWith, validation
│   ├── providers/
│   │   └── task_provider_test.dart   # 11 тестів: add, remove, toggle, filter, immutability
│   ├── repositories/
│   │   └── task_repository_test.dart # 3 тести: cache, immutability, delegation
│   ├── services/
│   │   └── task_api_service_test.dart # 7 тестів: fetchTasks, createTask, errors, validation
│   ├── utils/
│   │   └── validators_test.dart      # 11 тестів: title, email, overdue, compose
│   └── performance_test.dart         # 1 тест: 1000 задач (бонус C)
└── widget/
    ├── golden_test.dart              # 2 тести: matchesGoldenFile (бонус B)
    ├── goldens/                      # Еталонні скріншоти
    ├── widgets/
    │   ├── task_card_test.dart        # 6 тестів: display, checkbox, delete, strikethrough
    │   ├── empty_state_test.dart      # 2 тести: default state, custom props
    │   ├── add_task_form_test.dart    # 6 тестів: validation, submit, clear
    │   └── task_list_widget_test.dart # 4 тести: list, empty, toggle callback, delete callback
    └── screens/
        └── home_screen_test.dart     # 6 тестів: empty, add, checkbox, delete, filter, navigation

integration_test/
└── app_test.dart                     # E2E: створення → toggle → видалення (бонус A)
```

---

## 🏗️ Структура додатку

```
lib/
├── constants/
│   └── app_strings.dart          # Рядкові константи
├── models/
│   ├── task.dart                 # Модель Task з Fail-Fast валідацією
│   ├── task_action_result.dart   # Sealed class для результатів операцій
│   └── task_api_exception.dart   # Кастомний exception для API
├── providers/
│   └── task_provider.dart        # ChangeNotifier з фільтрацією
├── repositories/
│   └── task_repository.dart      # Кешування та делегування до API
├── screens/
│   ├── home_screen.dart          # Головний екран зі списком задач
│   └── details_screen.dart       # Екран деталей задачі
├── services/
│   └── task_api_service.dart     # HTTP сервіс з mockito-сумісною архітектурою
├── theme/
│   └── app_theme.dart            # Тема додатку
├── utils/
│   └── validators.dart           # Валідатори: title, email, overdue, compose
├── widgets/
│   ├── add_task_form.dart        # Форма додавання задачі
│   ├── empty_state_widget.dart   # Стан порожнього списку
│   ├── task_card.dart            # Картка задачі
│   └── task_list_widget.dart     # Список задач з ListView.builder
└── main.dart                     # Точка входу
```

---

## 💡 Додаткові завдання (бонус +1 бал)

### Варіант A: Integration тести ★★☆

Реалізовано E2E тест повного flow додатку:
1. Створення задачі через форму.
2. Toggle задачі через Checkbox.
3. Видалення задачі через кнопку Delete.
4. Перевірка що задача зникла зі списку.

### Варіант B: Golden тести ★★☆

Реалізовано скріншот-тести для `TaskCard`:
- Light-тема з незавершеною задачею.
- Light-тема з завершеною задачею (strikethrough).
- Використано `matchesGoldenFile` для порівняння з еталоном.

### Варіант C: Performance тести ★★★

Реалізовано тест продуктивності:
- Додавання 1000 задач — очікування < 100ms.
- Фільтрація 1000 задач — очікування < 50ms.
- Перевірка коректності підрахунку після масових операцій.

---

## 🔧 Архітектурні рішення

### AAA Pattern (Arrange-Act-Assert)
Кожен тест структурований за патерном:
- **Arrange** — підготовка тестових даних та залежностей.
- **Act** — виконання дії, яку тестуємо.
- **Assert** — перевірка результату.

### Test Fixtures
Централізовані тестові дані у `test/fixtures/task_fixtures.dart`:
- Усуває дублювання `Task(...)` конструкторів у тестах.
- Єдине джерело правди для тестових об'єктів.
- Спрощує рефакторинг при зміні моделі.

### Mock vs Fake
- **Mock** (`MockHttpClient`) — для API тестів з `when`/`verify`.
- **Fake** (`_FakeTaskApiService`) — для Repository тестів без mockito overhead.

### Fail-Fast Validation
- Модель `Task` валідує дані в конструкторі (trim + empty check).
- `fromJson` кидає `FormatException` при невалідних даних.
- `TaskApiService` валідує title до відправки запиту.

---

## 🚀 Запуск

### Запуск тестів
```bash
flutter test
```

### Запуск з coverage
```bash
flutter test --coverage
```

### Запуск конкретного файлу
```bash
flutter test test/unit/models/task_test.dart
```

### Запуск integration тестів
```bash
flutter test integration_test/app_test.dart
```

### Оновлення golden файлів
```bash
flutter test --update-goldens test/widget/golden_test.dart
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  http: ^1.2.2
  provider: ^6.1.2

dev_dependencies:
  flutter_test: sdk
  integration_test: sdk
  test: ^1.25.8
  mockito: ^5.4.4
  build_runner: ^2.4.13
```

---

## 👤 Автор

| Поле | Деталі |
| :--- | :--- |
| **Студент** | Войтюк Назарій |
| **Група** | КН-311 |
| **Live Demo** | [testing-2a564.web.app](https://testing-2a564.web.app) |
