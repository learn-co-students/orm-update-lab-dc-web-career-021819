require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name, @grade, @id = name, grade, id
  end

  def self.create_table
    sql_command("CREATE TABLE IF NOT EXISTS students(
          id INTEGER PRIMARY KEY,
          name TEXT,
         grade INTEGER);")
  end

  def self.drop_table
    sql_command("DROP TABLE students;")
  end

  def self.create(name, grade)
    st = Student.new(name, grade)
    st.save
    st
  end

  def save
    if (self.id.nil?)
      self.class.sql_command("INSERT INTO students(name, grade) VALUES (?,?)", self.name, self.grade)
      self.id = self.class.sql_command("SELECT last_insert_rowid() FROM students")[0][0]
    else
      self.update
    end
  end

  def self.new_from_db(r)
    student = Student.new(r[1], r[2], r[0])
  end

  def self.find_by_name(name)
    found = self.sql_command("SELECT * FROM students WHERE name = ?", name)[0]
    self.new_from_db(found)
  end

  def self.sql_command(str, *args)
    DB[:conn].execute(str, args)
  end

  def update
    self.class.sql_command("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
  end
end
