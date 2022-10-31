json.extract! review, :id, :reviewer, :reviewed, :stars, :testo, :created_at, :updated_at
json.url review_url(review, format: :json)
