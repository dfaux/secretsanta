require_relative "Person"
require_relative "Santa"
require 'json'
require 'optparse'
require 'configatron'
require_relative 'config'

def send_emails(santa)
  print "Are you sure you want to send the email? (Y/N) "
  is_sure = gets.chomp.upcase
  if is_sure == "Y" || is_sure == "YES" then
    puts "Sending the emails"
    santa.send_all_emails(@options[:verbose])
  else
    puts "Not sending email"
  end
end

# if needed, it can be hard coded
def rig_santas(people)
  santas = people.dup
  santas[0] = people[5] # 0 gets from 5
  santas[1] = people[2] # 1 gets from 2
  santas[2] = people[0] # 2 gets from 0
  santas[3] = people[4] # 3 gets from 4
  santas[4] = people[1] # 4 gets from 1
  santas[5] = people[3] # 5 gets from 3
  (0..(people.size-1)).each { |n| people[n].santa = santas[n] }
  santas
end

def assign_santas(family)
  santa = Santa.new(family)
  santas = santa.assign
  #santas = rig_santas(people)
  
  family.each { |p| puts "#{p.name} gets from #{p.santa.name} - #{p.email}" } if @options[:verbose]

  santa
end 

def load_family(people)
  family = people[@options[:family_name]].inject([]) {|fam, member| fam << Person.new(member["name"], member["email"], member["spouse"])}
  puts "Family members found for #{@options[:family_name]}: #{family.size}" if @options[:verbose]
  family
end

def parse_file
  file = File.read(@options[:input_file])
  people = JSON.parse(file)
  puts "Families loaded: #{people.length}" if @options[:verbose]
  people
end

def show_config
  puts "Configuration:"
  puts "  Input file:    #{@options[:input_file]}"
  puts "  Family name:   #{@options[:family_name]}"
  puts "  Send emails:   #{@options[:send_emails]}"
  puts "  Verbose msgs:  #{@options[:verbose]}"
  puts
  puts "  SMTP Address:  #{configatron.email.smtp.address}"
  puts "  SMTP Port:     #{configatron.email.smtp.port}"
  puts "  SMTP Username: #{configatron.email.smtp.username}"
  puts "  SMTP Domain:   #{configatron.email.smtp.domain}"
  puts
end

def parse_options
  OptionParser.new do |opts|
    opts.banner = "Usage: secretsanta.rb [options]"
    opts.on("-i", "--input-file filename", "Input file name") do |input|
      @options[:input_file] = input
    end
    opts.on("-f", "--family-name familyname", "Input family name to use") do |fam|
      @options[:family_name] = fam
    end
    opts.on("-s", "--send-emails", "Turn on email sending") do
      @options[:send_emails] = true
    end
    opts.on("-v", "--verbose", "Turn on verbose messaging") do
      @options[:verbose] = true
    end
  end.parse!

  if @options[:send_emails] == nil
    @options[:send_emails] = false
  end

  if @options[:verbose] == nil
    @options[:verbose] = false
  end

  if @options[:input_file] == nil
    @options[:input_file] = "people.json"
  end

  if @options[:family_name] == nil
    print "Enter family name to use: "
    @options[:family_name] = gets.chomp
  end
end

@options = {}
parse_options
people = parse_file
family = load_family(people)
show_config if @options[:verbose]
santa = assign_santas(family)

if @options[:send_emails] then
  send_emails(santa)
end
