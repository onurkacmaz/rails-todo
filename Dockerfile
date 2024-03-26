FROM ruby:latest

# Gerekli paketleri kurun
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Uygulama kodunu çalışma dizinine kopyala
WORKDIR /todo
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

COPY bin/docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000

# Veritabanını bekle
CMD ["rails", "server", "-b", "0.0.0.0"]
