Simple chat logging addon for Garrysmod which uses MySQLOO.

## Setup

1. Extract livechat to the addons folder.
2. Modify sv_config.lua in livechat/lua/livechat/ and set the database settings and a unique id (number) for the server
3. Upload [LiveChat-Web](https://github.com/BlackVoid/livechat-web) to your webserver
4. Modify config.php and set your database settings
5. Add to your loading screen using an iframe or add an menu option on your website to the serverchat.  

    ```http://yourdomain.com/livechat-web/showchat.php?serverID=1&showDate=1&showTeam=1&showSteamID=1```
    ```<iframe src="http://yourdomain.com/livechat-web/showchat.php?serverID=1&showDate=1&showTeam=1&showSteamID=1" width="500" height="500"></iframe>```

## License

The MIT License (MIT)

Copyright (c) 2014 Felix Gustavsson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

