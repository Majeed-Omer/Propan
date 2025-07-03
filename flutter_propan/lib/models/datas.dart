class Datas {
  String id;
  String lang;
  String text;
  String phone_number;
  String email;
  String price;


  Datas(
      {required this.id,
      required this.lang,
      required this.text,
      required this.phone_number,
      required this.email,
      required this.price,
      });

  factory Datas.fromJson(Map<String, dynamic> json) {
    return Datas(
      id: json['id'].toString(),
      lang: json['lang'].toString(),
      text: json['text'].toString(),
      phone_number: json['phone_number'].toString(),
      email: json['email'].toString(),
      price: json['prices'].toString(),
    );
  }
}
