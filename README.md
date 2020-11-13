# nanovim
a script to create md5-colliding binaries of nano and vim.

## inspiration
much of this process was taken from https://www.mscs.dal.ca/~selinger/md5collision/.

## dependencies
the final gcc flags are:
```
-lz -lmagic -lncursesw -lXaw -lXmu -lXext -lXt -lSM -lICE -lXpm -lXt -lX11 -ldl -lm -lncurses -lelf -lacl -lattr -ldl
```
you should be able to figure out deps from that.

## this is cursed
yeah.
