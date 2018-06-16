FROM python:2
LABEL maintainer "Webysther Nunes <webysther@gmail.com>"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo curl wget
RUN apt-get install -y nano vim zsh curl git sudo zip
RUN apt-get install -y ghostscript

RUN pip install pip --upgrade
RUN pip install peepdf

RUN useradd -m pdftools && \
  adduser pdftools sudo && \
  echo "pdftools:pdftools" | chpasswd
RUN chsh -s /bin/zsh pdftools

WORKDIR /home/pdftools

ADD tools /opt/tools

# Using the version with score
RUN cd /opt/tools && \
	git clone https://github.com/jbremer/peepdf.git && \
	cd peepdf && \
	git checkout gsoc

RUN cp /opt/tools/pdfconvert /usr/bin/ && chmod +x /usr/bin/pdfconvert
RUN cp /opt/tools/score /usr/bin/ && chmod +x /usr/bin/score

RUN apt-get autoremove --purge -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER pdftools
ENV HOME /home/pdftools

CMD [ "/bin/bash" ]
