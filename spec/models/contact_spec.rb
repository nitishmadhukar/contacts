require 'rails_helper'

RSpec.describe Contact do
  before :each do
    @contact = FactoryGirl.build(:contact)
  end

  describe '#new' do
    context 'invalid' do
      it 'without first_name' do
        @contact.first_name = nil
        expect(@contact).to be_invalid
      end

      it 'without last_name' do
        @contact.last_name = nil
        expect(@contact).to be_invalid
      end

      it 'without email_address' do
        @contact.email_address = nil
        expect(@contact).to be_invalid
      end

      it 'without phone_number' do
        @contact.phone_number = nil
        expect(@contact).to be_invalid
      end

      it 'without company_name' do
        @contact.company_name = nil
        expect(@contact).to be_invalid
      end

      it 'with wrong email_address format' do
        @contact.email_address = 'test_email'
        expect(@contact).to be_invalid
      end

      it 'with existing email_address' do
        existing_contact = FactoryGirl.create :contact
        @contact.email_address = existing_contact.email_address
        expect(@contact).to be_invalid
      end
    end

    context 'valid' do
      it 'with required attributes' do
        expect(@contact).to be_valid
      end

      it 'without extension' do
        @contact.extension = nil
        expect(@contact).to be_valid
      end
    end
  end

  describe '#format_phone_number' do
    it 'removes 1- at start of phone_number field' do
      @contact.phone_number = '1-999-999-0000'
      @contact.send(:format_phone_number)
      expect(@contact.phone_number).to eq('9999990000')
    end

    it 'removes . in phone_number field' do
      @contact.phone_number = '999.999.0000'
      @contact.send(:format_phone_number)
      expect(@contact.phone_number).to eq('9999990000')
    end

    it 'removes () in phone_number field' do
      @contact.phone_number = '(999)9990000'
      @contact.send(:format_phone_number)
      expect(@contact.phone_number).to eq('9999990000')
    end

    context 'when phone_number has extension' do
      before :each do
        @contact.phone_number = '9999990000x1234'
      end

      it 'extracts number from phone_number' do
        @contact.send(:format_phone_number)
        expect(@contact.phone_number).to eq('9999990000')
      end

      it 'extracts extension from phone_number' do
        expect(@contact).to receive(:format_extension)
        @contact.send(:format_phone_number)
      end
    end
  end

  describe '#format_extension' do
    context 'when phone_number has extension' do
      it 'formats the extension' do
        @contact.phone_number = '9999990000x1234'
        @contact.send(:format_phone_number)
        expect(@contact.extension).to eq('1234')
      end
    end

    context 'when phone_number has no extension' do
      it 'sets extension as nil' do
        @contact.phone_number = '9999990000'
        @contact.send(:format_phone_number)
        expect(@contact.extension).to be_blank
      end
    end
  end

  describe '#format_company_name' do
    it 'removes " in company_name field' do
      @contact.company_name = '"test company"'
      @contact.send(:format_company_name)
      expect(@contact.company_name).to eq('test company')
    end
  end
end
