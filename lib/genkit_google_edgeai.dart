import 'package:genkit/plugin.dart';

import 'src/google_edgeai_impl.dart';

const GoogleEdgeAiPluginHandle edgeAi = GoogleEdgeAiPluginHandle();

class GoogleEdgeAiPluginHandle {
  const GoogleEdgeAiPluginHandle();

  GenkitPlugin call() => GoogleEdgeAiPlugin();

  ModelRef<GoogleEdgeAiModelOptions> model(String name) =>
      modelRef('edgeAi/$name', customOptions: GoogleEdgeAiModelOptions.$schema);
}
