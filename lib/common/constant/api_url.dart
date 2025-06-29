class ApiUrl {
  // static const baseUrl = 'http://10.0.2.2:3000/api/';

  static const baseUrl = 'http://127.0.0.1:3000/api/';

  // static const baseUrl = 'http://192.168.1.42:3000/api/';

  static const register = 'auth/signup';

  static const login = 'auth/signin';

  static const getProfile = 'auth/me';

  static const refresh = 'auth/token/refresh';

  static const sendEmailOtp = 'auth/request-otp';

  static const resendOtp = 'auth/resend-otp';

  static const verifyOtp = 'auth/verify-otp';

  static const changePsw = 'auth/reset-password';

  static const getAllTodo = 'todos/';

  static const addTodo = 'todos/';

  static const getTodoId = 'todos/';

  static const editTodo = 'todos/';

  static const removeTodo = 'todos/';

  static const removeAll = 'todos/';

  static const reoveMany = 'todos/batch';

  static const uploadProfile = 'auth/upload/avatar';
}
