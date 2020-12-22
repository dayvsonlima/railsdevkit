FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client vim zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
WORKDIR /projects
COPY Gemfile /projects/Gemfile
RUN bundle install

# code-server installation
RUN mkdir -p ~/.cache/code-server
RUN curl -#fL -o ~/.cache/code-server/code-server_3.8.0_amd64.deb.incomplete -C - https://github.com/cdr/code-server/releases/download/v3.8.0/code-server_3.8.0_amd64.deb
RUN mv ~/.cache/code-server/code-server_3.8.0_amd64.deb.incomplete ~/.cache/code-server/code-server_3.8.0_amd64.deb
RUN dpkg -i ~/.cache/code-server/code-server_3.8.0_amd64.deb

COPY ./config.yaml ~/.config/code-server/config.yaml
COPY ./keepalive.sh /keepalive.sh

EXPOSE 8080
# Start the main process.
CMD sh /keepalive.sh