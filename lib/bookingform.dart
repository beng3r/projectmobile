import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectmobile/db/database_service.dart';
import 'package:projectmobile/models/busticket.dart';

class BookingForms extends StatefulWidget {
  const BookingForms({super.key});

  @override
  State<BookingForms> createState() => _BookingFormsState();
}

class _BookingFormsState extends State<BookingForms> {
  TextEditingController _dateInput = TextEditingController();
  TextEditingController _timeinput = TextEditingController();
  TextEditingController _depart_station = TextEditingController();
  TextEditingController _dest_station = TextEditingController();

  //text editing controller for text field

  //database
  final DatabaseService _databaseService = DatabaseService();

  final List<String> _locations = [
    'Kuala Lumpur',
    'Melaka',
    'Terengganu',
    'Negara Sembilan',
    'Johor'
  ];
  late String _selectedLocation;
  late String _selectedLocation2;




Future<void> _onSave() async {



      await _databaseService.insertBusticket(BusTicket(depart_date: _dateInput, time: _timeinput, depart_station: _selectedLocation, dest_station: _selectedLocation2)));
      //Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);
    
  }



  @override
  void initState() {
    _dateInput.text = " "; //set the initial value of text field
    _timeinput.text = " "; //set the initial value of text field
    _selectedLocation = 'Kuala Lumpur';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Material(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.black,
            width: 5,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Murni Bus Ticket Online',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 80,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Book your ticket today?',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                color: const Color.fromARGB(103, 0, 0, 0),
                height: 1,
                width: w,
              ),
              const SizedBox(height: 40),
              Text(
                'Departure Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 100,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(15),
                width: w / 2,
                child: Center(
                  child: TextField(
                    controller: _dateInput,
                    //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                        ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _dateInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 100,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(15),
                width: w / 2,
                child: Center(
                  child: TextField(
                    controller:
                        _timeinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "Enter Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        print(pickedTime.format(context)); //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          _timeinput.text =
                              formattedTime; //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Departure Station:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 100,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButton(
                hint: const Text(
                    'Please choose a location'), // Not necessary for Option 1
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              Text(
                'Destination Station: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 100,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButton(
                hint: const Text(
                    'Please choose a location'), // Not necessary for Option 1
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation2 = newValue!;
                  });
                },
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              Text(
                'Name ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 100,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(
                    width: w / 3,
                    height: 50,
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'First Name',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: w / 3,
                    height: 50,
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Last Name',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Mobile No ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w / 100,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: w / 3,
                child: const TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mobile No.',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
