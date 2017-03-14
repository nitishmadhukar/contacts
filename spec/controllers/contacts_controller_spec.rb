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

  describe 'POST#upload' do
    before :each do
      @file = Faker::File.file_name
      @contact = FactoryGirl.create(:contact)
    end

    it 'imports the csv file' do
      expect(Contact).to receive(:import)
      post :upload, file: @file
    end

    it 'assigns contacts list' do
      allow(Contact).to receive(:import)
      post :upload, file: @file
      expect(assigns(:contacts)).to eq([@contact])
    end

    it 'responds with status 200' do
      allow(Contact).to receive(:import)
      post :upload, file: @file
      expect(response.status).to eq(200)
    end
  end

  describe 'POST#destroy_multiple' do
    before :each do
      2.times { FactoryGirl.create(:contact) }
      @test_ids = Contact.ids.map(&:to_s)
    end

    it 'destroys multiple contacts' do
      expect(Contact).to receive(:destroy_multiple).with(@test_ids)
      post :destroy_multiple, ids: @test_ids
    end

    it 'assigns contacts list' do
      allow(Contact).to receive(:destroy_multiple).and_return([])
      post :destroy_multiple, ids: @test_ids
      expect(assigns(:contacts)).to eq([])
    end

    it 'responds with status 200' do
      allow(Contact).to receive(:destroy_multiple).and_return([])
      post :destroy_multiple, ids: @test_ids
      expect(response.status).to eq(200)
    end
  end
end
