import 'dart:io';

class Customer {
  String customerId;
  String fullName;
  String phoneNumber;
  double accountBalance;

  Customer(
    this.customerId,
    this.fullName,
    this.phoneNumber,
    this.accountBalance,
  );
}

enum WorkspaceType {
  desk,
  privateOffice,
  meetingRoom
}

class Workspace {
  String workspaceId;
  String workspaceName;
  WorkspaceType workspaceType;
  double hourlyRate;
  bool isAvailable;

  Workspace(
    this.workspaceId,
    this.workspaceName,
    this.workspaceType,
    this.hourlyRate,
    this.isAvailable ,//= true حذفتها مش لازمة 
  );
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed
}

class Booking {
  String bookingId;
  Customer customer;
  Workspace workspace;
  DateTime bookingDate;
  DateTime startTime;
  int durationHours;
  double totalCost;
  BookingStatus bookingStatus;
  bool paymentStatus;
  DateTime get endTime =>
    startTime.add(Duration(hours: durationHours));

  Booking(
     this.bookingId,
     this.customer,
     this.workspace,
     this.bookingDate,
     this.startTime,
     this.durationHours,
     this.totalCost,
    this.bookingStatus ,// = BookingStatus.pending,
    this.paymentStatus ,//= false,وهدول حذفتهم برضو
  );
}

class Payment {
  String paymentId;
  Booking booking;
  double amount;
  DateTime paymentDate;

  Payment(
    this.paymentId,
    this.booking,
    this.amount,
    this.paymentDate,
  );
}

class WorkspaceManager {

  List<Customer> customers = [];

  List<Workspace> workspaces = [];

  List<Booking> bookings = [];

  List<Payment> payments = [];
 
  void registernewcustomer(Customer c){
    customers.add(c);
  }
  Customer? searchcustomer(String id){
  for (Customer cumstor in customers){
    if(cumstor.customerId == id){
      return cumstor;
    }
  }
  return null;
}
 
void displayCustomers() {
  for (Customer customer in customers) {
    print(customer.fullName);
    print(customer.customerId);
    print(customer.phoneNumber);
    print(customer.accountBalance);
  }}
 
void addbalance(String id, double amount){
  Customer? customer = searchcustomer(id);

  if(customer != null && amount > 0){
    customer.accountBalance += amount;
  }
}
void addworkspace(Workspace w){
    workspaces.add(w);//انت هان  كنتي حاطة اسم القائمة نفسها واحنا لازم نحط اسم الجديد يلي حطيناه للقائمة 
  }
Workspace? searchWorkspace(String id){
  for (Workspace work in workspaces){
    if(work.workspaceId == id){
      return work;
    }
  }
  return null;
}
void displayWorkspaces() {
  for (Workspace work in workspaces) {
    print(work.workspaceId);
    print(work.workspaceName);
    print(work.hourlyRate);
    print(work.workspaceType);
    print(work.isAvailable);
  }
}
void removeWorkspace(String id) {
  Workspace? workspace = searchWorkspace(id);

  if (workspace == null) {
    print("Workspace not found");
    return;
  }

  for (Booking booking in bookings) {
    if (booking.workspace.workspaceId == id &&
        (booking.bookingStatus == BookingStatus.pending ||
         booking.bookingStatus == BookingStatus.confirmed)) {
      print("Cannot delete workspace. It has an active booking.");
      return;
    }
  }

  workspaces.remove(workspace);
  print("Workspace deleted successfully");
}
void displayByType(WorkspaceType type) {
  for (Workspace workspace in workspaces) {
    if (workspace.workspaceType == type) {
      print(workspace.workspaceName);
      print(workspace.workspaceType);
      print(workspace.hourlyRate);
    }
  }
}
void displayAvailable() {
  for (Workspace workspace in workspaces) {
    if (workspace.isAvailable == true) {
      print(workspace.workspaceName);
      print(workspace.hourlyRate);
    }
  }
}
bool hasOverlap(
  String workspaceId,
  DateTime startTime,
  int durationHours, {
  String? excludeBookingId,
}) {
  DateTime endTime = startTime.add(
    Duration(hours: durationHours),
  );

  for (Booking booking in bookings) {
    if (booking.workspace.workspaceId == workspaceId &&
        booking.bookingId != excludeBookingId &&
        (booking.bookingStatus == BookingStatus.pending ||
         booking.bookingStatus == BookingStatus.confirmed)) {

      if (startTime.isBefore(booking.endTime) &&
          endTime.isAfter(booking.startTime)) {
        return true;
      }
    }
  }

  return false;
}

void createBooking(
  String bookingId,
  String customerId,
  String workspaceId,
  DateTime bookingDate,
  DateTime startTime,
  int durationHours,
) {
  Customer? customer = searchcustomer(customerId);
  Workspace? workspace = searchWorkspace(workspaceId);

  if (customer == null || workspace == null) {
    print("Customer or Workspace not found");
    return;
  }

  if (durationHours <= 0) {
    print("Invalid booking duration");
    return;
  }
  double totalCost = workspace.hourlyRate * durationHours;
  for (Booking booking in bookings) {
  if (booking.bookingId == bookingId) {
    print("Booking ID already exists");
    return;
  }
}
if (hasOverlap(workspaceId, startTime, durationHours)) {
  print("Workspace is already booked at this time");
  return;
}
Booking newBooking = Booking(
  bookingId,
  customer,
  workspace,
  bookingDate,
  startTime,
  durationHours,
  totalCost,
  BookingStatus.pending,
  false,
);
bookings.add(newBooking);

print("Booking created successfully");

}

Booking? searchBooking(String id) {
  for (Booking booking in bookings) {
    if (booking.bookingId == id) {
      return booking;
    }
  }

  return null;
}
void displayAllBookings() {
  for (Booking booking in bookings) {
    print(booking.bookingId);
    print(booking.customer.fullName);
    print(booking.workspace.workspaceName);
    print(booking.bookingDate);
    print(booking.startTime);
    print(booking.durationHours);
    print(booking.totalCost);
    print(booking.bookingStatus);
    print(booking.paymentStatus);
  }
}
void displayCustomerBookings(String customerId) {
  for (Booking booking in bookings) {
    if (booking.customer.customerId == customerId) {
      print(booking.bookingId);
      print(booking.workspace.workspaceName);
      print(booking.totalCost);
      print(booking.bookingStatus);
    }
  }
}



void completeBooking(String id) {
  Booking? booking = searchBooking(id);

  if (booking == null) {
    print("Booking not found");
    return;
  }

  if (booking.bookingStatus != BookingStatus.confirmed) {
    print("Only confirmed bookings can be completed");
    return;
  }

  booking.bookingStatus = BookingStatus.completed;

  print("Booking completed successfully");
}
Future<void> confirmBooking(String id) async {
  Booking? booking = searchBooking(id);

  if (booking == null) {
    print("Booking not found");
    return;
  }

  await Future.delayed(Duration(seconds: 2));

  booking.bookingStatus = BookingStatus.confirmed;

  print("Booking confirmed successfully");
}
void cancelBooking(String id) {
  Booking? booking = searchBooking(id);

  if (booking == null) {
    print("Booking not found");
    return;
  }

  booking.bookingStatus = BookingStatus.cancelled;

  print("Booking cancelled successfully");
}



void processPayment(String bookingId, String paymentId) {
  Booking? booking = searchBooking(bookingId);

  if (booking == null) {
    print("Booking not found");
    return;
  }

  if (booking.bookingStatus != BookingStatus.confirmed) {
    print("Booking must be confirmed first");
    return;
  }

  if (booking.paymentStatus == true) {
    print("Booking already paid");
    return;
  }

  if (booking.customer.accountBalance < booking.totalCost) {
    print("Insufficient balance");
    return;
  }

  for (Payment p in payments) {
    if (p.paymentId == paymentId) {
      print("Payment ID already exists");
      return;
    }
  }

  booking.customer.accountBalance -= booking.totalCost;
  booking.paymentStatus = true;

  Payment payment = Payment(
    paymentId,
    booking,
    booking.totalCost,
    DateTime.now(),
  );

  payments.add(payment);

  print("Payment completed successfully");
}
void displayPayments() {
  for (Payment payment in payments) {
    print(payment.paymentId);
    print(payment.booking.bookingId);
    print(payment.amount);
    print(payment.paymentDate);
  }
}
void displayReports() {
  print("Total Customers: ${customers.length}");

  int deskCount = 0;
  int privateOfficeCount = 0;
  int meetingRoomCount = 0;

  for (Workspace workspace in workspaces) {
    if (workspace.workspaceType == WorkspaceType.desk) {
      deskCount++;
    } else if (workspace.workspaceType == WorkspaceType.privateOffice) {
      privateOfficeCount++;
    } else if (workspace.workspaceType == WorkspaceType.meetingRoom) {
      meetingRoomCount++;
    }
  }

  print("Desks: $deskCount");
  print("Private Offices: $privateOfficeCount");
  print("Meeting Rooms: $meetingRoomCount");

  int pendingCount = 0;
  int confirmedCount = 0;
  int cancelledCount = 0;
  int completedCount = 0;

  for (Booking booking in bookings) {
    if (booking.bookingStatus == BookingStatus.pending) {
      pendingCount++;
    } else if (booking.bookingStatus == BookingStatus.confirmed) {
      confirmedCount++;
    } else if (booking.bookingStatus == BookingStatus.cancelled) {
      cancelledCount++;
    } else if (booking.bookingStatus == BookingStatus.completed) {
      completedCount++;
    }
  }

  print("Pending: $pendingCount");
  print("Confirmed: $confirmedCount");
  print("Cancelled: $cancelledCount");
  print("Completed: $completedCount");

  double totalRevenue = 0;

  for (Payment payment in payments) {
    totalRevenue += payment.amount;
  }

  print("Total Revenue: $totalRevenue");

  int unpaidCount = 0;

  for (Booking booking in bookings) {
    if (booking.paymentStatus == false &&
        booking.bookingStatus != BookingStatus.cancelled) {
      unpaidCount++;
    }
  }

  print("Unpaid Bookings: $unpaidCount");

  Map<String, int> bookingCounts = {};

  for (Booking booking in bookings) {
    String workspaceId = booking.workspace.workspaceId;

    bookingCounts[workspaceId] =
        (bookingCounts[workspaceId] ?? 0) + 1;
  }

  if (bookingCounts.isEmpty) {
    print("No bookings yet");
  } else {
    String mostBookedId = bookingCounts.keys.first;

    for (String id in bookingCounts.keys) {
      if (bookingCounts[id]! > bookingCounts[mostBookedId]!) {
        mostBookedId = id;
      }
    }

    Workspace? workspace = searchWorkspace(mostBookedId);

    print("Most Booked Workspace: ${workspace?.workspaceName}");
  }
}
}//كانت ناقصة 


//import 'dart:io'; بتنحط اول اشي بالكود مش هنا

Future<void> main() async {//للازم تحطيها علشان استخدمتي وايت
  WorkspaceManager manager = WorkspaceManager();

  int choice;

  do {
    print("1. Register Customer");
    print("2. Display Customers");
    print("3. Add Workspace");
    print("4. Display Workspaces");
    print("5. Create Booking");
    print("6. Display All Bookings");
    print("7. Search Booking");
    print("8. Complete Booking");
    print("9. Confirm Booking");
    print("10. Cancel Booking");
    print("11. Process Payment");
    print("12. Display Payments");
    print("13. Display Reports");
    print("14. Add Customer Balance");
    print("15. Remove Workspace");
    print("0. Exit");

    choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
  print("Enter Customer ID:");
  String id = stdin.readLineSync()!;

  print("Enter Full Name:");
  String name = stdin.readLineSync()!;

  print("Enter Phone Number:");
  String phone = stdin.readLineSync()!;

  print("Enter Account Balance:");
  double balance = double.parse(stdin.readLineSync()!);

  Customer newCustomer = Customer(
    id,
    name,
    phone,
    balance,
  );

  manager.registernewcustomer(newCustomer);

  print("Customer registered successfully");
  break;

      case 2:
        manager.displayCustomers();
        break;

      case 3:
       // case 3:كنتي كتباها مرتين
  print("Enter Workspace ID:");
  String id = stdin.readLineSync()!;

  print("Enter Workspace Name:");
  String name = stdin.readLineSync()!;

  print("Choose Workspace Type:");
  print("1. Desk");
  print("2. Private Office");
  print("3. Meeting Room");

  int type = int.parse(stdin.readLineSync()!);

  WorkspaceType workspaceType;

  if (type == 1) {
    workspaceType = WorkspaceType.desk;
  } else if (type == 2) {
    workspaceType = WorkspaceType.privateOffice;
  } else {
    workspaceType = WorkspaceType.meetingRoom;
  }

  print("Enter Hourly Rate:");
  double rate = double.parse(stdin.readLineSync()!);
Workspace newWorkspace = Workspace(
  id,
  name,
  workspaceType,
  rate,
  true,
);

  manager.addworkspace(newWorkspace);

  print("Workspace added successfully");
  break;

      case 4:
        manager.displayWorkspaces();
        break;
        case 5:
  print("Enter Booking ID:");
  String bookingId = stdin.readLineSync()!;

  print("Enter Customer ID:");
  String customerId = stdin.readLineSync()!;

  print("Enter Workspace ID:");
  String workspaceId = stdin.readLineSync()!;

  print("Enter Booking Date (YYYY-MM-DD):");
  DateTime bookingDate = DateTime.parse(
    stdin.readLineSync()!
  );

  print("Enter Start Time (YYYY-MM-DD HH:MM):");
  DateTime startTime = DateTime.parse(
    stdin.readLineSync()!
  );

  print("Enter Duration Hours:");
  int duration = int.parse(stdin.readLineSync()!);

  manager.createBooking(
    bookingId,
    customerId,
    workspaceId,
    bookingDate,
    startTime,
    duration,
  );

  break;
  case 6:
  manager.displayAllBookings();
  break;
  case 7:
  print("Enter Booking ID:");
  String id = stdin.readLineSync()!;

  Booking? booking = manager.searchBooking(id);

  if (booking != null) {
    print("Booking Found");
    print(booking.bookingId);
    print(booking.customer.fullName);
    print(booking.workspace.workspaceName);
    print(booking.totalCost);
    print(booking.bookingStatus);
  } else {
    print("Booking not found");
  }

  break;
  case 8:
  print("Enter Booking ID:");
  String id = stdin.readLineSync()!;

  manager.completeBooking(id);

  break;
  case 9:
  print("Enter Booking ID:");
  String id = stdin.readLineSync()!;

  await manager.confirmBooking(id);// علشان استخدمتي await لازم تعملي هيك بالمين

  break;

case 10:
  print("Enter Booking ID:");
  String id = stdin.readLineSync()!;

  manager.cancelBooking(id);

  break;
  case 11:
  print("Enter Booking ID:");
  String bookingId = stdin.readLineSync()!;

  print("Enter Payment ID:");
  String paymentId = stdin.readLineSync()!;

  manager.processPayment(bookingId, paymentId);

  break;
  case 12:
  manager.displayPayments();
  break;
  case 13:
  manager.displayReports();
  break;
  case 14:
  print("Enter Customer ID:");
  String id = stdin.readLineSync()!;

  print("Enter Amount:");
  double amount = double.parse(stdin.readLineSync()!);

  manager.addbalance(id, amount);

  break;
  case 15:
  print("Enter Workspace ID:");
  String id = stdin.readLineSync()!;

  manager.removeWorkspace(id);

  break;
  case 16:
  print("Choose Workspace Type:");
  print("1. Desk");
  print("2. Private Office");
  print("3. Meeting Room");

  int type = int.parse(stdin.readLineSync()!);

  if (type == 1) {
    manager.displayByType(WorkspaceType.desk);
  } else if (type == 2) {
    manager.displayByType(WorkspaceType.privateOffice);
  } else if (type == 3) {
    manager.displayByType(WorkspaceType.meetingRoom);
  } else {
    print("Invalid type");
  }

  break;
 
 

      case 0:
        print("Goodbye");
        break;

      default:
        print("Invalid choice");
    }

  } while (choice != 0);
}
