FROM oraclelinux:8

# git - install rbenv & ruby-build
RUN dnf install -y git 

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc

RUN mkdir -p /root/.rbenv/plugins
RUN git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build

# Build CRuby Dependencies
RUN dnf install -y tar gcc make openssl-devel zlib-devel
RUN source ~/.bashrc
RUN /root/.rbenv/bin/rbenv install truffleruby+graalvm-dev
RUN /root/.rbenv/bin/rbenv global truffleruby+graalvm-dev

# Install nginx
RUN \
    # Explicitly disable PHP to suppress conflicting requests error
    dnf -y module disable php \
    && \
    dnf -y module enable nginx:1.20 && \
    dnf -y install nginx && \
    rm -rf /var/cache/dnf \
    && \
    # forward request and error logs to container engine log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80/tcp
EXPOSE 443/tcp

STOPSIGNAL SIGQUIT

WORKDIR /root/app
COPY app/ .
# RUN gem install bundler
RUN dnf install -y sqlite-devel
RUN echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
RUN source ~/.bashrc && bundle install

COPY puma.rb config/puma.rb

COPY startup.sh /root/startup.sh
RUN ["chmod", "+x", "/root/startup.sh"]
ENTRYPOINT ["/root/startup.sh"]