# docker volume create emacs-vol
docker run -it \
  --name emacs-for-roam \
  --mount source=emacs-vol,target=/root \
  -e LC_ALL=ko_KR.UTF-8 \
  silex/emacs

# docker run -it \
#   --name emacs-for-roam-2 \
#   --mount source=emacs-vol,target=/root \
#   -e LC_ALL=ko_KR.UTF-8 \
#   9990c7658615

# docker container start -i emacs-for-roam
