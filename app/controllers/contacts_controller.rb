class ContactsController < ApplicationController
  def index
  	@contacts = Contact.order(:email_address)
  end

  def destroy
  	Contact.find(params[:id]).destroy
  	redirect_to contacts_path
  end

  def destroy_multiple
    remaining_contacts = Contact.destroy_multiple(params[:ids])
    @contacts = Array(remaining_contacts)
    render json: {contacts: @contacts, message: 'Delete successful.'}, status: :ok
  end

  def upload
  	status = Contact.import(params[:file])
  	@contacts = Contact.order(:email_address)
  	render json: {contacts: @contacts, message: status}, status: :ok
  end
end
