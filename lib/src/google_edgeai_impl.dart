import 'package:flutter_gemma/flutter_gemma.dart' as sdk;
import 'package:genkit/plugin.dart';
import 'package:schemantic/schemantic.dart';

part 'google_edgeai_impl.g.dart';

@Schema()
abstract class $GoogleEdgeAiModelOptions {}

class GoogleEdgeAiModelDefinition {}

class GoogleEdgeAiPlugin extends GenkitPlugin {
  @override
  String get name => 'edgeAi';

  @override
  Future<List<Action<dynamic, dynamic, dynamic, dynamic>>> init() async {
    // await sdk.FlutterGemma.initialize();
    final installed = await sdk.FlutterGemma.isModelInstalled(modelName);
    final installation = await sdk.FlutterGemma.installModel(
      modelType: .functionGemma,
    ).fromAsset(assetName).install();
    // TODO: implement init
    return super.init();
  }

  @override
  Future<List<ActionMetadata<dynamic, dynamic, dynamic, dynamic>>>
  list() async {
    final installations = await sdk.FlutterGemma.listInstalledModels();
    return installations.map((e) => modelMetadata(e)).toList();
  }

  @override
  Action<dynamic, dynamic, dynamic, dynamic>? resolve(
    String actionType,
    String name,
  ) {
    final spec = sdk.InferenceModelSpec(
      name: 'name',
      modelSource: .asset(assetName),
      modelType: .functionGemma,
    );
    sdk.FlutterGemmaPlugin.instance.modelManager.setActiveModel(spec);
    // TODO: implement resolve
    return super.resolve(actionType, name);
  }
}
