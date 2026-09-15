import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/india_states_districts.dart';
import '../home/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController upiController = TextEditingController();

  bool upiLocked = false;
  bool nameLocked = false;
  bool isLoading = false;
  String? selectedState;
  String? selectedDistrict;
  int? selectedAvatar;

  final List<String> avatars = List.generate(10, (index) => "assets/avatars/avatar${index + 1}.png");

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final doc = await _firestore.collection("users").doc(user.uid).get();
    if (!doc.exists) return;
    final data = doc.data()!;
    nameController.text = data["name"] ?? "";
    emailController.text = data["email"] ?? "";
    mobileController.text = data["phone"] ?? "";
    stateController.text = data["state"] ?? "";
    cityController.text = data["city"] ?? "";
    if (data["avatarEnabled"] == true && data["avatar"] is int) selectedAvatar = data["avatar"];
    upiController.text = data["upiId"] ?? "";
    upiLocked = data["upiLocked"] ?? false;
    nameLocked = data["nameLocked"] ?? false;
    selectedState = data["state"];
    selectedDistrict = data["district"];
    if (mounted) setState(() {});
  }

  Future<void> saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;
    setState(() => isLoading = true);
    try {
      await _firestore.collection("users").doc(user.uid).update({
        "name": nameController.text.trim(), "nameLocked": true,
        "email": emailController.text.trim(), "phone": mobileController.text.trim(), "mobileLocked": true,
        "state": selectedState, "district": selectedDistrict,
        "upiId": upiController.text.trim(), "upiLocked": true,
        "profileCompleted": true,
        "avatar": selectedAvatar, "avatarEnabled": selectedAvatar != null,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated Successfully")));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose(); emailController.dispose(); mobileController.dispose();
    stateController.dispose(); cityController.dispose(); upiController.dispose();
    super.dispose();
  }

  Widget buildTextField({required TextEditingController controller, required String label, bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(controller: controller, readOnly: readOnly, keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: selectedAvatar == null ? null : AssetImage(avatars[selectedAvatar! - 1]),
              child: selectedAvatar == null ? const Icon(Icons.person_outline, size: 52, color: Colors.grey) : null,
            ),
            const SizedBox(height: 15),
            const Text("Choose Avatar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(height: 170, child: GridView.builder(
              itemCount: avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) => InkWell(
                onTap: () => setState(() => selectedAvatar = index + 1),
                child: CircleAvatar(backgroundImage: AssetImage(avatars[index]), radius: 28),
              ),
            )),
          ])),
          const SizedBox(height: 25),
          buildTextField(controller: nameController, label: "Full Name", readOnly: nameLocked),
          buildTextField(controller: emailController, label: "Email", keyboardType: TextInputType.emailAddress),
          buildTextField(controller: mobileController, label: "Mobile Number", readOnly: true, keyboardType: TextInputType.phone),
          DropdownButtonFormField<String>(
            menuMaxHeight: 300, isExpanded: true,
            value: IndiaStatesDistricts.data.containsKey(selectedState) ? selectedState : null,
            decoration: const InputDecoration(labelText: "State", border: OutlineInputBorder()),
            items: IndiaStatesDistricts.data.keys.map((state) => DropdownMenuItem<String>(value: state, child: Text(state, overflow: TextOverflow.ellipsis, maxLines: 1))).toList(),
            onChanged: (value) => setState(() { selectedState = value; selectedDistrict = null; }),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            menuMaxHeight: 300, isExpanded: true, value: selectedDistrict,
            decoration: const InputDecoration(labelText: "District", border: OutlineInputBorder()),
            items: (IndiaStatesDistricts.data[selectedState] ?? []).map((district) => DropdownMenuItem(value: district, child: Text(district))).toList(),
            onChanged: (value) => setState(() => selectedDistrict = value),
          ),
          const SizedBox(height: 15),
          buildTextField(controller: upiController, label: "UPI ID", readOnly: upiLocked),
          if (upiLocked) const Padding(padding: EdgeInsets.only(bottom: 15), child: Text("UPI ID is locked after first save.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          SizedBox(height: 55, child: ElevatedButton(
            onPressed: isLoading ? null : saveProfile,
            child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Save", style: TextStyle(fontSize: 18)),
          )),
        ],
      ),
    );
  }
}
