import asyncdispatch, httpclient, json, strutils

var userId: int64 = 0
const api = "https://giftgogame.com/api"
var token: string = ""
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "Host": "giftgogame.com",
    "Content-Type": "application/json",
    "accept": "application/json, text/plain, */*"
  })

proc auth*(initData:string,user:int64): Future[void] {.async.} =
    userId = user
    token = initData
    headers["X-Telegram-Init-Data"] = token

proc get_leaderboard*(category:string,offset:int=0): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let response = await client.get(api & "/get_full_leaderboard?category=" & category & "&offset=" & $offset & "&limit=100&include_current_user=true&include_images=true&env_mode=prod&include_all_positions=true")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc transactions_history*(offset:int=0): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let json = %* {"user_id":userId,"limit":25,"offset":offset,"initData":token}
    let response = await client.post(api & "/transactions/history",body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc referrals_stats*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let json = %* {"user_id":userId,"initData":token}
    let response = await client.post(api & "/referrals/stats",body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc balance_info*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let json = %* {"user_id":userId,"initData":token}
    let response = await client.post(api & "/referrals/balance/info",body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc check_subscription*(task_id:string,channel_id:string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let json = %* {"user_id":userId,"task_id":task_id,"channel_id":channel_id,"force_check":false}
    let response = await client.post(api & "/tasks/check_subscription",body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc referral_link*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let json = %* {"user_id":userId,"initData":token}
    let response = await client.post(api & "/referrals/link",body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc create_invoice*(amount:int): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = headers
    let json = %* {"user_id":userId,"amount":amount,"initData":token}
    let response = await client.post(api & "/create_invoice",body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
