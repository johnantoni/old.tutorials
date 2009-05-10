# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_exp-cookbook_session',
  :secret      => '3e1dda9b30735ef88c5fce97f960e9a54462344473bd828c9bdd1cc48f47c09515b9ec3835b13e933cdfc021600bf28356c0793895b069df06089114b1a1d6dc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
