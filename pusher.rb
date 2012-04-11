##################
#
# Pusher spammer
# 
# A small pusher utility to test favmonster's in-browser notifications
#
##################

require 'rubygems'
require 'pusher'
require 'optparse'

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

msg = Hash.new
options = Hash.new

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: pusher [--channel ID, --image SRC, --name NAME, --link URL, --title TITLE, --decoration TYPE] message"

  opts.on('-h', '--help', 'Show help') do
    puts opts
    exit
  end

  opts.on('-c', '--channel ID', 'The channel to send the message to') do |channel|
    options[:channel] = channel
  end

  opts.on('-i', '--image SRC', 'The image you want as logo (50x50)') do |image|
    options[:image] = image
  end

  opts.on('-l', '--link URL', 'The link of the notification') do |link|
    options[:link] = link
  end

  opts.on('-t', '--title TITLE', 'The title of the notification') do |title|
    options[:title] = title
  end

  opts.on('-d', '--decoration TYPE', 'The decoration of the notification') do |decoration|
    options[:decoration] = decoration
  end
end

optparse.parse!


if Pusher.app_id.empty? || Pusher.key.empty? || Pusher.secret.empty?
  puts "Please set PUSHER_APP_ID, PUSHER_KEY and PUSHER_SECRET"
  exit
end

msg[:body] = ARGV.join(' ')
if msg[:body].empty?
  puts "You need a message to send, idiot!"
  exit
end
if options[:channel].nil? || options[:channel].empty?
  puts "You need a channel to send to, stupid!"
  exit
end

msg[:img] = options[:image] || "http://favmonster.com/assets/pusher.png"
msg[:link] = options[:link] || "http://favmonster.com/"
msg[:title] = options[:title] || "Favmonster message"
msg[:decoration] = options[:decoration] || "alert"

begin
  Pusher[options[:channel]].trigger!('message', msg)
  puts "Push sent ok!"
rescue Pusher::Error => e
  puts "Error sending the push: #{e.message}"
  exit
end
