import 'package:flutter/material.dart';

import '../models/doctor_model.dart';
import '../services/doctor_service.dart';
import 'health_page_widgets.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final TextEditingController _searchController =
  TextEditingController();

  List<Doctor> doctors = [];

  bool isLoading = true;
  String? errorMessage;
  String selectedDepartment = 'All';

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await DoctorService.getDoctors();

      if (!mounted) return;

      setState(() {
        doctors = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  List<String> get departments {
    final list = doctors
        .map((doctor) => doctor.departmentName.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    list.sort();

    return list;
  }

  List<Doctor> get filteredDoctors {
    final String query =
    _searchController.text.trim().toLowerCase();

    return doctors.where((doctor) {
      final bool matchesDepartment =
          selectedDepartment == 'All' ||
              doctor.departmentName == selectedDepartment;

      if (!matchesDepartment) {
        return false;
      }

      // Search box empty = show all doctors
      if (query.isEmpty) {
        return true;
      }

      // Search from API doctor information
      return doctor.name.toLowerCase().contains(query) ||
          doctor.departmentName.toLowerCase().contains(query) ||
          doctor.specialization.toLowerCase().contains(query) ||
          doctor.qualification.toLowerCase().contains(query) ||
          doctor.designation.toLowerCase().contains(query) ||
          doctor.phone.toLowerCase().contains(query) ||
          (doctor.hospital ?? '')
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  IconData _departmentIcon(String department) {
    final name = department.toLowerCase();

    if (name.contains('cardio') ||
        name.contains('heart')) {
      return Icons.favorite;
    }

    if (name.contains('pulmo') ||
        name.contains('chest')) {
      return Icons.air;
    }

    if (name.contains('neuro') ||
        name.contains('brain')) {
      return Icons.psychology;
    }

    if (name.contains('eye')) {
      return Icons.visibility;
    }

    if (name.contains('dental')) {
      return Icons.medical_services;
    }

    if (name.contains('medicine')) {
      return Icons.medication;
    }

    return Icons.local_hospital;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HealthPageScaffold(
      title: 'Doctors',
      subtitle: 'Your care and appointments',
      children: [
        const SizedBox(height: 12),

        // SEARCH
        _buildSearch(),

        const SizedBox(height: 16),

        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 70),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (errorMessage != null)
          _buildError()
        else ...[


            _buildDoctorTitle(),

            const SizedBox(height: 9),

            if (filteredDoctors.isEmpty)
              _buildEmpty()
            else
              ...filteredDoctors.map(
                    (doctor) => _DoctorCard(
                  doctor: doctor,
                  departmentIcon:
                  _departmentIcon(
                    doctor.departmentName,
                  ),
                ),
              ),
          ],

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSearch() {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search doctors...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 22,
          ),
          suffixIcon:
          _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              size: 19,
            ),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blueGrey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue.shade400,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentSection() {
    if (departments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Medical Departments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF17202A),
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 106,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: departments.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final department =
              departments[index];

              final selected =
                  selectedDepartment ==
                      department;

              return InkWell(
                borderRadius:
                BorderRadius.circular(11),
                onTap: () {
                  setState(() {
                    selectedDepartment =
                    selected
                        ? 'All'
                        : department;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: 100,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.blue.shade50
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(11),
                    border: Border.all(
                      color: selected
                          ? Colors.blue.shade400
                          : Colors
                          .blueGrey.shade300,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.04,
                        ),
                        blurRadius: 4,
                        offset:
                        const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        _departmentIcon(
                          department,
                        ),
                        size: 34,
                        color: selected
                            ? Colors.blue.shade600
                            : Colors
                            .blueGrey.shade500,
                      ),

                      const SizedBox(height: 7),

                      Padding(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 4,
                        ),
                        child: Text(
                          '$department\nDepartment',
                          textAlign:
                          TextAlign.center,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style:
                          const TextStyle(
                            fontSize: 10.5,
                            height: 1.15,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDepartment == 'All'
                ? 'All Doctors List'
                : '$selectedDepartment Doctors',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17202A),
            ),
          ),
        ),

        Text(
          '${filteredDoctors.length} doctors',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 45,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.cloud_off,
              size: 42,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            const Text(
              'Unable to load doctors',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadDoctors,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 35,
      ),
      child: Center(
        child: Text(
          'No doctors found',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// COMPACT DOCTOR CARD
// =====================================================

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final IconData departmentIcon;

  const _DoctorCard({
    required this.doctor,
    required this.departmentIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.07,
            ),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // IMAGE PLACEHOLDER
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFE7F0F6,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 39,
                  color:
                  Colors.blueGrey.shade400,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w700,
                              color: Color(
                                0xFF111111,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Icon(
                          departmentIcon,
                          size: 20,
                          color: Colors
                              .blueGrey.shade500,
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    Text(
                      doctor.specialization,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.2,
                        color: Color(
                          0xFF333333,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      doctor.qualification,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color:
                        Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              if (doctor.hospital != null &&
                  doctor.hospital!
                      .trim()
                      .isNotEmpty)
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .local_hospital_outlined,
                        size: 13,
                        color: Colors
                            .blueGrey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.hospital!,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Colors
                                .grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Text(
                    doctor.departmentName,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color:
                      Colors.grey.shade600,
                    ),
                  ),
                ),

              const SizedBox(width: 8),

              SizedBox(
                height: 31,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          doctor.name,
                        ),
                      ),
                    );
                  },
                  style:
                  ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                    const Color(
                      0xFFB9D9F2,
                    ),
                    foregroundColor:
                    const Color(
                      0xFF214E73,
                    ),
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 11,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        8,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}