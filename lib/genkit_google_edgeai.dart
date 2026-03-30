import 'package:genkit/plugin.dart';

import 'src/google_edgeai_impl.dart';

export 'src/google_edgeai_impl.dart'
    show GoogleEdgeAiModelOptions, GoogleEdgeAiModelDefinition;

const GoogleEdgeAiPluginHandle edgeAi = GoogleEdgeAiPluginHandle();

class GoogleEdgeAiPluginHandle {
  const GoogleEdgeAiPluginHandle();

  GenkitPlugin call({required List<GoogleEdgeAiModelDefinition> models}) =>
      GoogleEdgeAiPlugin(models: models);

  ModelRef<GoogleEdgeAiModelOptions> model(String name) =>
      modelRef('edgeAi/$name', customOptions: GoogleEdgeAiModelOptions.$schema);
}
