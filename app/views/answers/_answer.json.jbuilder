json.extract! answer, :id, :question_id, :answer_content, :right_answer, :created_at, :updated_at
json.url answer_url(answer, format: :json)
