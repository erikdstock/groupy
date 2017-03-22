FROM ruby:2.3
ENTRYPOINT ["bundle", "exec"]
ARG bundle_path
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1
ENV INSTALL_PATH /src
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH



# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - npm: Install node modules
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update && apt-get install -qq -y build-essential nodejs npm libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends && \
rm -rf /var/lib/apt/lists/*

COPY app/Gemfile* ./

# Uncomment the line below if Gemfile.lock is maintained outside of build process
# COPY Gemfile.lock ./

RUN bundle install --path $bundle_path && \
cp Gemfile.lock $bundle_path

COPY app .
RUN cp $bundle_path/Gemfile.lock ./

# For puma (rails default in script)
CMD ["./script/start.sh"]
# The default command that gets ran will be to start the Unicorn server. [NOT USING]
# CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb"]