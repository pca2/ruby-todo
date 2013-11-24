#!/usr/bin/env ruby
require 'rubygems'
require 'data_mapper'#DB ORM gem
#A very basic CLI to-do app using Ruby and SQLite
#Author: Carleton Atwater <atwaterc@gmail.com>
#DB file to store data
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}//todo.db")

#ORM data structure
class Task
	include DataMapper::Resource

	property :id, Serial
	property :title, String
	property :status, String
	property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!


#Add a task method
def add_task(taskName)
  Task.create :title => taskName, :status => "To-Do"
  puts "Task added!"
end

#list tasks method
def list_tasks()
  Task.all().each { |task| 
  puts task.id.to_s + ": " + task.title + " | " + task.status
}
end

#update task method
def update_task(id,title)
  Task.get(id).update(:title => title)
  puts "Task #{id} updated to #{title}."
end

#Do task method
def do_task(id)
  Task.get(id).update(:status => "Done")
  puts "Task #{id} marked done!"
end


#Remove task method
def remove_task(id)
  t = Task.get(id).destroy
  puts "Task #{id} removed!"
end


#case handling for each method at runtime
case ARGV[0]
  when "ls"
    if ARGV[1]
      list_tasks(ARGV[1]) 
    else 
      list_tasks()
    end
  when "update"
    update_task(ARGV[1],ARGV[2])
  when "rm"
    remove_task(ARGV[1])
  when "add"
    add_task(ARGV[1])
  when "do"
    do_task(ARGV[1])
end
