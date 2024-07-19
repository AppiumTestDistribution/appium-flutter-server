import 'package:flutter/services.dart';

enum SourceCamera {
  rear,
  front,
}

enum SourceType {
  camera,
  gallery,
}

enum CacheRetrievalType {
  image,
  video,
}

class GeneralOptions {
  GeneralOptions({
    required this.allowMultiple,
    required this.usePhotoPicker,
    this.limit,
  });

  bool allowMultiple;

  bool usePhotoPicker;

  int? limit;

  Object encode() {
    return <Object?>[
      allowMultiple,
      usePhotoPicker,
      limit,
    ];
  }

  static GeneralOptions decode(Object result) {
    result as List<Object?>;
    return GeneralOptions(
      allowMultiple: result[0]! as bool,
      usePhotoPicker: result[1]! as bool,
      limit: result[2] as int?,
    );
  }
}

/// Options for image selection and output.
class ImageSelectionOptions {
  ImageSelectionOptions({
    this.maxWidth,
    this.maxHeight,
    required this.quality,
  });

  /// If set, the max width that the image should be resized to fit in.
  double? maxWidth;

  /// If set, the max height that the image should be resized to fit in.
  double? maxHeight;

  /// The quality of the output image, from 0-100.
  ///
  /// 100 indicates original quality.
  int quality;

  Object encode() {
    return <Object?>[
      maxWidth,
      maxHeight,
      quality,
    ];
  }

  static ImageSelectionOptions decode(Object result) {
    result as List<Object?>;
    return ImageSelectionOptions(
      maxWidth: result[0] as double?,
      maxHeight: result[1] as double?,
      quality: result[2]! as int,
    );
  }
}

class MediaSelectionOptions {
  MediaSelectionOptions({
    required this.imageSelectionOptions,
  });

  ImageSelectionOptions imageSelectionOptions;

  Object encode() {
    return <Object?>[
      imageSelectionOptions.encode(),
    ];
  }

  static MediaSelectionOptions decode(Object result) {
    result as List<Object?>;
    return MediaSelectionOptions(
      imageSelectionOptions:
      ImageSelectionOptions.decode(result[0]! as List<Object?>),
    );
  }
}

/// Options for image selection and output.
class VideoSelectionOptions {
  VideoSelectionOptions({
    this.maxDurationSeconds,
  });

  /// The maximum desired length for the video, in seconds.
  int? maxDurationSeconds;

  Object encode() {
    return <Object?>[
      maxDurationSeconds,
    ];
  }

  static VideoSelectionOptions decode(Object result) {
    result as List<Object?>;
    return VideoSelectionOptions(
      maxDurationSeconds: result[0] as int?,
    );
  }
}

/// Specification for the source of an image or video selection.
class SourceSpecification {
  SourceSpecification({
    required this.type,
    this.camera,
  });

  SourceType type;

  SourceCamera? camera;

  Object encode() {
    return <Object?>[
      type.index,
      camera?.index,
    ];
  }

  static SourceSpecification decode(Object result) {
    result as List<Object?>;
    return SourceSpecification(
      type: SourceType.values[result[0]! as int],
      camera: result[1] != null ? SourceCamera.values[result[1]! as int] : null,
    );
  }
}

/// An error that occurred during lost result retrieval.
///
/// The data here maps to the `PlatformException` that will be created from it.
class CacheRetrievalError {
  CacheRetrievalError({
    required this.code,
    this.message,
  });

  String code;

  String? message;

  Object encode() {
    return <Object?>[
      code,
      message,
    ];
  }

  static CacheRetrievalError decode(Object result) {
    result as List<Object?>;
    return CacheRetrievalError(
      code: result[0]! as String,
      message: result[1] as String?,
    );
  }
}

/// The result of retrieving cached results from a previous run.
class CacheRetrievalResult {
  CacheRetrievalResult({
    required this.type,
    this.error,
    this.paths = const <String>[],
  });

  /// The type of the retrieved data.
  CacheRetrievalType type;

  /// The error from the last selection, if any.
  CacheRetrievalError? error;

  /// The results from the last selection, if any.
  ///
  /// Elements must not be null, by convention. See
  /// https://github.com/flutter/flutter/issues/97848
  List<String?> paths;

  Object encode() {
    return <Object?>[
      type.index,
      error?.encode(),
      paths,
    ];
  }

  static CacheRetrievalResult decode(Object result) {
    result as List<Object?>;
    return CacheRetrievalResult(
      type: CacheRetrievalType.values[result[0]! as int],
      error: result[1] != null
          ? CacheRetrievalError.decode(result[1]! as List<Object?>)
          : null,
      paths: (result[2] as List<Object?>?)!.cast<String?>(),
    );
  }
}

class ImagePickerApiCodec extends StandardMessageCodec {
  const ImagePickerApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CacheRetrievalError) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CacheRetrievalResult) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is GeneralOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is ImageSelectionOptions) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is MediaSelectionOptions) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is SourceSpecification) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is VideoSelectionOptions) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CacheRetrievalError.decode(readValue(buffer)!);
      case 129:
        return CacheRetrievalResult.decode(readValue(buffer)!);
      case 130:
        return GeneralOptions.decode(readValue(buffer)!);
      case 131:
        return ImageSelectionOptions.decode(readValue(buffer)!);
      case 132:
        return MediaSelectionOptions.decode(readValue(buffer)!);
      case 133:
        return SourceSpecification.decode(readValue(buffer)!);
      case 134:
        return VideoSelectionOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
