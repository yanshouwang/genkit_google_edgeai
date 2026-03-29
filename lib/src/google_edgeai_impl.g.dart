// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_edgeai_impl.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class GoogleEdgeAiModelOptions {
  factory GoogleEdgeAiModelOptions.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  GoogleEdgeAiModelOptions._(this._json);

  GoogleEdgeAiModelOptions() {
    _json = {};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<GoogleEdgeAiModelOptions> $schema =
      _GoogleEdgeAiModelOptionsTypeFactory();

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _GoogleEdgeAiModelOptionsTypeFactory
    extends SchemanticType<GoogleEdgeAiModelOptions> {
  const _GoogleEdgeAiModelOptionsTypeFactory();

  @override
  GoogleEdgeAiModelOptions parse(Object? json) {
    return GoogleEdgeAiModelOptions._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'GoogleEdgeAiModelOptions',
    definition: $Schema.object(properties: {}, required: []).value,
    dependencies: [],
  );
}
