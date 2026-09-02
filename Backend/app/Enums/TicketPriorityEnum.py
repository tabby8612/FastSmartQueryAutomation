from enum import Enum


class TicketPriorityEnum(int, Enum):
    LOW = 0
    MEDIUM = 1
    HIGH = 2

    def to_label(escalation_level: int):
        match escalation_level:
            case 0:
                return "low"
            case 1:
                return "medium"
            case 2:
                return "high"
            case _:
                return "low"

    def to_level(priority: str):
        match priority.lower():
            case "low":
                return TicketPriorityEnum.LOW
            case "medium":
                return TicketPriorityEnum.MEDIUM
            case "high":
                return TicketPriorityEnum.HIGH
            case _:
                return TicketPriorityEnum.LOW
