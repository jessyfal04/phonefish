import asyncio
import websockets
import ssl
import json
import process

local = True
if not local:
    ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ssl_context.load_cert_chain("/etc/letsencrypt/live/jessyfallavier.dev/fullchain.pem", "/etc/letsencrypt/live/jessyfallavier.dev/privkey.pem")

async def message_handler(websocket, path):
    print(f"O : {str(websocket.remote_address)}")

    try:
        async for json_data in websocket:
            await handle_message(json_data, websocket)
    except websockets.exceptions.ConnectionClosedError:
        print(f"F : {str(websocket.remote_address)}")

async def handle_message(json_data, websocket):
        print(f"R : {websocket.remote_address} | {json_data}")

        message = json.loads(json_data)

        if message["ACTION"] == "ACCEPT":
            await asyncio.create_task(process.processAccept(message, websocket))
        if message["ACTION"] == "OPEN":
            await asyncio.create_task(process.processOpen(message, websocket))
        elif message["ACTION"] == "VIBRATE":
            await asyncio.create_task(process.processVibrate(message, websocket))

async def main():
    print("Serveur en Ouverture\n")
    if not local:
        server = await websockets.serve(message_handler, "87.106.121.154", 50001, ssl=ssl_context)
    else:
        server = await websockets.serve(message_handler, "localhost", 50001)

    await server.wait_closed()
    print("Serveur Fermé\n")

if __name__ == "__main__":
    asyncio.run(main())