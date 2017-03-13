class ContactsController < ApplicationController
  def index
  	@contacts = Contact.order(:email_address)
  end

  def destroy
  	Contact.find(params[:id]).destroy
  	redirect_to contacts_path
  end
end
