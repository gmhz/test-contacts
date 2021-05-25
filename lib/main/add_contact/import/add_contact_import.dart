import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kherelcontacts/main/add_contact/import/add_contact_import_provider.dart';
import 'package:kherelcontacts/main/main_screen.dart';
import 'package:provider/provider.dart';

class AddContactImportScreen extends StatefulWidget {
  const AddContactImportScreen({Key key}) : super(key: key);

  @override
  _AddContactImportScreenState createState() => _AddContactImportScreenState();
}

class _AddContactImportScreenState extends State<AddContactImportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AddContactImportProvider>(context, listen: false)
          .loadAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Consumer<AddContactImportProvider>(
      builder: (ctx, provider, widget) {
        return Scaffold(
          appBar: AppBar(
            leading: provider.isLoading ? Container() : null,
            title: Text("Phone numbers"),
            actions: [
              if (!provider.isLoading)
                TextButton(
                  onPressed: () {
                    provider.toggleSelectAll();
                  },
                  child: Text(
                    provider.allSelected ? "Unselect all" : "Select all",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: provider.anySelected && !provider.isLoading
              ? FloatingActionButton.extended(
                  onPressed: () {
                    provider.addSelectedContacts().then((value) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => MainScreen()),
                        (route) => false,
                      );
                    });
                  },
                  backgroundColor: Colors.grey,
                  label: Container(
                    width: 120,
                    child: Text("Add ${provider.selectedCount}",
                        textAlign: TextAlign.center),
                  ),
                )
              : null,
          body: Center(
            child: (provider.isLoading)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(),
                      if (provider.loadingProgress != null)
                        SizedBox(height: 16),
                      if (provider.loadingProgress != null)
                        Text("${provider.loadingProgress} %"),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: provider.contacts.length,
                    itemBuilder: (ctx, index) {
                      var item = provider.contacts.elementAt(index);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 32,
                          child: Image.memory(item.photoBytes),
                        ),
                        title: Text(item.name),
                        subtitle: item.role != null ? Text(item.role) : null,
                        trailing: Checkbox(
                          value: item.selected,
                          onChanged: (val) => provider.updateItem(item, val),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
