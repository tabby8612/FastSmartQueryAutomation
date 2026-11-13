import nh3
from bs4 import BeautifulSoup

ALLOWED_TAGS = {
    "p",
    "br",
    "strong",
    "b",
    "i",
    "em",
    "u",
    "s",
    "h1",
    "h2",
    "h3",
    "ul",
    "ol",
    "li",
    "blockquote",
    "a",
    "hr",
}

ALLOWED_ATTRIBUTES = {"a": {"href", "title"}, "p": {"style"}}


def sanitize_html(content: str) -> str:

    return nh3.clean(
        content,
        tags=ALLOWED_TAGS,
        attributes=ALLOWED_ATTRIBUTES,
        url_schemes={"http", "https", "mailto"},
        link_rel="noopener noreferrer",
    )


def plain_text(content: str) -> str:
    if not content:
        return ""

    soup = BeautifulSoup(content, "html.parser")

    return soup.get_text(separator=" ", strip=True)
