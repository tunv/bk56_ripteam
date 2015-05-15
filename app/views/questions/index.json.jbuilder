json.array!(@questions) do |question|
  json.extract! question, :id, :Title, :Description, :Vote, :Unvote, :Content, :user_id
  json.url question_url(question, format: :json)
end
