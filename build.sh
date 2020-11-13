#!/bin/bash
# create md5-colliding binaries of nano and vim
# https://www.mscs.dal.ca/~selinger/md5collision/

# todo: make this a makefile, clean stuff up a lot

echo clearing previous build...
rm -rf evilize*
rm -rf nano*
rm -rf vim*

echo downloading sources...
wget -q https://www.mscs.dal.ca/~selinger/md5collision/downloads/evilize-0.2.tar.gz
wget -q https://www.nano-editor.org/dist/v4/nano-4.3.tar.gz
wget -q https://github.com/vim/vim/archive/v8.1.1661.tar.gz -O vim-8.1.1661.tar.gz

echo extracting sources...
for tar in *.tar.*; do
    tar xf $tar
done

cd ./evilize*/

echo building evilize...
make >/dev/null 2>&1

cd ../nano*/

echo renaming nano main...
sed -i 's,^int main[(],int main_good(,' src/nano.c

echo configuring nano...
./configure >/dev/null 2>&1

echo building nano...
make >/dev/null 2>&1

echo renaming nano symbols...
for obj in $(find -name *.o); do
    for sym in close_buffer open_buffer edit write_list do_mouse do_search; do
        objcopy --redefine-sym $sym=nano_$sym $obj
    done
done

cd ../vim*/

echo renaming vim main...
sed -i 's,^main$,main_evil,' src/main.c

echo configuring vim...
./configure >/dev/null 2>&1

echo building vim...
make >/dev/null 2>&1

echo renaming vim symbols...
for obj in $(find -name *.o); do
    for sym in close_buffer open_buffer edit write_list do_mouse do_search; do
        objcopy --redefine-sym $sym=vim_$sym $obj
    done
done

cd ..

echo linking final program...
gcc -g -O2 -Wall -o nanovim.o evilize*/goodevil.o nano*/src/*.o vim*/src/objects/*.o nano*/lib/libgnu.a -lz -lmagic -lncursesw -lXaw -lXmu -lXext -lXt -lSM -lICE -lXpm -lXt -lX11 -ldl -lm -lncurses -lelf -lacl -lattr -ldl

echo evilizing nanovim into nano and vim...
mkdir bin
./evilize*/evilize nanovim.o -g bin/nano -e bin/vim
