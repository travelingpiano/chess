class Employee
  attr_accessor :name, :title, :salary, :boss
  def initialize(name,title,salary,boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary*multiplier
  end
end

class Manager < Employee
  attr_reader :employees
  def initialize(name,title,salary,boss)
    @employees = []
    super(name,title,salary,boss)
  end

  def add_employee(employee)
    employee.boss.employees.delete(employee) if employee.boss
    @employees.push(employee)
    employee.boss = self

  end

  def bonus(multiplier)
    sum = 0
    p employees
    employees.each do |el|
      unless el.is_a?(Manager)
        sum += el.salary
      else
        el.employees.each do |el2|
          sum += el2.salary
        end
        sum += el.salary
      end
    end
    sum*multiplier
  end
end

ned = Manager.new('ned','founder',1000000,nil)
darren = Manager.new('darren','ta manager',78000,ned)
david = Employee.new('david','ta',10000,darren)
shawna = Employee.new('shawna','ta',12000,darren)
ned.add_employee(darren)
darren.add_employee(david)
darren.add_employee(shawna)
p ned.employees
p darren.employees
p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
