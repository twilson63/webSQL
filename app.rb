require 'sinatra'
require 'sequel'
require 'json'

db_url = 'tinytds://cpadmin:stars@174.129.140.194/gct_prod'

get '/' do
  haml :index
end

post '/' do
  begin
    content_type :json
    db = Sequel.connect db_url
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