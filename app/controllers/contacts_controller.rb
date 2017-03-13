class ContactsController < ApplicationController
  def index
  	@contacts = Contact.order(:email_address)
  end

  def destroy
  	Contact.find(params[:id]).destroy
  	redirect_to contacts_path
  end

  def upload
  	status = Contact.import(params[:file])
  	@contacts = Contact.order(:email_address)
  	render json: {contacts: @contacts, message: status}, status: :ok
  end
end
