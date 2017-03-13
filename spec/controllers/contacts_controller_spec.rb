require 'rails_helper'

RSpec.describe ContactsController do
  describe 'GET#index' do
    before :each do
      get :index
    end

    it 'assigns contacts list' do
      contact = FactoryGirl.create(:contact)
      expect(assigns(:contacts)).to eq([contact])
    end

    it 'lists in alphabetical order by email address' do
      contact1 = FactoryGirl.create(:contact, email_address: 'a_testuser@example.com')
      contact2 = FactoryGirl.create(:contact, email_address: 'b_testuser@example.com')
      expect(assigns(:contacts)).to eq([contact1, contact2])
    end

    it 'renders index template' do
      expect(response).to render_template("index")
    end
  end

  describe 'DELETE#destroy' do
    before :each do
      @contact = FactoryGirl.create(:contact)
      delete :destroy, id: @contact.id
    end

    it 'destroys the contact' do
      expect(Contact.find_by(@contact.id)).to be_nil
    end

    it 'redirects to index template' do
      expect(response).to redirect_to(contacts_path)
    end
  end
end
