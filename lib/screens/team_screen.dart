import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  // Data untuk anggota tim
  final List<Map<String, String>> teamMembers = [
    {'name': 'Rievan Averillio', 'nrp': '152022024', 'jobdesk': 'Developer'},
    {'name': 'Afin Maulana', 'nrp': '152022051', 'jobdesk': 'Mekatronika'},
    {
      'name': 'Rikki Subagja',
      'nrp': '152022055',
      'jobdesk': 'Desktop Developer'
    },
    {'name': 'Maulana Seno', 'nrp': '152022065', 'jobdesk': 'Produk'},
    {
      'name': 'Muhammad Aulia',
      'nrp': '152022076',
      'jobdesk': 'Desktop Developer'
    },
    {
      'name': 'Naizirun De Jesus',
      'nrp': '152022077',
      'jobdesk': 'Web Developer'
    },
    {'name': 'Budi Amin', 'nrp': '152022213', 'jobdesk': 'Mobile Developer'},
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
        child: SingleChildScrollView(
          // Membuat seluruh konten scrollable
          child: Column(
            children: [
              GridView.builder(
                // Menambahkan GridView yang dapat digulir
                physics:
                    NeverScrollableScrollPhysics(), // Mencegah GridView bergulir di dalam SingleChildScrollView
                shrinkWrap: true, // Agar GridView tidak mengambil seluruh ruang
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: teamMembers.length,
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
            ],
          ),
        ),
      ),
    );
  }
}
