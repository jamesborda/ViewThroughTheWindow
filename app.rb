require 'rubygems'
require 'sinatra'
require 'data_mapper'
#require 'carrierwave/datamapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

#class ImageUploader < CarrierWave::Uploader::Base
#  include CarrierWave::MiniMagick
#  storage :file
#end

class Post
  include DataMapper::Resource  
  property :post_id,      Serial
  property :city,         String
  property :country,      String
  property :thoughts,     String  
  property :created_at, DateTime
  property :user_name,	String
  property :user_email,	String 
  property :image1,		 String
  property :image2,		 String
  #mount_uploader :source, ImageUploader
end

DataMapper.auto_upgrade!


  
# Main page: view all posts
get '/' do
@posts = Post.all(:order => [ :post_id.desc ], :limit => 20)
  erb :index
end

# Create Post
post '/post/create' do
  post = Post.new(:thoughts => params[:thoughts])
  post.created_at = Time.now
  path1 = 'uploads/' + params[:pic1][:filename]
  File.open('public/' + path1, "w") do |f|
      f.write(params[:pic1][:tempfile].read)
  end
  post.image1 = path1
  path2 = 'uploads/' + params[:pic2][:filename]
  File.open('public/' + path2, "w") do |f|
      f.write(params[:pic2][:tempfile].read)
  end
  post.image2 = path2
    
  if post.save
    status 201
    redirect '/'  
  else
    status 412
    redirect '/posts'   
  end
end

