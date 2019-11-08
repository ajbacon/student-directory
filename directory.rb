#---------------------------------------
#
# comments
# this file will continue to be updated with additional exercises from steps 8 & 14
# 
# code getting slightly unruly, can group into modules?
# think about creating classes? How to go about this?
# Is there a better way to deal with the case/when or if/elsif
#
#
#---------------------------------------

@students = []
#@student_file = "No File Loaded/Saved"
@saved = 0
@months = [
  :january,
  :february,
  :march,
  :april,
  :may,
  :june,
  :july,
  :august,
  :september,
  :october,
  :november,
  :december
]

# get user input for student names
def input_students
  clear_terminal
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = gets.chomp

  while !name.empty? do
    add_student(name)
    if @students.count == 1
      puts "Now we have #{@students.count} student"
    else
      puts "Now we have #{@students.count} students"
    end
    name = STDIN.gets.chomp
  end
  @students
end

def add_student(name, cohort = @default_cohort)
  @students << {name: name, cohort: cohort}
end


def print_header
  puts "The students of Villains Academy"
  puts "-" * 10
end

# print out the students
def print_students_list
  @students.each_with_index { |student, index| puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)" }
end
def print_footer
  if @students.count == 1
    puts "Overall, we have #{@students.count} great student"
  else
    puts "Overall, we have #{@students.count} great students"
  end
end

# prints out the menu options
def print_menu
  clear_terminal
  puts "MAIN MENU"
  puts "---------"
  puts
  puts "Please Select one of the following options:"
  puts
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "5. Select Default Cohort (current: #{@default_cohort})"
  puts "9. Exit"
  puts
 # puts "Current student-directory file: #{@student_file}"
 # puts
end

def show_students
  clear_terminal
  print_header
  print_students_list
  print_footer
  pause_program
end

#clear the terminal between screens
def clear_terminal
  system("cls") || system("clear")
end

# check to see if students need saving before exit
def exit_check
  if @students.count > @saved
    puts "Students added since last save, are you sure you want to quit? (y/n)"
    input = STDIN.gets.chomp
    while true
      if input == "Y" || input == "y" 
        exit
      elsif input == "N" || input == "n"
        return
      else
      end
    end
  else
    exit
  end
end

# manage response to user input
def interactive_menu
  loop do
    print_menu
    selection = STDIN.gets.chomp
    case selection 
    when "1"
      @students = input_students
    when "2"
      show_students
    when "3"
      save_students
    when "4"
      load_students
    when "5"
      select_cohort
    when "9"
      exit_check
    else
      puts "I don't know what you meant, please try again."
    end
  end
end

# save the students to file
def save_students
  File.open("students.csv", "w") do |file|
    file.puts @default_cohort
    @students.each do |student| 
      student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      file.puts csv_line
    end
  end
  @saved = @students.count
  #file.close
  clear_terminal
  puts "Students saved to 'students.csv'"
  pause_program
end

 # load the students from file
def load_students(filename = "students.csv")
  File.open("students.csv","r") do |file|
    stored_cohort = file.readline.chomp
    set_default_cohort(stored_cohort.to_sym)
    file.readlines.each do |line|
      name, cohort = line.chomp.split(",")
      add_student(name, cohort.to_sym)
    end
  end
  @saved = @students.count
  #file.close
  clear_terminal
  puts "#{@students.count} Students loaded from #{filename}"
  pause_program
end

# try loading students from startup
def try_load_students
  filename = ARGV.first
  return empty_args if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    interactive_menu
  else
    puts "#{filename} doesn't exist"
    exit
  end
end

def empty_args
  if File.exists?("students.csv")
    load_students
    interactive_menu
  else
    clear_terminal
    puts "No default student directory found, empty directory will be opened."
    set_default_cohort
    pause_program
    interactive_menu
  end
end

# pause program after printing information
def pause_program
  puts
  puts "Press enter to continue"
  pause = STDIN.gets
end

def set_default_cohort(cohort = :january)
  @default_cohort = cohort
end

def select_cohort
  cohort_menu
  selection = STDIN.gets.chomp
  cohort = @months[selection.to_i - 1]
  set_default_cohort(cohort.to_sym)
end

def cohort_menu
  clear_terminal
  puts "Select the cohort to apply to student inputs:"
  puts
  @months.each_with_index do |month, index|
    puts "#{index + 1}. #{month.capitalize}"
  end
  puts
end

=begin
def select_filename
  list_files = list_csv_files

end

def list_csv_files
  csv_files = Dir.glob("*.csv")
  if csv_files.count > 0
    csv_file.each_with_index{ |index, file| puts "#{index}. #{file}"}
    puts "Please choose file to save or press return to enter a new filename."
    
end
=end

try_load_students