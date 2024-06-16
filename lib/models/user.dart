class User {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePictureUrl;
  final bool isDriver;
  final double rating;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.isDriver,
    required this.rating,
  });

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'isDriver': isDriver,
      'rating': rating,
    };
  }

  // Method to create a UserModel from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      profilePictureUrl: map['profilePictureUrl'],
      isDriver: map['isDriver'],
      rating: map['rating'],
    );
  }
}
