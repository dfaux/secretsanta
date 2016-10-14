#!/usr/bin/ruby
require_relative 'Person'
require 'mail'
require 'configatron'

class Santa
  def initialize(p)
    @people = p
  end

  def num
    @people.size - 1
  end

  def assign
    @santas = @people.dup
    iterations = 0
    until pass_check
      @santas = shuffle
      iterations += 1
    end
    (0..num).each { |n| @people[n].santa = @santas[n] }
    puts "It took #{iterations} times through to match properly"
    @santas
  end

  def pass_check
    (0..num).each do |n|
      if @santas[n].name == @people[n].name
        return false  
      elsif @santas[n].relation 
        if @santas[n].relation == @people[n].name
          return false 
        end 
      end 
    end
    true
  end

  def shuffle
    @people.sort { |a, b| rand(3)-1 }
  end

  def get_email_password
    puts "Enter your email password: "
    system 'stty -echo'
    pw = $stdin.gets.chomp
    system 'stty echo'
    pw
  end

  def send_all_emails(verbose = false)
    pw = get_email_password
    @people.each { |p| send_email(p, verbose, pw) }
  end

  def send_email(p, verbose = false, pw = '')
    msg = <<END_OF_MESSAGE
Hey #{p.santa.name}, 
  You have been randomly selected to be the Secret Santa for #{p.name} (me). 
Remember though, I don't actually know that you've been chosen, so please 
do not tell me. That means don't reply to this message. Otherwise, the 
carefully crafted surprise will be sadly busted.

If you have any questions about the rules for this year, or any logistical 
concerns, please fire up an email to the entire group to get them straightened
out for all involved.

-SECRET SANTA PROGRAM-

END_OF_MESSAGE

    options = {:address => configatron.email.smtp.address,
      :port => configatron.email.smtp.port,
      :domain => configatron.email.smtp.domain,
      :user_name => configatron.email.smtp.username,
      :password => pw,
      :authentication => 'plain',
      :enable_starttls_auto => true  }
    
    Mail.defaults do
      delivery_method :smtp, options
    end
    
    Mail.deliver do
      to "#{p.santa.email}"
      from "#{p.email}"
      subject 'Secret Santa Email'
      body msg
    end
    
    puts "sending from #{p.name} to #{p.santa.name}" if verbose
    puts msg if verbose
  end

end
