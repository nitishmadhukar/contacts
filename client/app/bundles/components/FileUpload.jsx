import React from 'react';
import Dropzone from 'react-dropzone';
import RaisedButton from 'material-ui/RaisedButton';

const style = {
  border: 'none'
}

export default class FileUpload extends React.Component {
  state = {
    items: []
  }

  static propTypes = {
    addItems: React.PropTypes.func
  }

  onDrop = (files) => {
    var formData = new FormData();
    var uploaded_file = files[0];
    formData.append('file', uploaded_file, uploaded_file.name)
    $.ajax({
      url: '/contacts/upload',
      type: 'POST',
      data: formData,
      cache: false,
      dataType: 'json',
      processData: false,
      contentType: false,
      success: function(data) {
        alert(data.message);
        this.setState({items: data.contacts});
        this.props.addItems(this.state.items);
      }.bind(this),
      error: function(xhr, status, err) {
        alert('File upload not completely successful. Please verify the log details.');
      }.bind(this)
    });
  }

  render() {
    return(
      <Dropzone onDrop={this.onDrop} multiple={false} style={style}>
        <RaisedButton label={'File Upload'} primary={true} />
      </Dropzone>
    );
  }
}