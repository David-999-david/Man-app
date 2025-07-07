class AddressModel {
  final int? id;
  final String? label;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final List<AddressImage> addressImage;

  AddressModel(
      {this.id,
      this.label,
      required this.street,
      required this.city,
      required this.state,
      required this.country,
      required this.postalCode,
      required this.addressImage});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        id: json['id'] as int?,
        label: json['label'] as String?,
        street: json['street'] as String ?? '',
        city: json['city'] as String ?? '',
        state: json['state'] as String ?? '',
        country: json['country'] as String ?? '',
        postalCode: json['postal_code'] as String ?? '',
        addressImage: (json['images'] as List<dynamic>?)
                ?.map((image) => AddressImage.fromJson(image))
                .toList() ??
            <AddressImage>[]);
  }
}

class AddressImage {
  final String? url;
  final String description;

  AddressImage({required this.url, required this.description});

  factory AddressImage.fromJson(Map<String, dynamic> json) {
    return AddressImage(
        url: json['url'] as String?, description: json['imageDesc'] as String);
  }
}

class PickAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  PickAddress(
      {required this.street,
      required this.city,
      required this.state,
      required this.country,
      required this.postalCode});
}

class TestAddress {
  final String label;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String imageDesc;

  TestAddress(
      {required this.label,
      required this.street,
      required this.city,
      required this.state,
      required this.country,
      required this.postalCode,
      required this.imageDesc});

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'imageDesc': imageDesc
    };
  }
}

class ReturnTestAddress {
  final int id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final List<ReturnLocationImage> images;

  ReturnTestAddress(
      {required this.id,
      required this.label,
      required this.street,
      required this.city,
      required this.state,
      required this.country,
      required this.postalCode,
      required this.images});

  factory ReturnTestAddress.fromJson(Map<String, dynamic> json) {
    return ReturnTestAddress(
        id: json['id'],
        label: json['label'],
        street: json['street'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        postalCode: json['postal_code'],
        images: (json['images'] as List<dynamic>)
            .map((item) => ReturnLocationImage.fromJson(item))
            .toList());
  }
}

class ReturnLocationImage {
  final int id;
  final String description;

  ReturnLocationImage({required this.id, required this.description});

  factory ReturnLocationImage.fromJson(Map<String, dynamic> json) {
    return ReturnLocationImage(
        id: json['id'] as int, description: json['description'] as String);
  }
}
