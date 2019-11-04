@students = []
# get user input for student names
def input_students
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
    
    name = gets.chomp
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
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit"
  puts
end

def show_students
  print_header
  print_students_list
  print_footer
  puts
end

def interactive_menu
  loop do
    print_menu
    selection = gets.chomp
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
      exit
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
  file.close
  puts "Students saved to 'students.csv'"
  puts
end

def load_students
  file = File.open("students.csv")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
  puts "#{@students.count} Students loaded from 'students.csv'"
  puts
end

interactive_menu