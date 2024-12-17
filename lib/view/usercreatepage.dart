import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_handler/view/view_users.dart';
import 'package:user_handler/view_model/user_view_model.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _clearTextfields() {
    _nameController.clear();
    _addressController.clear();
    _emailController.clear();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider
          .createUser(
        context: context,
        name: _nameController.text,
        email: _emailController.text,
        address: _addressController.text,
      )
          .then((_) {
        // After the user is created, clear the text fields
        _clearTextfields();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _clearTextfields(); // You can call this if you want to clear the fields on screen load.
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurpleAccent;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          'Create User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter User Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person, color: themeColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter a name' : null,
                        ),
                        SizedBox(height: 15),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email, color: themeColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter an email';
                            } else if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        // Address Field
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            prefixIcon:
                                Icon(Icons.location_on, color: themeColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter an address' : null,
                        ),
                        SizedBox(height: 25),
                        // Submit Button
                        Center(
                          child: provider.isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Create User',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: 20),
                        // View Users Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewUsersPage()),
                              );
                            },
                            icon: Icon(Icons.list, color: Colors.white),
                            label: Text(
                              'View Users',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Error Message
                        if (provider.errorMessage != null)
                          Center(
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        // Success Message
                        if (provider.createdUser != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(thickness: 1, color: themeColor),
                              SizedBox(height: 10),
                              Text(
                                'User Created Successfully!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: themeColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Name: ${provider.createdUser!.name}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Email: ${provider.createdUser!.email}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Address: ${provider.createdUser!.address}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'ID: ${provider.createdUser!.id}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
