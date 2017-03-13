require 'csv'

module FileUpload
  class Csv
    def initialize(file)
      @file = file
    end

    def parse
      data = []
      CSV.foreach(@file,
        headers: true,
        converters: :all,
        header_converters: lambda { |column| column.downcase.gsub(' ', '_') }
      ) do |row|
          data << row.to_hash
      end
      return data
    end
  end
end
