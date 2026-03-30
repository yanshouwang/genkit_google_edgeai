import 'dart:convert';

import 'package:flutter_gemma/flutter_gemma.dart' as sdk;
import 'package:genkit/plugin.dart';
import 'package:schemantic/schemantic.dart';

part 'google_edgeai_impl.g.dart';

@Schema()
abstract class $GoogleEdgeAiModelOptions {}

class GoogleEdgeAiModelDefinition {
  final String assetName;
  final sdk.ModelType type;

  const GoogleEdgeAiModelDefinition({
    required this.assetName,
    required this.type,
  });
}

class GoogleEdgeAiPlugin extends GenkitPlugin {
  final List<GoogleEdgeAiModelDefinition> models;
  final List<sdk.InferenceInstallation> installations;

  @override
  String get name => 'edgeAi';

  GoogleEdgeAiPlugin({required this.models}) : installations = [];

  @override
  Future<List<Action<dynamic, dynamic, dynamic, dynamic>>> init() async {
    await sdk.FlutterGemma.initialize();
    for (var model in models) {
      // final installed = await sdk.FlutterGemma.isModelInstalled(modelName);
      final installation = await sdk.FlutterGemma.installModel(
        modelType: model.type,
        fileType: .task,
      ).fromAsset(model.assetName).install();
      installations.add(installation);
    }
    return installations.map((e) => _createModel(e.modelId)).toList();
  }

  @override
  Future<List<ActionMetadata<dynamic, dynamic, dynamic, dynamic>>>
  list() async {
    return installations
        .map((e) => modelMetadata('edgeAi/${e.modelId}'))
        .toList();
  }

  @override
  Action<dynamic, dynamic, dynamic, dynamic>? resolve(
    String actionType,
    String name,
  ) {
    switch (actionType) {
      case 'model':
        return _createModel(name);
      case 'embedder':
      default:
        return super.resolve(actionType, name);
    }
  }

  Model _createModel(String modelName, [ModelInfo? info]) {
    return Model(
      name: '$name/$modelName',
      customOptions: GoogleEdgeAiModelOptions.$schema,
      metadata: info == null ? null : {'model': info.toJson()},
      fn: (input, ctx) async {
        if (input == null) {
          throw GenkitException(
            'Model request is null',
            status: .INVALID_ARGUMENT,
          );
        }
        // final optionsJson = input.config;
        // final options = optionsJson == null
        //     ? GoogleEdgeAiModelOptions()
        //     : GoogleEdgeAiModelOptions.fromJson(optionsJson);
        final spec = installations
            .firstWhere((e) => e.modelId == modelName)
            .spec;
        sdk.FlutterGemmaPlugin.instance.modelManager.setActiveModel(spec);
        final model = await sdk.FlutterGemma.getActiveModel();
        final tools = input.tools
            ?.map(
              (e) => sdk.Tool(
                name: e.name,
                description: e.description,
                parameters: e.inputSchema ?? {},
              ),
            )
            .toList();
        final chat = await model.createChat(
          tools: tools ?? [],
          supportsFunctionCalls: tools != null && tools.isNotEmpty,
          modelType: .functionGemma,
        );
        try {
          final messages = _toChatMessages(input.messages);
          for (var message in messages) {
            await chat.addQuery(message);
          }
          final response = ctx.streamingRequested
              ? await _handleStreaming(chat, ctx)
              : await _handleNonStreaming(chat);
          return response;
        } catch (e, stack) {
          throw _handleException(e, stack);
        } finally {
          // await model.close();
        }
      },
    );
  }

  List<sdk.Message> _toChatMessages(List<Message> messages) {
    final result = <sdk.Message>[];
    for (var message in messages) {
      final role = message.role;
      if (role == .system) {
        final value = sdk.Message(text: message.text, isUser: false);
        result.add(value);
      } else if (role == .user) {
        final value = sdk.Message(text: message.text, isUser: true);
        result.add(value);
      } else if (role == .model) {
        final toolRequests = message.content
            .where((e) => e.isToolRequest)
            .map((e) => e.toolRequest)
            .toList();
        for (var toolRequest in toolRequests) {
          final value = sdk.Message.toolCall(text: json.encode(toolRequest));
          result.add(value);
        }
      } else if (role == .tool) {
        final toolResponses = message.content
            .where((e) => e.isToolResponse)
            .map((e) => e.toolResponse)
            .nonNulls
            .toList();
        for (var toolResponse in toolResponses) {
          final output = toolResponse.output;
          final value = sdk.Message.toolResponse(
            toolName: toolResponse.name,
            response: output is Map<String, dynamic>
                ? output
                : {'result': output},
          );
          result.add(value);
        }
      } else {
        throw UnimplementedError('Unsupported role: $role');
      }
    }
    return result;
  }

  Future<ModelResponse> _handleStreaming(
    sdk.InferenceChat chat,
    ({
      bool streamingRequested,
      void Function(ModelResponseChunk) sendChunk,
      Map<String, dynamic>? context,
      Stream<ModelRequest>? inputStream,
      void init,
    })
    ctx,
  ) async {
    final text = StringBuffer();
    final otherContent = <Part>[];
    final stream = chat.generateChatResponseAsync();
    try {
      await for (final chunk in stream) {
        switch (chunk) {
          case sdk.TextResponse(token: final token):
            final chunk = ModelResponseChunk(
              index: 0,
              content: [TextPart(text: token)],
            );
            ctx.sendChunk(chunk);
            text.write(token);
            break;
          case sdk.FunctionCallResponse(name: final name, args: final args):
            final toolRequestPart = ToolRequestPart(
              toolRequest: ToolRequest(name: name, input: args),
            );
            otherContent.add(toolRequestPart);
            break;
          case sdk.ParallelFunctionCallResponse():
          case sdk.ThinkingResponse():
            break;
        }
      }
    } catch (e, stackTrace) {
      if (e is GenkitException) rethrow;
      throw GenkitException(
        'Error in streaming: $e',
        underlyingException: e,
        stackTrace: stackTrace,
      );
    }

    return ModelResponse(
      finishReason: .stop,
      message: Message(
        role: .model,
        content: [
          TextPart(text: '$text'),
          ...otherContent,
        ],
      ),
    );
  }

  Future<ModelResponse> _handleNonStreaming(sdk.InferenceChat chat) async {
    final response = await chat.generateChatResponse();
    final content = <Part>[];
    switch (response) {
      case sdk.TextResponse(token: final token):
        final textPart = TextPart(text: token);
        content.add(textPart);
        break;
      case sdk.FunctionCallResponse(name: final name, args: final args):
        final toolRequestPart = ToolRequestPart(
          toolRequest: ToolRequest(name: name, input: args),
        );
        content.add(toolRequestPart);
        break;
      case sdk.ParallelFunctionCallResponse():
      case sdk.ThinkingResponse():
        break;
    }
    return ModelResponse(
      finishReason: .stop,
      message: Message(role: .model, content: content),
    );
  }

  GenkitException _handleException(Object e, StackTrace stack) {
    if (e is GenkitException) return e;
    return GenkitException(
      'Edge AI Error: $e',
      status: .INTERNAL,
      underlyingException: e,
      stackTrace: stack,
    );
  }
}
