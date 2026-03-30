import 'dart:convert';

import 'package:genkit/genkit.dart';
import 'package:genkit_google_edgeai/genkit_google_edgeai.dart';
import 'package:schemantic/schemantic.dart';

part 'genkit_google_edgeai_example.g.dart';

@Schema()
abstract class $RecipeInput {
  @Field(description: 'Main ingredient or cuisine type')
  String get ingredient;

  @Field(description: 'Any dietary restrictions')
  String? get dietaryRestrictions;
}

@Schema()
abstract class $RecipeOutput {
  String get title;
  String get description;
  String get prepTime;
  String get cookTime;
  int get servings;
  List<String> get ingredients;
  List<String> get instructions;
  List<String>? get tips;
}

void main() async {
  final ai = Genkit(plugins: [edgeAi(models: [])]);
  final recipeGeneratorFlow = ai.defineFlow(
    name: 'recipeGeneratorFlow',
    inputSchema: RecipeInput.$schema,
    outputSchema: RecipeOutput.$schema,
    fn: (input, ctx) async {
      final dietaryRestrictions = input.dietaryRestrictions ?? 'none';
      final prompt =
          'Create a recipe with the following requirements:\n'
          'Main ingredient: ${input.ingredient}\n'
          'Dietary restrictions: $dietaryRestrictions';
      final response = await ai.generate(
        model: edgeAi.model('name'),
        prompt: prompt,
        outputSchema: RecipeOutput.$schema,
      );
      final output = ArgumentError.checkNotNull(response.output);
      return output;
    },
  );
  final recipe = await recipeGeneratorFlow(
    RecipeInput(ingredient: 'avocado', dietaryRestrictions: 'vegetarian'),
  );
  final recipeText = JsonEncoder.withIndent('  ').convert(recipe);
  print(recipeText);
}
