FROM debian:bullseye-slim

LABEL maintainer="SubParLou"

# Update and Load initial packages
RUN apt-get update && \
	apt-get install -y nano nginx libnginx-mod-rtmp stunnel4

# Import setting files and set new files
COPY nginx.conf /etc/nginx/nginx.conf
COPY stunnel.conf /etc/stunnel/stunnel.conf

# Create stunnel log directory, log file, and set permissions
RUN mkdir -p /var/log/stunnel4 && \
    touch /var/log/stunnel4/stunnel.log && \
    chown -R nobody:nogroup /var/log/stunnel4

# Make any configuration changes to nginx and stunnel
RUN echo "ENABLED=1" >> /etc/default/stunnel4

# Expose services to host
EXPOSE 1935

# Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/stunnel4/stunnel.log

# Setup Streaming Services Details
# Facebook
ENV FACEBOOK_URL rtmp://localhost:19350/rtmp/
ENV FACEBOOK_KEY ""

# Kick
ENV KICK_URL rtmp://localhost:19351/rtmp/
ENV KICK_KEY ""

# Bolt+
ENV BOLT_URL rtmp://localhost:19352/rtmp/
ENV BOLT_KEY ""

# Restream.io
ENV RESTREAM_URL rtmp://live.restream.io/live/
ENV RESTREAM_KEY ""

# YouTube
ENV YOUTUBE_URL rtmp://a.rtmp.youtube.com/live2/
ENV YOUTUBE_KEY ""

# Twitch
ENV TWITCH_URL rtmp://iad05.contribute.live-video.net/app/
ENV TWITCH_KEY ""

# MixCloud
ENV MIXCLOUD_URL rtmp://rtmp.mixcloud.com/broadcast/
ENV MIXCLOUD_KEY ""

# Copy the entrypoint script and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint and default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
