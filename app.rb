require 'sinatra'
require 'sequel'
require 'json'

get '/' do
  haml :index
end

post '/' do
  begin
    content_type :json
    db = Sequel.connect params["db"]
    results = db[params["sql"]].all
    if not results.empty?
      { 
        :columns => results.first.keys,
        :rows =>  results
      }.to_json
    else
      { :error => 'No Results!'}.to_json
    end
  rescue Exception => err
    { :error => err.message }.to_json
  end
end