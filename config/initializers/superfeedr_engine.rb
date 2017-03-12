# Use the class you use for feeds. (Its name as a string)
# This class needs to have the following attributes/methods:
# * url: should be the main feed url
# * id: a unique id (string) for each feed (can be the primary key in your relational table)
# * secret: a secret which should never change and be unique for each feed. It must be hard to guess. (a md5 or sha1 string works fine!)
SuperfeedrEngine::Engine.feed_class = "Projects::Outline::Feed"

# Base path for the engine don't forget the trailing / and make it hard to guess!
SuperfeedrEngine::Engine.base_path = "/superfeedr_engine/"

# When debugging, you can use tools like https://www.runscope.com/docs/passageway to share your local web server with superfeedr's API via a public URL
SuperfeedrEngine::Engine.host = "afternoon-beyond-53328.herokuapp.com" # Your hostname (no http). Used for webhooks!

# Superfeedr username
SuperfeedrEngine::Engine.login = ENV["SUPERFEEDR_USER"]

# Token value. Make sure it has the associated rights your application needs
SuperfeedrEngine::Engine.password = ENV["SUPERFEEDR_SECRET"]

# Scheme for your webhooks. Defaults to "http", but you should use https in production.
SuperfeedrEngine::Engine.scheme = "http"

# Port for your webhooks. Default to 80. Change it if you use another one or https!
SuperfeedrEngine::Engine.port = 80

# Create Outline Feed instance
Rails.application.config.after_initialize do
	Projects::Outline::Feed.instance
end