get '/tweets' do
  @tweets = Tweet.all.sort_by { |t| t.elapsed_seconds }
  erb :'tweet/index', locals: {tweets: @tweets}
end

post '/tweets', auth: :user do
  @tweet = Tweet.create(params[:tweet])

  if request.xhr?
    view = erb :'tweet/single', locals: {tweet: @tweet, error: @error}, layout: false
    mini = erb :'user/mini_profile', locals: {user: current_user}, layout: false
    {mini: mini, view: view}.to_json
  else
    redirect '/tweets'
  end
end

delete '/tweet/:id', auth: :user do |id|
  @tweet = Tweet.find(id)
  @tweet.destroy
  @tweets = Tweet.all.sort_by { |t| t.elapsed_seconds }

  if request.xhr?
    index = erb :'tweet/index', locals: {tweets: @tweets}, layout: false
    mini = erb :'user/mini_profile', locals: {user: current_user}, layout: false
    {mini: mini, index: index}.to_json
  else
    redirect '/tweets'
  end
end

post '/tweet/:id/like', auth: :user do |id|
  existing_like = Like.find_by(params[:like])
  @tweet = Tweet.find(id)
  existing_like ? existing_like.destroy : like = Like.create(params[:like])

  (request.xhr?) ? (erb :'tweet/single', locals: {tweet: @tweet}, layout: false) : (redirect '/tweets')
end
