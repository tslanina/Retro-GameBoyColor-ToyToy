cd src
rgbasm -o../build/toytoy.obj toytoy.asm
rgbasm -o../build/ball.obj ./objects/ball.asm
rgbasm -o../build/blob.obj ./objects/blob.asm
rgbasm -o../build/heart.obj ./objects/heart.asm
rgbasm -o../build/player.obj ./objects/player.asm
rgbasm -o../build/spike.obj ./objects/spike.asm
rgbasm -o../build/toy.obj ./objects/toy.asm
rgbasm -o../build/credits.obj credits.asm
rgbasm -o../build/inter.obj inter.asm
rgbasm -o../build/title.obj title.asm
rgbasm -o../build/spr.obj spr.asm
rgbasm -o../build/info.obj info.asm

rgblink -m../build/toytoy.map -n../build/totoy.sym -o../rom/toytoy.gbc ../build/toytoy.obj ../build/ball.obj ../build/blob.obj ../build/heart.obj ../build/player.obj ../build/spike.obj ../build/toy.obj ../build/credits.obj ../build/title.obj ../build/spr.obj ../build/inter.obj ../build/info.obj
rgbfix -v -p0 ../rom/toytoy.gbc

