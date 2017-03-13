require 'csv'

module FileUpload
  class Csv
    def initialize(file)
      @file = file
    end

    def parse
      data = []
      CSV.foreach(@file.path,
        headers: true,
        converters: :all,
        header_converters: :symbol
      ) do |row|
          data << row.to_hash
      end
      return data
    end
  end
end
