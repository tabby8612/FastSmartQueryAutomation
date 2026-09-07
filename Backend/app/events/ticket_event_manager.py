import asyncio


class TicketEventManager:
    def __init__(self):
        self.listeners: dict[int, list[asyncio.Queue]] = {}

    async def subscribe(self, ticket_id: int):
        queue = asyncio.Queue()

        self.listeners.setdefault(ticket_id, []).append(queue)

        return queue

    def unsubscribe(self, ticket_id: int, queue: asyncio.Queue):
        if ticket_id in self.listeners:
            self.listeners[ticket_id].remove(queue)

    async def publish(self, ticket_id: int, event: dict):
        queues = self.listeners.get(ticket_id, [])

        for queue in queues:
            await queue.put(event)


ticket_events = TicketEventManager()
