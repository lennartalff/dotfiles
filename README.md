# i3
## Requirements

~~~ bash
sudo pacman -S - < pkglist.txt
~~~

## IBus Configuration

Add 
~~~ bash
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
~~~

in `/etc/environment`
