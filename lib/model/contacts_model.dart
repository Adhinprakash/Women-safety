class Tcontacts{
 final int? id;
final String name;
final String phone;

Tcontacts({this.id, required this.name, required this.phone, });

factory Tcontacts.fromMap(Map<String, dynamic> map) {
    return Tcontacts(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}