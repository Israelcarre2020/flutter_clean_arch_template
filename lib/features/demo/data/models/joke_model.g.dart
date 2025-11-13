// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JokeModelImpl _$$JokeModelImplFromJson(Map<String, dynamic> json) =>
    _$JokeModelImpl(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      setup: json['setup'] as String,
      punchline: json['punchline'] as String,
    );

Map<String, dynamic> _$$JokeModelImplToJson(_$JokeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'setup': instance.setup,
      'punchline': instance.punchline,
    };
