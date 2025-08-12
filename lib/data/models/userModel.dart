

  class UserModel{

  late String id;
  late String email;
  late String firstName;
  late String lastName;
  late String mobile;
  String ? photo;


  UserModel({required this.email,required this.id,required this.firstName,required this.lastName ,required this.mobile,this.photo});



  UserModel.fromJson(Map<String,dynamic>json){

    id=json["_id"];
    email=json["email"];
    firstName=json["firstName"];
    lastName=json["lastName"];
    mobile=json["mobile"];
    photo=json["photo"] ?? "";

  }



  Map<String,dynamic> toJson(){

    return {
      "_id" : id,
      "email" : email,
      "firstName" : firstName,
      "lastName"   : lastName,
      "mobile"    :  mobile,
      "photo"     : photo
    };

  }




  }




 // "_id": "6878b5afb4f34e7d4b420eb9",
 // "email": "noyon@gmail.com",
 // "firstName": "noyon",
 // "lastName": "khhan",
 // "mobile": "0166745521801",
 // "createdDate": "2025-07-16T06:07:55.534Z"
  // photo : "   "