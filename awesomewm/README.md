# AWESOME WM config

## 설치 방법

### apt에서 awesomewm 설치

```
sudo apt install awesome
```

### 로그인시 awesome wm을 사용하기

Ubuntu 20.04 로그인 시 계정을 선택하고 나서, 비밀번호를 입력하기 전에
window manager를 선택할 수 있다. 글을 작성하는 시점 기준으로 오른쪽
아래에 톱니 모양의 아이콘을 클릭해서 window manager를 설정할 수 있다.

### awesome copycat 설치

<https://github.com/lcpz/awesome-copycats> 를 따라서 설치한다.

아래는 위 GitHub README.md에서 복사한 내용이다.

```
git clone --recursive https://github.com/lcpz/awesome-copycats.git
mv -bv awesome-copycats/* ~/.config/awesome && rm -rf awesome-copycats
```

```
cd ~/.config/awesome
cp rc.lua.template rc.lua
```

### awesome copycat 커스터마이징

awesome wm의 기본 설정은 약간 빈약하다. awesome copycat은 설정이
풍부하나, alt키를 적극적으로 사용해서 다른 도구와 키 매핑이 많이
겹친다.

awesome copycat에는 GUI키(Windows key)와 h,j,k,l을 사용해서 윈도우를
전환시키는 설정이 들어있다. 매우 편리하다.

README.md 파일과 함께 있는 rc.lua를 ~/.config/awesome/에 소프트 링크를
만들자.

```
ln -s -r rc.lua $HOME/.config/awesome/rc.lua
```

### .xsessionrc 설치

뒤에서 적힐 여러 문제해결을 위해 .xsessionrc를 설치한다. awesome wm이
뜰 때 실행된다.

```
ln -s -r -b xsessionrc $HOME/.xsessionrc
```

### rofi 설치

프로그램을 실행시키는 도구다. 잘 동작한다.
<https://github.com/davatorium/rofi>

### awesome wm widget 설치

```
cd ./.config/awesome/
git clone https://github.com/streetturtle/awesome-wm-widgets
```

## 문제 해결

### 여러 모니터 설정하기

arandr을 통해서 모니터가 어떻게 연결할지 조절할 수 있다. arandr에서
설정을 저장하면 실행 가능한 쉘 스크립트가 만들어진다. 이 쉘 스크립트를
자동으로 실행되게 만들자.

arandr 페이지: <https://christian.amsuess.com/tools/arandr/>

## 프로그램 실행하기

기본으로 제공되는 프로그램 실행 방법은 불편하다. rofi를 설치해서
편하게 프로그램을 실행하자. <https://github.com/davatorium/rofi>

### 와이파이와 배터리, 화면 밝기, 블루투스

awesome wm을 사용하면 그놈 데스크톱 환경에서 제공하던 많은 도구들의
대체제를 찾아야 한다. 지금은 데스크탑이라서 딱히 설정하지 않았지만,
노트북에서 사용할 시, 다음 기능들을 제공하는 도구들을 설정해야 한다.

와이파이 설정하는 도구, 남은 배터리 사용량을 보여주는 도구, 화면의
밝기를 조절하는 도구.

### Ubuntu 20.04에서 .xinitrc가 호출 안되는 문제

window manager에 대한 많은 글들을 읽다 보면 ~/.xinitrc에 설정을
작성하라는 말들이 있다. ~/.xinitrc가 window manager가 뜨기 전에
실행된다고 한다. 하지만 Ubuntu 20.04에서 내가 직접 세팅하는 경우
실행이 되지 않았다.

xinit의 man 페이지를 보면, display manager가 없는 경우 실행되다고
나온다. 우리가 설정한 방법은 로그인시 Ubuntu의 기본 UI를 사용한다. 이
UI가 gdm이기 때문에 xinit이 실행되지 않고, .xinitrc가 실행되지 않는
것으로 보인다.

대신 사용할 수 있는 방법이 두 가지 있다. 하나는 .xsessionrc 파일을
사용하는 것이고, 다른 하나는 systemd를 사용하는 것이다.

.xsessionrc는 X session이 생성될 때 호출된다.[^debian-xsessionrc] X
session이 정확히 무엇인지는 모르겠지만, 컴퓨터를 켜고 로그인 했을 때
부터 로그아웃 할 때까지 유지되는 환경으로 보인다. .xsessionrc의 설정에
관해서는 [Debian wiki에 있는 글](https://wiki.debian.org/Xsession)이
잘 설명하고 있다.

systemd는 시스템이 동작할 때 자동으로 켜져야 하는 프로그램들을 켜주는
프로그램이다. 특정 사용자만을 위한 프로그램들도 등록할 수 있다.
프로그램들 사이에 의존성을 설정할 수 있다. graphical-session.target에
의존을 걸면 편리하다. [이 블로그
글](https://goral.net.pl/post/systemd-x-sessions/)에 잘 설명되어 있다.

### ibus 한글 문제

gnome에서는 알아서 잘 실행하던 한글 입력기가 자동으로 실행되지 않는다.
위의 내용을 바탕으로 xsessionrc나 systemd를 사용해서 ibus daemon이
자동으로 실행되게 설정해야 한다.

ibus 사용 시 마우스 근처에 언어 선택 팝업이 떠서 마우스 사용을
불편하게 만드는 경우가 있다. 아직 이 문제에 대한 해결 방법을 찾지
못했다.

### xinput과 마우스 스크롤

그놈에서 사용했을 때에 비해서 스크롤 속도 등이 다르게 반영되기도 한다.
나 같은 경우 트랙볼의 스크롤 속도는 똑같지만, ergodox의 스크롤 속도는
너무 빨라졌다. 이를 xinput에서 수정하고 싶었지만, 설정 값을 찾지 못했다.

xinput을 사용해보면, 지금 연결된 마우스와 키보드 리스트를 볼 수 있고,
마우스와 키보드 각각에 대해서 설정할 수 있는 프로퍼티 목록을 확인하고
수정할 수 있다.

마우스 스크롤 속도를 바꾸는 방법으로 xinput에서 evdev관련 프로퍼티를
수정하라는 글들이 많다. 하지만 내 환명에서는 관련 설정이 없었다.
libinput에 관한 프로퍼티는 많지만 evdev에 관한 프로퍼티는 없었다.

키보드의 스크롤 기능을 쓰는 대신에 다른 스크롤 방법을 찾았다. xinput의
libinput 프로퍼티 중에 마우스 가운데 버튼을 누르고 마우스를 움직이면
스크롤이 되도록 설정하는 프로퍼티가 있다. 이를 설정하면 기존 스크롤
기능 없어도 꽤 편하게 스크롤 할 수 있다. 가로 스크롤과 세로 스크롤을
동시 해야 하는 경우, 이 기능이 기존 기능보다 더 편리하다.


