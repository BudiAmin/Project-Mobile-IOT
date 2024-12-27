import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  // Data untuk anggota tim
  final List<Map<String, String>> teamMembers = [
    {'name': 'Budi Amin', 'nrp': '123456789', 'jobdesk': 'Developer'},
    {'name': 'Diana Sari', 'nrp': '987654321', 'jobdesk': 'Designer'},
    {'name': 'Andi Prasetyo', 'nrp': '112233445', 'jobdesk': 'Project Manager'},
    {'name': 'Rina Agustin', 'nrp': '223344556', 'jobdesk': 'Tester'},
    {
      'name': 'Teguh Santoso',
      'nrp': '334455667',
      'jobdesk': 'Backend Developer'
    },
    {
      'name': 'Lina Maulana',
      'nrp': '445566778',
      'jobdesk': 'Frontend Developer'
    },
    {'name': 'Rizki Maulana', 'nrp': '556677889', 'jobdesk': 'UI/UX Designer'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Members'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount:
              teamMembers.length, // Menyesuaikan jumlah grid dengan anggota tim
          itemBuilder: (context, index) {
            // Mengambil data berdasarkan index
            var member = teamMembers[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, const Color(0xFF053149)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group, // Ikon untuk member
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      member['name']!, // Nama anggota
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      member['nrp']!, // NRP anggota
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      member['jobdesk']!, // Jobdesk anggota
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
