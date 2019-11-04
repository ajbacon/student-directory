@students = []
@saved = 0
# get user input for student names
def input_students
  clear_terminal
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = gets.chomp

  while !name.empty? do
    @students << {name: name, cohort: :november}
    if @students.count == 1
      puts "Now we have #{@students.count} student"
    else
      puts "Now we have #{@students.count} students"
    end
    name = STDIN.gets.chomp
  end
  @students
end
# print out the students
def print_header
  puts "The students of Villains Academy"
  puts "-" * 10
end
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
  puts "9. Exit"
  puts
end

def show_students
  clear_terminal
  print_header
  print_students_list
  print_footer
  pause_program
end

def clear_terminal
  system("cls") || system("clear")
end

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
    when "9"
      exit_check
    else
      puts "I don't know what you meant, please try again."
    end
  end
end

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student| 
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  @saved = @students.count
  file.close
  clear_terminal
  puts "Students saved to 'students.csv'"
  pause_program
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
  else
    puts "#{filename} doesn't exist"
    exit
  end
end

def load_students(filename = "students.csv")
  file = File.open("students.csv")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  @saved = @students.count
  file.close
  clear_terminal
  puts "#{@students.count} Students loaded from #{filename}"
  pause_program
end

def pause_program
  puts
  puts "Press enter to continue"
  pause = STDIN.gets
end

try_load_students
interactive_menu