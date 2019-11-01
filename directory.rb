# put the list of students into an array
students = [
  "Dr. Hannibal Lecter",
  "Darth Vader",
  "Nurse Ratched",
  "Michael Corleone",
  "Alex DeLarge",
  "The Wicked Witch of the West",
  "Terminator",
  "Freddy Krueger",
  "The Joker",
  "Joffrey Baratheon",
  "Norman Bates"
]
# print out the students
puts "The students of Villains Academy"
puts "-" * 10
students.each { |student| puts student }
# print out total number of students
puts "Overall, we have #{students.count} great students"