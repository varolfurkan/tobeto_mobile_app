import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:tobeto_mobile_app/cubits/admin_cubit.dart';
import 'package:tobeto_mobile_app/models/field_model.dart';
import 'package:tobeto_mobile_app/models/notification_model.dart';
import 'package:tobeto_mobile_app/models/user_model.dart';
import 'package:tobeto_mobile_app/repository/user_repository.dart';
import 'package:tobeto_mobile_app/widgets/drawer_menu.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'img/icons/tobeto_icon.svg',
          width: 150,
          semanticsLabel: 'Tobeto Logo',
        ),
      ),
      endDrawer: const DrawerMenu(),
      body: BlocProvider(
        create: (context) => AdminCubit(UserRepository())..getCurrentUser(),
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text('Hata: ${state.error}'));
            } else {
              return NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (state.firebaseUser != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'TOBETO',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff9933ff),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\'ya hoş geldin\n',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff4d4d4d),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: state.adminName ?? 'Admin',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff4d4d4d),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Admin paneline hoş geldiniz!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff4d4d4d),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    SvgPicture.asset(
                                      'img/icons/ik_logo.svg',
                                      width: 200,
                                      semanticsLabel: 'İstanbul Kodluyor Logo',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ];
                },
                body: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: [
                          Tab(text: 'Eğitim Ata'),
                          Tab(text: 'Duyuru Yayınla'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildAssignLessonTab(context, state),
                            _buildPublishNotificationTab(context, state),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAssignLessonTab(BuildContext context, AdminState state) {
    final List<UserModel>? users = state.users;
    final List<FieldModel>? fields = state.fields;
    String? selectedFieldId = state.selectedFieldId;

    if (users == null || users.isEmpty) {
      return const Center(child: Text('Kullanıcı bulunamadı.'));
    } else if (fields == null || fields.isEmpty) {
      return const Center(child: Text('Alan bulunamadı.'));
    } else {
      List<UserModel>? selectedUsers;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Seçilen öğrencilerin ders atamasını yapın:', style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: DropdownButton<String>(
                hint: const Text('Alan Seçin'),
                value: selectedFieldId,
                items: fields.map((field) {
                  return DropdownMenuItem<String>(
                    value: field.fieldName,
                    child: Text(field.fieldName),
                  );
                }).toList(),
                onChanged: (value) {
                  context.read<AdminCubit>().updateSelectedFieldId(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: MultiSelectDialogField<UserModel>(
                items: users.map((user) => MultiSelectItem<UserModel>(user, user.displayName)).toList(),
                title: const Text('Öğrenci Seçin'),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                buttonIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                buttonText:  Text(
                  'Öğrenci Seçin',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  selectedUsers = results;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedUsers != null && selectedUsers!.isNotEmpty && selectedFieldId != null) {
                    _assignLessons(context, selectedUsers!, selectedFieldId);
                  }
                },
                child: const Text('Ata'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _assignLessons(BuildContext context, List<UserModel> users, String? selectedFieldId) async {
    final AdminCubit adminCubit = context.read<AdminCubit>();

    if (selectedFieldId != null) {
      await adminCubit.getFieldLessons(selectedFieldId);

      for (var user in users) {
          await adminCubit.assignLesson(user.uid, selectedFieldId);
        }
    }
  }


  Widget _buildPublishNotificationTab(BuildContext context, AdminState state) {
    final List<NotificationModel>? notifications = state.notifications;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Aktif Duyurular:',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          notifications == null || notifications.isEmpty
              ? const Center(child: Text('Şu an aktif bir duyuru bulunmamaktadır.'))
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              var formattedDate = notification.formattedDate();
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notification.type,
                              style: const TextStyle(color: Color(0xff00956e)),
                            ),
                            const Text(
                              'İstanbul Kodluyor',
                              style: TextStyle(color: Color(0xff00956e)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  context.read<AdminCubit>().deleteNotification(notification.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          notification.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff4d4d4d)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      child: AlertDialog(
                                        title: Text(notification.title),
                                        content: Text(notification.contents),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Kapat'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text('Devamını Oku'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showCreateNotificationDialog(context, context.read<AdminCubit>()),
              child: const Text('Duyuru Yayınla'),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _showCreateNotificationDialog(BuildContext context, AdminCubit adminCubit) async {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String contents = '';
    String type = 'Duyuru';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Duyuru Yayınla'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Duyuru Başlığı'),
                    validator: (value) => value!.isEmpty ? 'Lütfen başlık girin' : null,
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Lütfen duyuru içeriği giriniz.'),
                    validator: (value) => value!.isEmpty ? 'Lütfen içerik girin' : null,
                    onSaved: (value) => contents = value!,
                  ),
                  DropdownButtonFormField<String>(
                    value: type,
                    decoration: const InputDecoration(labelText: 'Tür'),
                    items: <String>['Duyuru', 'Acil'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => type = value!,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('İptal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Duyuru Yayınla'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final notification = NotificationModel(
                      id: '',
                      title: title,
                      contents: contents,
                      type: type,
                      createdAt: DateTime.now(),
                    );
                    adminCubit.createNotification(notification);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
