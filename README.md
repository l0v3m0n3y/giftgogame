# giftgogame
telegram mini app api for gift go bot nim-lang library
# Example
```nim
import asyncdispatch,giftgogame,json
waitFor auth("initData",userid)
let data = waitFor balance_info()
echo data["main_balance"].getInt()
```
# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
