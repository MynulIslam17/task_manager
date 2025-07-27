

  class TaskModel{

   late String id;
   late String title;
    late String description;
    late String status;
    late  String email ;
    late String createDate;


    TaskModel.fromJson(Map<String,dynamic>json){

      id=json["_id"];
      title=json["title"];
      description=json["description"];
      email=json["email"];
      status=json["status"];
      createDate=json["createdDate"];

    }



  }


  // "data": [
  // {
  // "_id": "65b4a19c279fb0f60f610bb0",
  // "title": "A",
  // "description": "v",
  // "status": "New",
  // "email": "softenghasan25@gmail.com",
  // "createdDate": "2024-01-27T06:24:25.316Z"
  // },
  // {
  // "_id": "65b4a19d279fb0f60f610bb2",
  // "title": "A",
  // "description": "v",
  // "status": "New",
  // "email": "softenghasan25@gmail.com",
  // "createdDate": "2024-01-27T06:24:25.316Z"
  // }
  // ]