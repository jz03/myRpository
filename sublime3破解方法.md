# sublime3破解方法

> 基于sublime3 version 3.2.2,build 3211 版本

1. 修改hosts文件（不成功时，可以尝试此步骤）

   打开C:\Windows\System32\drivers\etc的hosts文件

   复制以下地址直接粘贴到相应系统的hosts文件内

   ```shell
   127.0.0.1 license.sublimehq.com
   127.0.0.1 www.sublimetext.com
   50.116.34.243 sublime.wbond.net
   50.116.34.243 packagecontrol.io
   ```

   

2. **修改trigger**

   打开软件根目录下的sublime_text.exe，打开显示的是16进制码
   搜索到 **9794 0D00**
   改为  **0000 0000**
   保存

3. **激活**

   打开Sublime Text 3 选择Help -> Enter License 输入

   ```hex
   ----- BEGIN LICENSE -----
   TwitterInc
   200 User License
   EA7E-890007
   1D77F72E 390CDD93 4DCBA022 FAF60790
   61AA12C0 A37081C5 D0316412 4584D136
   94D7F7D4 95BC8C1C 527DA828 560BB037
   D1EDDD8C AE7B379F 50C9D69D B35179EF
   2FE898C4 8E4277A8 555CE714 E1FB0E43
   D5D52613 C3D12E98 BC49967F 7652EED2
   9D2D2E61 67610860 6D338B72 5CF95C69
   E36B85CC 84991F19 7575D828 470A92AB
   ------ END LICENSE ------
   ```

   

