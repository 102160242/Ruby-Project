json.extract! question, :id, :question_content, :created_at, :updated_at
json.url question_url(question, format: :json)
