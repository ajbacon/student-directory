# get user input for student names
def input_students
  puts "Please enther the names of the students"
  puts "To finish, just hit return twice"
  students = []
  name = gets.gsub("\n","")

  while !name.empty? do
    students << {name: name, cohort: :november}
    if students.count == 1
      puts "Now we have #{students.count} student"
    else
      puts "Now we have #{students.count} students"
    end
    
    name = gets
    name = name.gsub("\n","")
  end
  students
end
# print out the students
def print_header
  puts "The students of Villains Academy"
  puts "-" * 10
end
def print(students)
  students.each_with_index { |student, index| puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)" }
end
def print_footer(students)
  if students.count == 1
    puts "Overall, we have #{students.count} great student"
  else
    puts "Overall, we have #{students.count} great students"
  end
end

students = input_students
#puts students.count
if students.count == 0
  puts "There are no students in the Directory"
else
  print_header
  print(students)
  print_footer(students)
end

=begin
def interactive_menu
  loop do
    puts "1. Input the students"
    puts "2. Show the students"
    puts "9. Exit"
    
    selection = gets.chomp
  end
end
=end



