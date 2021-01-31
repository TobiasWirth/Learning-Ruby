require "csv"
require "google/apis/civicinfo_v2"
require "erb"


def clean_zipcode(zipcode)

    # if the zip code is exactly five digits, assume that it is ok
    # if the zip code is more than five digits, truncate it to the first five digits
    # if the zip code is less than five digits, add zeros to the front until it becomes five digits

    zipcode.to_s.rjust(5, "0")[0..4]

end

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zip,
            levels: "country",
            roles: ["legislatorUpperBody", "legislatorLowerBody"]
        ).officials

        #legislators = legislators.officials
        #legislator_names = legislators.map(&:name)
        #legislator_names.join(", ")
    
    rescue
        "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"

    end
end

def save_thank_you_letter(id,form_letter)
    Dir.mkdir("output") unless Dir.exists?("output")
  
    filename = "output/thanks_#{id}.html"
  
    File.open(filename,'w') do |file|
      file.puts form_letter
    end
  end

puts "EventManager Initialized!"

file = "event_attendees.csv"

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

if File.exist? file
    
    contents = CSV.open file, headers: true, header_converters: :symbol

    contents.each do |row|

        id = row[0]
        name = row[:first_name]

        zipcode = clean_zipcode(row[:zipcode])

        legislators = legislators_by_zipcode(zipcode)

        #puts "#{name} #{zipcode} #{legislators}"

        form_letter = erb_template.result(binding)

        save_thank_you_letter(id, form_letter)
    end   
end


