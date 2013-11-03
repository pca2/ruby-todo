#!/usr/bin/env ruby
require 'rubygems'
require 'data_mapper'

#DB file to store data
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}//todo.db")

#ORM data structure
class Task
	include DataMapper::Resource

	property :id, Serial
	property :title, String
	property  :status, String
	property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!


#Add a task method
def add_task(taskName)
  Task.create :title => taskName, :status => "To-Do"
end

#list tasks method
def list_tasks(status = "To-do")

end

#update task method
def update_task(id)

end

#Remove task method
def remove_task()

end

#case handling for each method at runtime
case
  when ARGV[0] == "ls"
    list_tasks()
end
