SCATTERWAVE

My most ambitious project I ever undertook. Started off as a senior project that I attempted to turn into a full business. Scatterwave's mission was to provide a booking platform for bands and venues and then to promote them to people in the area. I did countless interviews with bands and venues to make sure the feastures being built were the ones that clients cared about and implemented in the most streamlined and intuitive ways.

I built the MVP using Ruby on Rails, before working with a team of 5 developers to get the project production ready. Suspended operations indefinitely at the beginning of COVID-19.

This project has a messaging service, a calender booking component, geolocation data to display locations of venues as well as ones that are in close proximity. It uses Amazon S3 for photo storage, Stripe for payments, Mailgun for emails, Twilio for texting, and deployed on Heroku.

# README

Scatterwave is a website developed in Ruby on Rails.

## Getting Started

    git clone git@gitlab.com:scatterwave/Scatterwave.git
    cd Scatterwave
    bundle install
    rails db:migrate RAILS_ENV=development
    rails s

## Autoformatting

This repository adheres to standard Ruby coding practices with the help of [rubocop](https://github.com/rubocop-hq/rubocop). Be sure to run `rubocop -a` before merging to remain compliant.

## Troubleshooting

### "Rails cannot load such file --bcrypt"

    gem uninstall bcrypt
    gem uninstall bcrypt-ruby
    gem install bcrypt --platform=ruby
    bundle install

Try restarting the rails server with `rails s` afterwards to verify the issue has been resolved

### Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

This error happens when trying to install `pg`

    Installing pg 0.21.0 with native extensions
    Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
    ...
    An error occurred while installing pg (0.21.0), and Bundler cannot continue.

Try [this Stack Overflow solution](https://stackoverflow.com/a/22259364).

# TBD

- Ruby version
- System dependencies
- Configuration
- Database creation
- Database initialization
- How to run the test suite
- Services (job queues, cache servers, search engines, etc.)
- Deployment instructions
- ...
