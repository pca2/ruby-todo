#!/usr/bin/env ruby
require 'rubygems'
require 'colorize'
require 'thor'
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

class Todo < Thor
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
	desc "add TASK", "Add TASK as To-Do item"
	def add(taskName)
	  Task.create :title => taskName, :status => "To-Do"
	  task_id = Task.last.id 
	   puts "Task #{task_id} added!"
	end

  #list tasks method
  desc "ls", "List tasks"
  option :task_status, :type => :string, :aliases => "-s"
	def ls()
    if options[:task_status]
      Task.all(:status => options[:task_status]).each { |task| 
      puts (task.id.to_s + ": " + task.status + " | " + task.title).yellow
      }
    else
     Task.all().each { |task| 
	   puts (task.id.to_s + ": ").yellow + task.status.green + " | ".red + task.title.blue
	   }
	  end
  end


  #edit task method
  desc "edit ID NEWTITLE ", "edit task to be NEWTITLE"
	def edit(id,title)
	  Task.get(id).update(:title => title)
	  puts "Task #{id} edited to be #{title}."
	end

  desc "do ID", "set ID to status Done"
	#Do task method
	def do(id)
	  Task.get(id).update(:status => "Done")
	  puts "Task #{id} marked done!"
	end

  desc "rm ID", "Delete task ID"
	#Remove task method
	def rm(id)
	  Task.get(id).destroy
	  puts "Task #{id} removed!"
	end

# End Class
end

Todo.start(ARGV)