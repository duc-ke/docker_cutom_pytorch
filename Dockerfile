FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

## SERVER SETTING ( UID확인 : echo $(id -u) )
ENV UID=501
USER root
RUN apt-get update && \
    apt-get -y install vim && \
    apt-get -y install sudo && \
    apt-get -y install htop && \
    apt-get -y install screen && \
    apt-get -y install tmux && \
    apt-get -y install locales && \
    apt-get -y install fontconfig && \
    apt-get -y install fonts-nanum* && \
    apt-get -y install libgl1-mesa-glx && \
    apt-get -y install libglib2.0-0

## root ENV SETTING (KOREAN LANGUAGE)
# ENV LANGUAGE ko
RUN echo "export LANGUAGE=ko" >> ~/.bashrc
RUN echo "alias ll='ls -lht'" >> ~/.bashrc
# RUN localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
# RUN locale-gen ko_KR.UTF-8
# ENV LC_ALL ko_KR.UTF-8
RUN echo "export LC_ALL=ko_KR.UTF-8" >> ~/.bashrc
RUN LC_ALL=ko_KR.UTF-8 bash
COPY screenrc.txt ~/.screenrc

## USER CREATE
ARG username="ducke"
RUN useradd -rm -d /home/$username -s /bin/bash -g root -G sudo -u $UID $username
RUN echo "${username} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "${username}:${username}" | chpasswd

USER $username
WORKDIR /home/$username
RUN mkdir wd

## USER ENV SETTING (KOREAN LANGUAGE)
# 참고: https://joycecoder.tistory.com/108
# ENV LANGUAGE ko
RUN echo "export LANGUAGE=ko" >> ~/.bashrc
RUN echo "alias ll='ls -lht'" >> ~/.bashrc
RUN sudo localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
RUN sudo locale-gen ko_KR.UTF-8
# ENV LC_ALL ko_KR.UTF-8
RUN echo "export LC_ALL=ko_KR.UTF-8" >> ~/.bashrc
RUN LC_ALL=ko_KR.UTF-8 bash
COPY screenrc.txt ~/.screenrc


## PYTHON LIBs SETTING
ENV PATH /home/$username/.local/bin:$PATH
RUN pip install scikit-learn \
    && pip install xgboost \
	&& pip install lightgbm \
	&& pip install wandb \
    && pip install imblearn \
    && pip install missingno \
    && pip install gpustats \
    && pip install matplotlib \
    && pip install seaborn \
    && pip install pandas \
    && pip install torchio \
    && pip install gpustats \
    && pip install opencv-python \
    && pip install -U albumentations[imgaug] \
    && pip install jupyter notebook

## MATPLOTLIB KOR SETTING
RUN sudo cp /usr/share/fonts/truetype/nanum/Nanum* /home/${username}/.local/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/
RUN rm -rf /home/${username}/.cache/matplotlib/*

## JUPYTER SETTING
# RUN sudo chown -R $USER:$USER /opt/conda
# RUN conda install jupyter notebook -y
RUN jupyter notebook --generate-config
RUN echo 'c.NotebookApp.password = "argon2:$argon2id$v=19$m=10240,t=10,p=8$VKn8X1zZr6JdorNYUrYvVA$ZthlbFbFKQ44HjZNa5GGFg"' >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

## BASE DIR SETTING
WORKDIR /Users/kehyeong/Documents/projects
