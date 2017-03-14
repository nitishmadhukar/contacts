import React from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider'; // move to a common file when multiple components
import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui';
import FileUpload from './FileUpload';
import RaisedButton from 'material-ui/RaisedButton';

export default class Contact extends React.Component {
  state = {
    contacts: this.props.contacts,
    disable_delete: true
  }

  static propTypes = {
    contacts: React.PropTypes.array
  }

  addContacts = (contacts) => {
    this.setState({contacts: contacts});
  }

  deleteContacts = () => {
    $.ajax({
      url: '/contacts/destroy_multiple',
      type: 'POST',
      dataType: 'json',
      data: {ids: this.state.selected_contact_ids},
      success: function(data) {
        this.setState({
          contacts: data.contacts,
          disable_delete: true
        });
        alert(data.message);
      }.bind(this),
      error: function(xhr, status, err) {
        alert('Selected contacts could not be deleted.')
        this.setState({
          disable_delete: true
        });
      }.bind(this)
    });
  }

  selectContacts = (selectedRows) => {
    var existing_contact_ids = this.retrieveContactIds(this.state.contacts);
    if(selectedRows == 'all') {
      this.setState({
        selected_contact_ids: existing_contact_ids,
        disable_delete: false
      });
    } else if(selectedRows == 'none') {
      this.setState({
        selected_contact_ids: [],
        disable_delete: true
      });
    } else if(selectedRows.length > 0) {
      let selected_ids = [];
      selectedRows.map((rowNumber) => {
        selected_ids.push(existing_contact_ids[rowNumber]);
      });
      this.setState({
        selected_contact_ids: selected_ids,
        disable_delete: false
      });
    }
  }

  retrieveContactIds = (contacts) => {
    var contact_ids = []
    contacts.map((contact) => {
      contact_ids.push(contact.id)
    });
    return contact_ids
  }

  render() {
    let contacts = this.state.contacts
    return(
      <MuiThemeProvider>
        <div>
          <FileUpload addItems={this.addContacts} />
          <RaisedButton label={'Delete'} secondary={true} onClick={this.deleteContacts} disabled={this.state.disable_delete} />
            <Table onRowSelection={this.selectContacts} multiSelectable={true}>
              <TableHeader>
                <TableRow>
                  <TableHeaderColumn>First Name</TableHeaderColumn>
                  <TableHeaderColumn>Last Name</TableHeaderColumn>
                  <TableHeaderColumn>Email Address</TableHeaderColumn>
                  <TableHeaderColumn>Phone Number</TableHeaderColumn>
                  <TableHeaderColumn>Extn</TableHeaderColumn>
                  <TableHeaderColumn>Company Name</TableHeaderColumn>
                </TableRow>
              </TableHeader>

              <TableBody>
                {contacts.map((contact) =>
                  <TableRow key={contact.id}>
                    <TableRowColumn>{contact.first_name}</TableRowColumn>
                    <TableRowColumn>{contact.last_name}</TableRowColumn>
                    <TableRowColumn>{contact.email_address}</TableRowColumn>
                    <TableRowColumn>{contact.phone_number}</TableRowColumn>
                    <TableRowColumn>{contact.extension}</TableRowColumn>
                    <TableRowColumn>{contact.company_name}</TableRowColumn>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </div>
      </MuiThemeProvider>
    );
  }
}
