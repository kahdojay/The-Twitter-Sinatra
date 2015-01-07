get '/tweets' do
  @tweets = Tweet.all.sort_by { |t| t.elapsed_time }
  erb :'tweet/index'
end

post '/tweets' do
  @tweet = Tweet.create(params[:tweet])
  if request.xhr?
    erb :'tweet/single', locals: {tweet: @tweet}, layout: false
  else
    redirect '/tweets'
  end
end

delete '/tweet/:id' do |id|
  @tweet = Tweet.find(id)
  @tweet.destroy
  redirect '/tweets'
end

post '/tweet/:id/like' do |id|
  existing_like = Like.find_by(params[:like])
  @tweet = Tweet.find(id)
  if existing_like
    existing_like.destroy
  else
    like = Like.create(params[:like])
  end

  if request.xhr?
    {tweet: @tweet, like: like, like_count: @tweet.likes.count }.to_json
  else
    redirect '/tweets'
  end
end
