"""Entry repository commands."""

from typing import Literal, Optional

import pydantic
from karp.lex_core.value_objects import UniqueId, make_unique_id

from .base import Command


class CreateEntryRepository(Command):
    """Command for creating EntryRepository."""

    id: UniqueId = pydantic.Field(default_factory=make_unique_id)
    name: str
    connection_str: Optional[str] = None
    config: dict
    message: str
    user: str
    cmdtype: Literal["create_entry_repository"] = "create_entry_repository"

    @classmethod
    def from_dict(  # noqa: D102
        cls, data: dict, *, user: str, message: Optional[str] = None
    ) -> "CreateEntryRepository":
        return cls(
            name=data.pop("resource_id"),
            connectionStr=data.pop("connection_str", None),
            config=data,
            user=user,
            message=message or "Entry repository created",
        )
