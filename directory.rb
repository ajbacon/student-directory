#---------------------------------------
# comments
# this file will continue to be updated with additional exercises from steps 8 & 14
# 
# code getting slightly unruly, can group into modules?
# think about creating classes? How to go about this?
# Is there a better way to deal with the case/when or if/elsif
# Error handling refactoring required for save and load file
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
  puts "3. Save to file"
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
  clear_terminal
  puts "SAVE FILE"
  puts "-" * "SAVE FILE".length
  puts
  list_of_files = list_csv_files
  if list_of_files.empty?
    filename = user_enter_filename
  else
    filename = select_filename(list_of_files)
  end
  puts
  File.open(filename, "w") do |file|
    file.puts @default_cohort
    @students.each do |student| 
      student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      file.puts csv_line
    end
  end
  @saved = @students.count
  #file.close
  puts
  puts "Students saved to '#{filename}'"
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
  if filename.nil?
    puts "No directory specified on start-up, empty directory will be opened."
    open_empty_directory
  elsif !File.exists?(filename)
    puts "Directory specified on start-up does not exist, empty directory will be opened."
    open_empty_directory
  else
    load_students(filename)
    interactive_menu
  end
end

def open_empty_directory
  set_default_cohort
  pause_program
  interactive_menu
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
  @months.each_with_index{ |month, index| puts "#{index + 1}. #{month.capitalize}" }
  puts
end

def select_filename(list_of_files)
  puts "Please choose file to save or press return to enter a new filename."
  selection = STDIN.gets.chomp
  return selection.empty? ? user_enter_filename : list_of_files[selection.to_i - 1]
end

def list_csv_files
  csv_files = Dir.glob("*.csv")
  puts "Available student directories:"
  puts dashes ("Available student directories:".length)
  puts
  if csv_files.count > 0
    csv_files.each_with_index{ |file, index| puts "#{index + 1}. #{file}" }
    puts
  else
    puts "There are no student directories in the working folder."
    puts
  end
  puts dashes ("Available student directories:".length)
  csv_files
end

def dashes(num)
  "-" * num
end

def user_enter_filename
  puts
  puts "Please enter filename with extension '*.csv'"
  puts
  print "filename: "
  STDIN.gets.chomp
  # re-factor: add capability to check correct file extension
end

try_load_students

#---------------------------------------------------------------------------------------------------------------------

=begin
1. After we added the code to load the students from file, we ended up with adding the students to @students in two places. The lines in load_students() and input_students() are almost the same. This violates the DRY (Don't Repeat Yourself) principle. How can you extract them into a method to fix this problem?
done

2. How could you make the program load students.csv by default if no file is given on startup? Which methods would you need to change?
done - but eventually removed by implementing 6.

3. Continue refactoring the code. Which method is a bit too long? What method names are not clear enough? Anything else you'd change to make your code look more elegant? Why?
Are you ever done re-factoring?!?!

4. Right now, when the user choses an option from our menu, there's no way of them knowing if the action was successful. Can you fix this and implement feedback messages for the user?
done - also cleared the terminal between menus

5. The filename we use to save and load data (menu items 3 and 4) is hardcoded. Make the script more flexible by asking for the filename if the user chooses these menu items.


6. We are opening and closing the files manually. Read the documentation of the File class to find out how to use a code block (do...end) to access a file, so that we didn't have to close it explicitly (it will be closed automatically when the block finishes). Refactor the code to use a code block.
done

7. We are de-facto using CSV format to store data. However, Ruby includes a library to work with the CSV files that we could use instead of working directly with the files. Refactor the code to use this library.
Not done

8. Write a short program that reads its own source code (search StackOverflow to find out how to get the name of the currently executed file) and prints it on the screen.
rescue => exception
done - although my solution not a pure quine as it reads the file from the filesystem.
  
=end