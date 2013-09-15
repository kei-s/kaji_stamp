json.array!(@tasks) do |task|
  json.extract! task, :name, :completed_at, :point, :user_id
  json.url task_url(task, format: :json)
end
