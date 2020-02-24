# centos:7
FROM centos@sha256:285bc3161133ec01d8ca8680cd746eecbfdbc1faa6313bd863151c4b26d7e5a5

RUN \
  yum -y install git unzip sudo socat which && \
  yum clean all

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN \
  yum -y install nodejs && \
  yum clean all

WORKDIR /tmp

RUN git clone --depth 1 https://github.com/kusano/ksnctfc92_problem.git

# md5
RUN \
  useradd md5 && \
  cp -r ksnctfc92_problem/server/md5 /home/ && \
  chown -R root:md5 /home/md5 && \
  chmod 750 /home/md5 && \
  chmod 750 /home/md5/md5 && \
  chmod 750 /home/md5/md5.sh && \
  chmod 640 /home/md5/flag.txt && \
  chmod 640 /home/md5/flag2.txt

# kaisendon
RUN \
  useradd kaisendon && \
  unzip ksnctfc92_problem/problems/W/kaisendon.zip -d /home/ && \
  cp ksnctfc92_problem/W/config.js /home/kaisendon/ && \
  chown -R kaisendon:kaisendon /home/kaisendon && \
  chmod -R 700 /home/kaisendon && \
  sudo -u kaisendon -i npm install

# score
RUN git clone --depth 1 https://github.com/kusano/ksnctfc92.git

RUN \
  useradd score && \
  cp -r ksnctfc92/* /home/score/ && \
  rm -rf /home/score/problems/ && \
  cp -r ksnctfc92_problem/problems/ /home/score/ && \
  cd /home/score && \
  sed -e s/localhost:3000/localhost:10080/ -e 's/"DATABASE_PATH": ".*"/"DATABASE_PATH": "\/home\/score\/data\/database.db"/' config.example.json > config.json && \
  sed -i -e 's/ksnctfc92\.u1tramarine\.blue\/libc.so.6/localhost:10080\/libc.so.6/' problems/E7/problem.json && \
  sed -i -e 's/ksnctfc92\.u1tramarine\.blue/localhost/' problems/E7/problem.json && \
  sed -i -e 's/ksnctfc92\.u1tramarine\.blue/localhost/g' problems/W/problem.json && \
  ln -s /lib64/libc.so.6 public/ && \
  chown -R score:score . && \
  cd - && \
  sudo -u score -i npm install

RUN \
  rm -rf /home/kaisendon/.npm && \
  rm -rf /home/kaisendon/.git && \
  rm -rf /home/score/.npm && \
  rm -rf /home/score/.git && \
  rm -rf /tmp/*

WORKDIR /

CMD \
  sudo -u md5 -i socat tcp-l:55555,reuseaddr,fork system:./md5 &> /dev/null & \
  sudo -u kaisendon -i NODE_ENV=production FLAG1=FLAG{3snoa6p4wncj1hpf} FLAG2=FLAG{vakdriti4zzlj55p} FLAG3=FLAG{bpodf2es4k9e42rf} npm start &> /dev/null & \
  if [ ! -e /home/score/data/database.db ]; then sqlite3 /home/score/data/database.db < /home/score/database.sql; fi; \
  chown -R score:score /home/score/data/; \
  sudo -u score -i NODE_ENV=production PORT=10080 npm start &> /dev/null & \
  echo 'Open http://localhost:10080/'; \
  tail -f /dev/null
