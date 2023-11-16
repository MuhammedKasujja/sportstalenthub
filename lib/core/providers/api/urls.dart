class Urls {
  Urls._();
  static const baseUrl = 'http://projectdental.nl/staging-backend/api/patients';

  // static const String baseUrl = "http://10.0.2.2:8000/api/patients";

  static const login = "/auth/login";
  static const register = "/auth/register";
  static const logout = "/auth/logout";
  static const updateProfile = "/auth/update_info";
  static const appointments = "/appointments/all";
  static const appointmentsTypes = "/appointments/types";
  static const createAppointment = "/appointments/create";
  static const invoices = "/invoices/all";
  static const changeProfileImage = "/auth/update_photo";
  static const changePassword = "/auth/password_reset";
  static const checkin = "/appointments/checkin";
  static const makePayment = "/payments/process";
  static const invoiceTransactions = "/invoices/transactions/invoice";
  static const freeSlots =
      "http://projectdental.nl/staging-backend/api/v2/slots/free-slots";

  // static const freeSlots = "http://10.0.2.2:8000/api/v2/slots/free-slots";

  static const inbox =
      'http://projectdental.nl/staging-backend/api/v2/mails/inbox/mobile';

  static const outbox =
      'http://projectdental.nl/staging-backend/api/v2/mails/outbox';

  static const sendmail =
      'http://projectdental.nl/staging-backend/api/v2/mails/sendmail';

  static const myDoctorEmails =
      'http://projectdental.nl/staging-backend/api/v2/mails/drs_emailist';

  static const openMessage =
      'http://projectdental.nl/staging-backend/api/v2/mails/view';

  static const replyMessage =
      'http://projectdental.nl/staging-backend/api/v2/mails/reply';
}
