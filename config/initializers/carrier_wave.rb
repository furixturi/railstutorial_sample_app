if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory = ENV['S3_BUCKET']
  end
end

# 1) Sign up for an Amazon Web Services account.
# 2) Create a user via AWS Identity and Access Management (IAM) and record the access key and secret key.
# 3) Create an S3 bucket (with a name of your choice) using the AWS Console, and then grant read and write permission to the user created in the previous step.
# heroku commands for setting environment variables
# $ heroku config:set S3_ACCESS_KEY=AKIAI4KEAKKUEK47FALQ
# $ heroku config:set S3_SECRET_KEY=h7BSnzF78LBYlJ6FPx70R0q6SZtQGXuowzFJOR3m
# $ heroku config:set S3_BUCKET=alabebop-railstutorial-sampleapp
