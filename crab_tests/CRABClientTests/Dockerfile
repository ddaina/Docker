FROM cmssw/cmsweb:20210122

RUN mkdir -p /data/CRAB3-testing
RUN chmod 777 /data/CRAB3-testing/

ENV WDIR=/data/CRAB3-testing

WORKDIR ${WDIR}

COPY CRABClientScripts ${WDIR}/CRABScripts

ENTRYPOINT ["/bin/bash"]
