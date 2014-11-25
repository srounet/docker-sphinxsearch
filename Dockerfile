# use the ubuntu base image 13.10
FROM ubuntu:13.10
MAINTAINER srounet <srounet@gmail.com>

RUN apt-get update && apt-get --yes upgrade
RUN apt-get install --yes curl
RUN apt-get install --yes build-essential
RUN apt-get install --yes libmysqlclient-dev
RUN apt-get install --yes libexpat1
RUN apt-get install --yes libexpat1-dev
RUN apt-get install --yes openssh-server
RUN apt-get install --yes sudo

RUN cd /tmp && curl -O http://sphinxsearch.com/files/sphinx-2.2.6-release.tar.gz
RUN cd /tmp && tar zxvf sphinx-2.2.6-release.tar.gz

RUN cd /tmp && curl -O http://snowball.tartarus.org/dist/libstemmer_c.tgz
RUN cd /tmp && tar zxvf libstemmer_c.tgz
RUN cp -R /tmp/libstemmer_c/* /tmp/sphinx-2.2.6-release/libstemmer_c/

RUN cd /tmp/sphinx-2.2.6-release && ./configure --enable-id64 --with-mysql --without-pgsql --with-libstemmer --with-libexpat --with-iconv --with-unixodbc 
RUN cd /tmp/sphinx-2.2.6-release && make -j4
RUN cd /tmp/sphinx-2.2.6-release && make install

RUN rm -rf /tmp/sphinx-2.2.6-release/ && rm -rf /tmp/libstemmer_c/

EXPOSE 9306 9312 22

RUN mkdir -p /var/log/sphinx
RUN mkdir -p /var/lib/sphinx
RUN mkdir -p /var/lib/sphinx/indexes/dummy/
RUN mkdir -p /var/run/sphinx

ADD searchd.sh /
RUN chmod a+x searchd.sh

# Add basic sphinx conf
ADD sphinx.conf /usr/local/etc/sphinx.conf
ADD dummy.xml /tmp/dummy.xml

RUN mkdir /var/run/sshd 
RUN echo 'root:toor' | chpasswd

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# create users
# password is sphinx
RUN useradd -m -d /home/sphinx -p ts2CpSxHw.wxM sphinx
RUN adduser sphinx sudo && chsh -s /bin/bash sphinx
RUN echo "sphinx password is sphinx"

# Create our dummy index
RUN indexer --all

CMD ["/usr/sbin/sshd", "-D"]