
  class TaskCountSummaryModel {

    late String  id;
    late int sum;

    TaskCountSummaryModel.fromJsom(Map<String,dynamic>json){

       id= json["_id"];
       sum=json["sum"];
    }


  }