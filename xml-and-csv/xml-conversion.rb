#!/usr/bin/ruby

require "rubygems"
require "builder"

params = {
  'from' => 'my@localmachine.com',
  'to' => 'john@theworkinggroup.ca',
  'subject' => 'test subject',
  'message' => 'test message'
}

xml = Builder::XmlMarkup.new( :target => $stdout, :indent => 2 )
xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"

xml.params do
  params.each do | name, choice |
    xml.param( choice, :item => name )
  end
end

