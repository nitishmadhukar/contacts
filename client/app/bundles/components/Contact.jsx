import React from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider'; // move to a common file when multiple components
import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui';
import FileUpload from './FileUpload';

export default class Contact extends React.Component {
  state = {
    contacts: this.props.contacts
  }

  static propTypes = {
    contacts: React.PropTypes.array
  }

  addContacts = (contacts) => {
    this.setState({contacts: contacts});
  }

  render() {
    let contacts = this.state.contacts
    return(
      <MuiThemeProvider>
        <div>
          <FileUpload addItems={this.addContacts} />
          <Table>
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