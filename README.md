# i3
## Requirements

~~~ bash
grep -v "^#" pkglist.txt | sudo pacman -S --needed -
~~~

``` bash
grep -v "^#" pkglist_aur.txt | yay -S --needed -
```

## IBus Configuration

Add 
~~~ bash
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
~~~

in `/etc/environment`
