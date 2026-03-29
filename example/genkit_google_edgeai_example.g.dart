// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genkit_google_edgeai_example.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class RecipeInput {
  factory RecipeInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  RecipeInput._(this._json);

  RecipeInput({required String ingredient, String? dietaryRestrictions}) {
    _json = {
      'ingredient': ingredient,
      'dietaryRestrictions': ?dietaryRestrictions,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<RecipeInput> $schema = _RecipeInputTypeFactory();

  String get ingredient {
    return _json['ingredient'] as String;
  }

  set ingredient(String value) {
    _json['ingredient'] = value;
  }

  String? get dietaryRestrictions {
    return _json['dietaryRestrictions'] as String?;
  }

  set dietaryRestrictions(String? value) {
    if (value == null) {
      _json.remove('dietaryRestrictions');
    } else {
      _json['dietaryRestrictions'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _RecipeInputTypeFactory extends SchemanticType<RecipeInput> {
  const _RecipeInputTypeFactory();

  @override
  RecipeInput parse(Object? json) {
    return RecipeInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'RecipeInput',
    definition: $Schema
        .object(
          properties: {
            'ingredient': $Schema.string(
              description: 'Main ingredient or cuisine type',
            ),
            'dietaryRestrictions': $Schema.string(
              description: 'Any dietary restrictions',
            ),
          },
          required: ['ingredient'],
        )
        .value,
    dependencies: [],
  );
}

base class RecipeOutput {
  factory RecipeOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  RecipeOutput._(this._json);

  RecipeOutput({
    required String title,
    required String description,
    required String prepTime,
    required String cookTime,
    required int servings,
    required List<String> ingredients,
    required List<String> instructions,
    List<String>? tips,
  }) {
    _json = {
      'title': title,
      'description': description,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'ingredients': ingredients,
      'instructions': instructions,
      'tips': ?tips,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<RecipeOutput> $schema =
      _RecipeOutputTypeFactory();

  String get title {
    return _json['title'] as String;
  }

  set title(String value) {
    _json['title'] = value;
  }

  String get description {
    return _json['description'] as String;
  }

  set description(String value) {
    _json['description'] = value;
  }

  String get prepTime {
    return _json['prepTime'] as String;
  }

  set prepTime(String value) {
    _json['prepTime'] = value;
  }

  String get cookTime {
    return _json['cookTime'] as String;
  }

  set cookTime(String value) {
    _json['cookTime'] = value;
  }

  int get servings {
    return _json['servings'] as int;
  }

  set servings(int value) {
    _json['servings'] = value;
  }

  List<String> get ingredients {
    return (_json['ingredients'] as List).cast<String>();
  }

  set ingredients(List<String> value) {
    _json['ingredients'] = value;
  }

  List<String> get instructions {
    return (_json['instructions'] as List).cast<String>();
  }

  set instructions(List<String> value) {
    _json['instructions'] = value;
  }

  List<String>? get tips {
    return (_json['tips'] as List?)?.cast<String>();
  }

  set tips(List<String>? value) {
    if (value == null) {
      _json.remove('tips');
    } else {
      _json['tips'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _RecipeOutputTypeFactory extends SchemanticType<RecipeOutput> {
  const _RecipeOutputTypeFactory();

  @override
  RecipeOutput parse(Object? json) {
    return RecipeOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'RecipeOutput',
    definition: $Schema
        .object(
          properties: {
            'title': $Schema.string(),
            'description': $Schema.string(),
            'prepTime': $Schema.string(),
            'cookTime': $Schema.string(),
            'servings': $Schema.integer(),
            'ingredients': $Schema.list(items: $Schema.string()),
            'instructions': $Schema.list(items: $Schema.string()),
            'tips': $Schema.list(items: $Schema.string()),
          },
          required: [
            'title',
            'description',
            'prepTime',
            'cookTime',
            'servings',
            'ingredients',
            'instructions',
          ],
        )
        .value,
    dependencies: [],
  );
}
