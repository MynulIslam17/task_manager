
  class ApiUrls{

  static const String _baseUrl="http://35.73.30.144:2005/api/v1";

  static const String  registerUr="$_baseUrl/Registration";
  static const String  profileDetailsUrl="$_baseUrl/ProfileDetails";
  static const String loginUrl="$_baseUrl/Login";
  static const String createTaskUrl="$_baseUrl/createTask";
  static const String  newTaskListUrl="$_baseUrl/listTaskByStatus/New";
  static const String  completedTaskListUrl="$_baseUrl/listTaskByStatus/Completed";
   static const String  canceledTaskListUrl="$_baseUrl/listTaskByStatus/Canceled";
   static const String  progressTaskListUrl="$_baseUrl/listTaskByStatus/Progress";
   static const String  taskCountUrl="$_baseUrl/taskStatusCount";
   static const String  profileUpdateUrl="$_baseUrl/ProfileUpdate";


   static  String updateTaskStatusUrl ({required String id, required String status}) => "$_baseUrl/updateTaskStatus/$id/$status" ;

  static String verifyEmailUrl(String email)=> "$_baseUrl/RecoverVerifyEmail/$email";
  static String verifyPinUrl(String email,String otp) =>"$_baseUrl/RecoverVerifyOtp/$email/$otp";
  static const passResetUrl="$_baseUrl/RecoverResetPassword";


  }