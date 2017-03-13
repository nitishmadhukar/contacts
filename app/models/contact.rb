class Contact < ActiveRecord::Base
  validates :first_name, :last_name, :email_address, :phone_number, :company_name, presence: true
  validates :email_address, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i } # Tests basic email format
  validates :email_address, uniqueness: true

  before_save :format_phone_number, :format_company_name

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
end
