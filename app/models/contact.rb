class Contact < ActiveRecord::Base
  validates :first_name, :last_name, :email_address, :phone_number, :company_name, presence: true
  validates :email_address, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i } # Tests basic email format
  validates :email_address, uniqueness: true

  before_save :format_phone_number, :format_company_name

  def self.import(file)
    contacts = FileUpload::Csv.new(file).parse
    status = ''
    contacts.each do |contact|
      new_contact = Contact.create(contact)
      status = if new_contact.invalid?
        log_error_for(new_contact)
        'File upload was not successful. Check log for errors.'
      else
        'File uploaded successfully.'
      end
    end
    status
  end

  def self.destroy_multiple(ids)
    transaction do
      where(id: ids).destroy_all
      order(:email_address)
    end
  end

  private

  def format_phone_number
    phone_number = self.phone_number
    phone_number.gsub! /\A(1-)/, ''
    phone_number.gsub! /\W/, ''
    phone_number = Array(phone_number.match(/([0-9]+)([x][0-9]*)?/))
    self.phone_number = phone_number[1]
    self.extension = format_extension(phone_number[2])
  end

  def format_extension(value)
    value.gsub! /[x|X]/, '' if value
    self.extension = value.to_s
  end

  def format_company_name
    self.company_name.gsub! /["]/, ''
  end

  def self.log_error_for(contact)
    file = File.open('log/file_upload_errors.log', 'a+')
    file.puts "#{contact.attributes} #{contact.errors.messages}\n"
    file.close
  end
end
