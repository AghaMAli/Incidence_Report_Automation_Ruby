require 'json'
require 'colorize'

# Method to display the app name in a styled format
def display_app_name
  puts "\n\n\n"
  puts "**************************************************".center(80)
  puts "*           Incident Response Automation         *".center(80)
  puts "**************************************************".center(80)
  puts "\n\n\n"
end

# Method to display the main menu
def display_menu
  puts "\nMain Menu:"
  puts "1. View Incidents"
  puts "2. Create Incident"
  puts "3. Update Incident"
  puts "4. Resolve Incident"
  puts "5. Delete Incident"
  puts "6. Exit"
end

# Method to load incidents from JSON file
def load_incidents
  if File.exist?('incidents.json')
    json_data = File.read('incidents.json')
    $incidents = JSON.parse(json_data)
  else
    $incidents = []
  end
end

# Method to save incidents to JSON file
def save_incidents
  File.open('incidents.json', 'w') do |file|
    file.write(JSON.pretty_generate($incidents))
  end
end

# Method to log incident actions to a file
def log_action(action)
  File.open('incident_log.txt', 'a') do |file|
    file.puts "#{action} at #{Time.now}"
  end
end

# Method to handle creating a new incident
def create_incident
  print "Enter incident description: "
  description = gets.chomp
  $incidents << description
  save_incidents
  log_action("Incident created: #{description}")
  puts "Incident created successfully.".colorize(:green)
end

# Method to handle updating an incident
def update_incident
  view_incidents
  print "Enter incident number to update: "
  index = gets.chomp.to_i - 1
  if index >= 0 && index < $incidents.length
    print "Enter new description: "
    new_description = gets.chomp
    old_description = $incidents[index]
    $incidents[index] = new_description
    save_incidents
    log_action("Incident updated:\nFrom: #{old_description}\nTo: #{new_description}")
    puts "Incident updated successfully.".colorize(:green)
  else
    puts "Invalid incident number.".colorize(:red)
  end
end

# Method to handle resolving an incident
def resolve_incident
  view_incidents
  print "Enter incident number to resolve: "
  index = gets.chomp.to_i - 1
  if index >= 0 && index < $incidents.length
    resolved_incident = $incidents[index]
    $incidents.delete_at(index)
    save_incidents
    log_action("Incident resolved: #{resolved_incident}")
    puts "Incident resolved and removed from the list.".colorize(:green)
  else
    puts "Invalid incident number.".colorize(:red)
  end
end

# Method to handle deleting an incident
def delete_incident
  view_incidents
  print "Enter incident number to delete: "
  index = gets.chomp.to_i - 1
  if index >= 0 && index < $incidents.length
    deleted_incident = $incidents[index]
    $incidents.delete_at(index)
    save_incidents
    log_action("Incident deleted: #{deleted_incident}")
    puts "Incident deleted successfully.".colorize(:green)
  else
    puts "Invalid incident number.".colorize(:red)
  end
end

# Method to handle viewing incidents
def view_incidents
  load_incidents
  if $incidents.empty?
    puts "No incidents to display."
  else
    puts "List of Incidents:"
    $incidents.each_with_index do |incident, index|
      puts "#{index + 1}. #{incident}"
    end
  end
end

# Main program loop
loop do
  display_app_name
  display_menu

  print "\nEnter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    view_incidents
  when 2
    create_incident
  when 3
    update_incident
  when 4
    resolve_incident
  when 5
    delete_incident
  when 6
    puts "Exiting..."
    break
  else
    puts "Invalid choice! Please try again.".colorize(:red)
  end

  puts "\nPress enter to continue..."
  gets.chomp # Pause after action
end

puts "Thank you for using the Incident Response Automation system!"
